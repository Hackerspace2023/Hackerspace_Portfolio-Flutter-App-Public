import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'drawer_widget.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> with SingleTickerProviderStateMixin {
  List<dynamic> members = [];
  List<dynamic> filteredMembers = [];
  String selectedCategory = "All";

  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    loadMembers();

    // Initialize the animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Animate the glowing effect along a circular path and change multiple colors
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: Colors.greenAccent,
      end: Colors.blueAccent,
    ).animate(_animationController);
  }

  Future<void> loadMembers() async {
    final String response = await rootBundle.loadString('assets/members.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      members = data;
      filteredMembers = members; // Initialize with all members
    });
  }

  void filterMembersByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredMembers = category == "All"
          ? members
          : members.where((member) => member['category'] == category).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Our Members"),
      ),
      drawer: const AppDrawer(),
      body: CustomPaint(
        painter: PointedHexagonGridPainter(),
        child: Column(
          children: [
            // Category Filter
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...["All", "Android", "Website", "Python", "Frontend", "Backend", "Others"].map(
                          (category) => Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: _buildOption(category, isActive: selectedCategory == category),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Member List
            Expanded(
              child: filteredMembers.isEmpty
                  ? const Center(child: Text("No members found!"))
                  : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  return _buildMemberCard(filteredMembers[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String category, {required bool isActive}) {
    return GestureDetector(
      onTap: () => filterMembersByCategory(category),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? Colors.greenAccent : Colors.transparent,
          border: Border.all(color: Colors.greenAccent),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.greenAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return AnimatedContainer(
          duration: const Duration(seconds: 1),
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _colorAnimation.value!, width: 2),
            gradient: LinearGradient(
              colors: [Colors.greenAccent.withOpacity(0.3), Colors.blueAccent.withOpacity(0.3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.3, 0.7],
            ),
            boxShadow: [
              BoxShadow(
                color: _colorAnimation.value!.withOpacity(0.6),
                blurRadius: 15,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(member['image']),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member['role'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildSocialMediaIcon('assets/images/linkedin.png', member['linkedin']),
                          const SizedBox(width: 8),
                          _buildSocialMediaIcon('assets/images/github.png', member['github']),
                          const SizedBox(width: 8),
                          _buildSocialMediaIcon('assets/images/twitter.png', member['twitter']),
                          const SizedBox(width: 8),
                          _buildSocialMediaIcon('assets/images/Instagram.png', member['instagram']),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSocialMediaIcon(String assetPath, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Image.asset(
        assetPath,
        height: 24,
        width: 24,
        color: Colors.white,
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}

class PointedHexagonGridPainter extends CustomPainter {
  final Offset? hoveredHexagon;

  PointedHexagonGridPainter({this.hoveredHexagon});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[900]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const hexRadius = 30.0;
    final hexWidth = sqrt(3) * hexRadius;
    final hexHeight = 2 * hexRadius;

    for (double y = 0; y < size.height + hexHeight; y += hexHeight * 0.75) {
      bool isOffsetRow = ((y ~/ (hexHeight * 0.75)) % 2 == 1);

      for (double x = 0; x < size.width + hexWidth; x += hexWidth) {
        double xOffset = isOffsetRow ? hexWidth / 2 : 0;

        final center = Offset(x + xOffset, y);

        if (center.dx - hexRadius > size.width || center.dy - hexRadius > size.height) {
          continue;
        }

        final isHovered = hoveredHexagon != null &&
            (center - hoveredHexagon!).distance <= hexRadius * 2;

        drawHexagon(canvas, isHovered ? paint : paint, center, hexRadius);
      }
    }
  }

  void drawHexagon(Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = pi / 180 * (60 * i - 30);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'drawer_widget.dart';
import 'dart:math';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<dynamic> members = [];
  List<dynamic> filteredMembers = [];
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    loadMembers();
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
      bottomNavigationBar: _buildBottomNavigationBar(),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF00FF95)),
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
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildSocialMediaIconWithIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hacker Space",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 9),
                    const Text(
                      "Join our community and explore endless possibilities.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        hintText: "Enter Your Email",
                        hintStyle: const TextStyle(color: Colors.greenAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.greenAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Follow Us On",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSocialMediaLink("Instagram", "https://instagram.com"),
                    _buildSocialMediaLink("X/ Twitter", "https://twitter.com"),
                    _buildSocialMediaLink("Whatsapp", "https://whatsapp.com"),
                    _buildSocialMediaLink("Github", "https://github.com"),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              const Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Languages",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("C & C++", style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 8),
                    Text("Javascript", style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 8),
                    Text("Html & Css", style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 8),
                    Text("Python", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white70),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "All Rights Reserved",
                style: TextStyle(color: Colors.greenAccent),
              ),
              GestureDetector(
                onTap: () => _launchURL("https://example.com/terms"),
                child: const Text(
                  "Terms & Cond...",
                  style: TextStyle(color: Colors.greenAccent),
                ),
              ),
              GestureDetector(
                onTap: () => _launchURL("https://example.com/privacy"),
                child: const Text(
                  "Privacy",
                  style: TextStyle(color: Colors.greenAccent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildSocialMediaLink(String name, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white70,
          decoration: TextDecoration.underline,
        ),
      ),
    );
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

    final hoverPaint = Paint()
      ..color = const Color(0xFF00FF95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

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

        drawHexagon(canvas, isHovered ? hoverPaint : paint, center, hexRadius);
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

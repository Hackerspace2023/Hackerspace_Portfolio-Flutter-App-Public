import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/services.dart';
import 'drawer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  Offset? hoveredHexagon;
  List<dynamic> projects = [];
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    final String response = await rootBundle.loadString('assets/projects.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      projects = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredProjects = selectedCategory == "All"
        ? projects
        : projects.where((project) => project["category"] == selectedCategory)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Projects"),
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  hoveredHexagon = details.localPosition;
                });
              },
              onPanEnd: (_) {
                setState(() {
                  hoveredHexagon = null;
                });
              },
              child: CustomPaint(
                painter: PointedHexagonGridPainter(
                    hoveredHexagon: hoveredHexagon),
                size: MediaQuery
                    .of(context)
                    .size,
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
                  const Text(
                    "Our Projects",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Explore our diverse range of projects that showcase innovation and creativity.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Options Section
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildOption(
                            "All", isActive: selectedCategory == "All"),
                        const SizedBox(width: 10),
                        _buildOption(
                            "Android", isActive: selectedCategory == "Android"),
                        const SizedBox(width: 10),
                        _buildOption(
                            "Website", isActive: selectedCategory == "Website"),
                        const SizedBox(width: 10),
                        _buildOption(
                            "Python", isActive: selectedCategory == "Python"),
                        const SizedBox(width: 10),
                        _buildOption(
                            "Others", isActive: selectedCategory == "Others"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Project Cards Section
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredProjects.length,
                    itemBuilder: (context, index) {
                      final project = filteredProjects[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: _buildProjectCard(
                          title: project["title"],
                          description: project["description"],
                          githubLink: project["githubLink"],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildOption(String text, {bool isActive = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF00FF95) : Colors.transparent,
          border: Border.all(color: const Color(0xFF00FF95)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(
      {required String title, required String description, required String githubLink}) {
    return GestureDetector(
      onTap: () => _launchURL(githubLink),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF00FF95)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Column: Hacker Space Info
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
                    const SizedBox(height: 8),
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
                          borderSide: const BorderSide(color: Colors
                              .greenAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20), // Add spacing between columns

              // Middle Column: Follow Us On
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

              const SizedBox(width: 20), // Add spacing between columns

              // Right Column: Languages
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Languages",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        "C & C++", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    const Text(
                        "Javascript", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    const Text(
                        "Html & Css", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    const Text(
                        "Python", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white70),
          const SizedBox(height: 10),

          // Bottom Links
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "All Copyrights Reserved",
                style: TextStyle(color: Colors.greenAccent),
              ),
              GestureDetector(
                onTap: () => _launchURL("https://example.com/terms"),
                child: const Text(
                  "Terms & Conditions",
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

  Widget _buildSocialMediaLink(String name, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }


  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode
            .externalApplication, // Ensures the browser opens externally
      );
    } else {
      throw "Could not launch $url";
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

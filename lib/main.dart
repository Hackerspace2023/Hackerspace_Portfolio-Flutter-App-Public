import 'package:flutter/material.dart';
import 'dart:math';
import 'drawer_widget.dart';
import 'about_us.dart';
import 'projects.dart';
import 'events.dart';
import 'gallery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontFamily: 'Audiowide', // Custom font
            color: Color(0xFF00FF95),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Audiowide', color: Colors.white),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    Offset? _hoveredHexagon;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hacker Space"),
      ),
      drawer: const AppDrawer(),
      body: Stack(
          children: [
          // Hexagonal background
          GestureDetector(
          onPanUpdate: (details) {
            _hoveredHexagon = details.localPosition;
    },
      onPanEnd: (_) {
        _hoveredHexagon = null;
      },
      child: CustomPaint(
        painter: PointedHexagonGridPainter(hoveredHexagon: _hoveredHexagon),
        size: MediaQuery.of(context).size,
      ),
    ),
    SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/hackerspace_logo.jpeg',
                    height: 100,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hacker Space',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Audiowide',
                      color: Color(0xFF00FF95),
                    ),
                  ),
                  const Text(
                    "Let's hack the future",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // About Us Section
            _buildSectionTitle("About Us"),
            _buildSectionCard(
              content:
              "Hacker Space is a community of tech enthusiasts driven by innovation and collaboration. Join us to explore the cutting edge of technology!",
              buttonText: "Learn More",
              onButtonPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutUsPage(),
                  ),
                );
              },
            ),

            // Projects Section
            _buildSectionTitle("Our Projects"),
            _buildProjectCard(
              title: "Lorem Ipsum",
              description:
              "Explore our latest projects in cybersecurity, AI, and open-source.",
              image: 'assets/images/sample_project.png',
              onTap: () {
                // Define the action when the card is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectsPage(),
                  ),
                );
                },
            ),

            // Members Section
            _buildSectionTitle("Our Members"),
            _buildMemberCard(
              name: "John Doe",
              description:
              "An AI enthusiast with a passion for open-source projects.",
              profileImage: 'assets/images/sample_member.png',
              onTap: (){
                Navigator.push(context, 
                MaterialPageRoute(builder: (context)=> const GalleryPage()));
              },
            ),

            // Connect With Us Section
            _buildSectionTitle("Connect With Us"),
            const _ConnectWithUsSection(),

            // Footer Section
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "© 2024 Hacker Space. All Rights Reserved.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
    ),
          ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontFamily: 'Audiowide',
          color: Color(0xFF00FF95),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String content,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF00FF95)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              content,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FF95),
                foregroundColor: Colors.black,
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard({
    required String title,
    required String description,
    required String image,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF00FF95)),
      ),
      child: ListTile(
        leading: Image.asset(image, height: 50, fit: BoxFit.cover),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontFamily: 'Audiowide'),
        ),
        subtitle: Text(description, style: const TextStyle(color: Colors.grey)),
        onTap: onTap,
      ),

    );
  }

  Widget _buildMemberCard({
    required String name,
    required String description,
    required String profileImage,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF00FF95)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(profileImage),
          radius: 25,
        ),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white, fontFamily: 'Audiowide'),
        ),
        subtitle: Text(description, style: const TextStyle(color: Colors.grey)),
        onTap: onTap,
      ),
    );
  }
}

class _ConnectWithUsSection extends StatelessWidget {
  const _ConnectWithUsSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.email, color: Color(0xFF00FF95)),
          onPressed: () {},
        ),
        IconButton(
          icon: Image.asset(
            'assets/images/linkedin.png', // Your LinkedIn icon
            height: 40,
            width: 40,
          ),
          onPressed: () {
            // LinkedIn button action
          },
        ),
        IconButton(
          icon: const Icon(Icons.web, color: Color(0xFF00FF95)),
          onPressed: () {},
        ),
      ],
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
    final hexWidth = sqrt(3) * hexRadius; // Width of each hexagon
    final hexHeight = 2 * hexRadius; // Height of each hexagon
    const verticalSpacing = 0.0;

    for (double y = 0; y < size.height + hexHeight; y += hexHeight * 0.75 + verticalSpacing) {
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

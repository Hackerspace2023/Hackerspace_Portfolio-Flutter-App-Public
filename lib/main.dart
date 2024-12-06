import 'package:flutter/material.dart';
import 'dart:math';

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
        scaffoldBackgroundColor: const Color(0xFF0D0D0D), // Dark hex background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00FF95), // Neon green
          ),
        ),
      ),
      home: const MyHomePage(title: 'Hacker Space'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Offset? _hoveredHexagon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Hexagonal grid background
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _hoveredHexagon = details.localPosition;
                });
              },
              onPanEnd: (_) {
                setState(() {
                  _hoveredHexagon = null;
                });
              },
              child: CustomPaint(
                painter: PointedHexagonGridPainter(hoveredHexagon: _hoveredHexagon),
                size: MediaQuery.of(context).size,
              ),
            ),
            // About Us section at the top
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "About Us",
                        style: TextStyle(
                          color: Color(0xFF00FF95), // Neon green title
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "A Community of students having similar interest in the field of coding, "
                            "where one can learn, implement, and share new skills. "
                            "Here students get more exposure and get to know about the industrial experiences of working seniors. "
                            "Hackerspace always maintains a friendly environment for students to develop new skills and go beyond the boundaries.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
    final hexWidth = sqrt(3) * hexRadius; // Width of each hexagon
    final hexHeight = 2 * hexRadius; // Height of each hexagon
    const verticalSpacing = 0.0; // Vertical space between rows
    const maxOverlapPercentage = 0.3; // Allow hexagons to extend up to 30% outside

    for (double y = 0; y < size.height + hexHeight; y += hexHeight * 0.75 + verticalSpacing) {
      bool isOffsetRow = ((y ~/ (hexHeight * 0.75)) % 2 == 1);

      for (double x = 0; x < size.width + hexWidth; x += hexWidth) {
        double xOffset = isOffsetRow ? hexWidth / 2 : 0;

        final center = Offset(x + xOffset, y);

        // Skip hexagons that exceed 30% overlap beyond screen boundaries
        bool isOutOfRightBoundary = center.dx - hexRadius > size.width * (1 + maxOverlapPercentage);
        bool isOutOfBottomBoundary = center.dy - hexRadius > size.height * (1 + maxOverlapPercentage);
        if (isOutOfRightBoundary || isOutOfBottomBoundary) {
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
      final angle = pi / 180 * (60 * i - 30); // Calculate angle for each vertex
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint); // Draw the hexagon path
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

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
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00FF95),
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
      body: Stack(
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
              painter: FlatHexagonGridPainter(hoveredHexagon: _hoveredHexagon),
              size: MediaQuery.of(context).size,
            ),
          ),
          // About Us content at the top-center
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "About Us",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "A community of students with similar interest in the field of coding, "
                      "where one can learn, implement, and share new skills.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FlatHexagonGridPainter extends CustomPainter {
  final Offset? hoveredHexagon;

  FlatHexagonGridPainter({this.hoveredHexagon});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final hoverPaint = Paint()
      ..color = const Color(0xFF00FF95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    const hexRadius = 30.0; // Radius of the hexagon
    final hexWidth = sqrt(3) * hexRadius; // Width of flat-topped hexagon
    final hexHeight = 2 * hexRadius; // Height of flat-topped hexagon

    // Adjusted spacing for a consistent pattern
    const horizontalSpacing = 2.0; // Horizontal space between hexagons
    const verticalSpacing = 0.0; // Minimal vertical space between rows

    for (double y = -hexHeight; y < size.height + hexHeight; y += hexHeight * 0.75 + verticalSpacing) {
      for (double x = -hexWidth; x < size.width + hexWidth; x += hexWidth + horizontalSpacing) {
        final isOffset = ((y ~/ (hexHeight * 0.75)) % 2 == 1);
        final xOffset = isOffset ? (hexWidth / 2) : 0;

        final center = Offset(x + xOffset, y);

        // Draw hexagon
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

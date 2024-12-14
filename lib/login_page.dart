import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'register_page.dart';
import 'home_page.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  // Function to login user with email and password
  void loginUser(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('https://b43f-2405-201-8021-2002-8142-bada-2ff5-adab.ngrok-free.app/login.php'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if login is successful
        if (data['status'] == 'success') {
          // Fetch and save user data
          await fetchUserDataAndSave(context, email);

          // Navigate to HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${data['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Unable to connect to server')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Function to fetch user data from the PHP API and save to SharedPreferences
  Future<void> fetchUserDataAndSave(BuildContext context, String email) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(
        Uri.parse('https://b43f-2405-201-8021-2002-8142-bada-2ff5-adab.ngrok-free.app/get_user_data.php?email=$email'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check for error in response
        if (data['error'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['error'])),
          );
          return;
        }

        // Save user data in SharedPreferences
        prefs.setString('name', data['name']);
        prefs.setString('phone', data['phone_number']);
        prefs.setString('email', email);
        prefs.setString('gender', data['gender']);

        print('User data saved successfully.');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: PointedHexagonGridPainter(),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.black.withOpacity(0.9),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                          value!.isEmpty ? 'Please enter your email' : null,
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          obscureText: true,
                          validator: (value) =>
                          value!.isEmpty ? 'Please enter your password' : null,
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              loginUser(context);
                            }
                          },
                          child: Text("Log In"),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()),
                            );
                          },
                          child: Text(
                            "Don't have an account? Create now.",
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for the Hexagon Grid
class PointedHexagonGridPainter extends CustomPainter {
  final Offset? hoveredHexagon;

  PointedHexagonGridPainter({this.hoveredHexagon});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final hoverPaint = Paint()
      ..color = const Color(0xFF00FF95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    const hexRadius = 30.0;
    final hexWidth = sqrt(3) * hexRadius;
    final hexHeight = 2 * hexRadius;
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

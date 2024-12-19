import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hackerspace/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String gender = "Male";

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> saveUserDetails(String name, String email, String phone,
      String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", name);
    await prefs.setString("email", email);
    await prefs.setString("phone", phone);
    await prefs.setString("gender", gender);
  }

  Future<void> registerUser() async {
    final url = Uri.parse(
        "https://41cc-2405-201-8021-2002-11b8-1d04-9635-7ea2.ngrok-free.app/register_user");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text,
        "email": emailController.text,
        "phone_number": phoneController.text,
        "gender": gender,
        "password": passwordController.text,
      }),
    );

    final responseData = jsonDecode(response.body);
    if (responseData['success']) {
      await saveUserDetails(
        nameController.text,
        emailController.text,
        phoneController.text,
        gender,

      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
      // Ensure navigation happens after showing the SnackBar
      WidgetsBinding.instance.addPostFrameCallback((_) {

      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Registration failed: ${responseData['message']}")),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final url = Uri.parse(
            "https://41cc-2405-201-8021-2002-11b8-1d04-9635-7ea2.ngrok-free.app/register_user");

        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": googleUser.displayName,
            "email": googleUser.email,
            "google_sign_in": true,
          }),
        );

        final responseData = jsonDecode(response.body);
        if (responseData['success']) {
          await saveUserDetails(
            googleUser.displayName ?? "",
            googleUser.email,
            "",
            "Google",
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
          // Ensure navigation happens after showing the SnackBar
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                "Google Sign-In failed: ${responseData['message']}")),
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In error: $error")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: PointedHexagonGridPainter(),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 16),
                  DropdownButton<String>(
                    value: gender,
                    onChanged: (String? newValue) {
                      setState(() {
                        gender = newValue!;
                      });
                    },
                    dropdownColor: Colors.black,
                    items: ["Male", "Female", "Other"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                            value, style: TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    style: TextStyle(color: Colors.black),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: registerUser,
                    child: Text("Register"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: signInWithGoogle,
                    child: Text("Sign in with Google"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      // Navigate to the login screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text(
                      "Have an account? Log in here.",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      // Navigate to the login screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                    child: const Text(
                      "Login as guests?Click here!.",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
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
      ..color = Colors.black!
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

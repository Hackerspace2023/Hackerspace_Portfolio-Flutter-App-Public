import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hackerspace/login_page.dart';
import 'package:hackerspace/main.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String phoneNumber = '';
  String gender = 'Male';
  String password = '';

  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  void registerUser() async {
    try {
      _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) {
        User? user = _firebaseAuth.currentUser;
        if (user != null) {
          _firestore.collection('users').doc(user.uid).set({
            'name': name,
            'email': email,
            'phone_number': phoneNumber,
            'gender': gender,
          });
          //The syntax of documents saved in firebase cloud storage.

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User registered successfully!')),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
          );
        }
      });
    } catch (e) {
      print("Error registering user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register user')),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

        User? user = userCredential.user;
        if (user != null) {
          // Save additional user data to Firestore
          _firestore.collection('users').doc(user.uid).set({
            'name': user.displayName ?? 'Unknown',
            'email': user.email ?? 'No Email',
            'photoUrl': user.photoURL ?? '',
            'gender': gender,
            'phone_number':phoneNumber
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signed in with Google!')),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
          );
        }
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hexagon grid background
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: PointedHexagonGridPainter(),
          ),
          // Registration form
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
                        // Sign Up Now heading
                        Text(
                          "Sign Up Now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Name",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          validator: (value) =>
                          value!.isEmpty ? 'Please enter your name' : null,
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                        ),
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
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your phone number'
                              : null,
                          onChanged: (value) {
                            setState(() {
                              phoneNumber = value;
                            });
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: gender,
                          dropdownColor: Colors.black,
                          onChanged: (String? newValue) {
                            setState(() {
                              gender = newValue!;
                            });
                          },
                          items: ['Male', 'Female', 'Other']
                              .map((genderOption) => DropdownMenuItem(
                            child: Text(
                              genderOption,
                              style: TextStyle(color: Colors.white),
                            ),
                            value: genderOption,
                          ))
                              .toList(),
                          decoration: InputDecoration(
                            labelText: "Gender",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              registerUser();
                            }
                          },
                          child: Text("Register"),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          icon: Icon(Icons.login),
                          label: Text("Sign Up with Google"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: signInWithGoogle,
                        ),
                        SizedBox(height: 20),
                        // Log In Text
                        // Log In Text
                        GestureDetector(
                          onTap: () {
                            // Navigate to the homepage
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your HomePage widget
                            );
                          },
                          child: Text(
                            "Have an account? Log in now.",
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

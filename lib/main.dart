import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'register_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  Future<void> navigateBasedOnAuth(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if user details exist in SharedPreferences
    final name = prefs.getString("name");
    final email = prefs.getString("email");

    print("Name: $name, Email: $email"); // Debugging line

    if (name != null && email != null) {
      // User exists, navigate to HomePage
      print("User found, navigating to HomePage...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // No user data found, navigate to RegisterPage
      print("No user data, navigating to RegisterPage...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trigger navigation logic after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) => navigateBasedOnAuth(context));

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show a loading indicator while waiting
      ),
    );
  }
}

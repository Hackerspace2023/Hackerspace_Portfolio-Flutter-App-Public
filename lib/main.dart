import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'register_page.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //To set up firebase just add the command flutterfire configure and if flutterfire is installed then
  //the list of projects will be shown then just select the project and then the give the permission to override the firebase
  //by typing yes.
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

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    Future<void> navigateBasedOnAuth() async {
      try {
        // Get the current user
        User? user = auth.currentUser;

        if (user == null) {
          // Navigate to RegisterPage if no user is logged in
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage()),
                (route) => false,
          );
        } else {
          // Navigate to HomePage if the user is logged in
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,

          );
        }
      } catch (e) {
        // Handle any unexpected errors
        debugPrint("Error in navigateBasedOnAuth: $e");
      }
    }

    // Trigger navigation after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) => navigateBasedOnAuth());

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show a loading indicator
      ),
    );
  }
}

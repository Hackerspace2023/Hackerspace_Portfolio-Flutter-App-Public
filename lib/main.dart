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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hacker Space"),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
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
            ),

            // Projects Section
            _buildSectionTitle("Our Projects"),
            _buildProjectCard(
              title: "Lorem Ipsum",
              description:
              "Explore our latest projects in cybersecurity, AI, and open-source.",
              image: 'assets/images/sample_project.png',
            ),

            // Members Section
            _buildSectionTitle("Our Members"),
            _buildMemberCard(
              name: "John Doe",
              description:
              "An AI enthusiast with a passion for open-source projects.",
              profileImage: 'assets/images/sample_member.png',
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

  Widget _buildSectionCard({required String content, required String buttonText}) {
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
              onPressed: () {},
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
      ),
    );
  }

  Widget _buildMemberCard({
    required String name,
    required String description,
    required String profileImage,
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

// class AppDrawer extends StatelessWidget {
//   const AppDrawer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: [
//           DrawerHeader(
//             decoration: const BoxDecoration(color: Colors.black),
//             child: Center(
//               child: Column(
//                 children: [
//                   Image.asset('assets/images/hackerspace_logo.jpeg', height: 80),
//                   const Text(
//                     'Hacker Space',
//                     style: TextStyle(fontSize: 24, color: Color(0xFF00FF95)),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.info, color: Color(0xFF00FF95)),
//             title: const Text("About Us"),
//             onTap: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }

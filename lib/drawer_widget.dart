import 'package:flutter/material.dart';
import 'main.dart';
import 'about_us.dart';
import 'projects.dart';
import 'events.dart';
import 'gallery.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/hackerspace_logo.jpeg', height: 80),  // Adjust the height as needed
                  const SizedBox(height: 10),
                  const Text(
                    'Hacker Space',
                    style: TextStyle(
                      fontFamily: 'Audiowide',
                      fontSize: 28,
                      color: Color(0xFF00FF95),
                    ),
                  ),
                ],
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home, color: Color(0xFF00FF95)),
            title: const Text(
              'Home',
              style: TextStyle(fontFamily: 'Audiowide', color: Colors.white),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Color(0xFF00FF95)),
            title: const Text(
              'About Us',
              style: TextStyle(fontFamily: 'Audiowide', color: Colors.white),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lightbulb, color: Color(0xFF00FF95)),
            title: const Text(
              'Projects',
              style: TextStyle(fontFamily: 'Audiowide', color: Colors.white),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProjectsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.event, color: Color(0xFF00FF95)),
            title: const Text(
              'Events',
              style: TextStyle(fontFamily: 'Audiowide', color: Colors.white),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const EventsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album, color: Color(0xFF00FF95)),
            title: const Text(
              'Our Members',
              style: TextStyle(fontFamily: 'Audiowide', color: Colors.white),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const GalleryPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

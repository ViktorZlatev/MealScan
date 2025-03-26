import 'package:scan_app/pages/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:ui';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    _buildPage("🏠 Welcome to Flutter App!", "This is the home screen where you can start exploring the app."),
    _buildPage("ℹ️ App Info", "Version: 1.0.0\nThis app is designed to help users manage their tasks efficiently."),
    _buildSettingsPage(),
  ];

  static Widget _buildPage(String title, String description) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeIn(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
                shadows: [
                  Shadow(color: Colors.black45, blurRadius: 10),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SlideInUp(
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSettingsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("⚙️ Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          BounceInRight(
            child: SwitchListTile(
              title: const Text("Enable Notifications", style: TextStyle(color: Colors.white)),
              value: true,
              onChanged: (bool value) {},
              activeColor: Colors.greenAccent,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              // ignore: deprecated_member_use
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),
          _pages[_selectedIndex],
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
            children: const [
              TextSpan(text: "Flutter ", style: TextStyle(color: Colors.greenAccent)),
              TextSpan(text: "App", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const AuthScreen()));
            },
          )
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            // ignore: deprecated_member_use
            BoxShadow(color: Colors.greenAccent.withOpacity(0.4), spreadRadius: 5, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            // ignore: deprecated_member_use
            backgroundColor: Colors.green.withOpacity(0.8),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black87,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info"),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:ui';
import 'package:scan_app/pages/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: Start(
        isDarkMode: _isDarkMode,
        onThemeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
        },
      ),
    );
  }
}

class Start extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const Start({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildPage("🏠 Welcome!"),
      _buildAboutPage(),
      _buildSettingsPage(),
    ];
  }


 static Widget _buildPage(String title) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 100), // more scroll space
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          FadeInDown(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Color(0xFF50C878),
                shadows: [
                  Shadow(color: Colors.black38, blurRadius: 10, offset: Offset(2, 4))
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          //const SizedBox(height: 20),
          
          const SizedBox(height: 30),
          // 👇 Crazy unique text section
          ZoomIn(
            child: Text(
              "✨ Our Unique Recipe Superpowers ✨",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFFB388FF), // light purple
                shadows: [
                  Shadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2))
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          _crazyFeatureBox("🎨 Creativity", "Discover new ways to cook based on what you already have!"),
          _crazyFeatureBox("🔥 Originality", "Every suggestion is uniquely generated from your receipts."),
          _crazyFeatureBox("📊 Smart Analysis", "We analyze your shopping patterns to improve suggestions."),
          _crazyFeatureBox("💡 Simplicity", "Just snap a pic of your receipt and let the app do the magic."),
        ],
      ),
    ),
  );
}


static Widget _crazyFeatureBox(String title, String description) {
  return ZoomIn(
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) {}, // required for hover to work
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // ignore: deprecated_member_use
              Colors.greenAccent.shade100.withOpacity(0.8),
              // ignore: deprecated_member_use
              Colors.teal.withOpacity(0.8),
              // ignore: deprecated_member_use
              Colors.lightGreen.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
          // ignore: deprecated_member_use
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black, blurRadius: 6)],
              ),
            ),
            const SizedBox(height: 12), // consistent spacing
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildAboutPage() {
    return Center(
      child: SingleChildScrollView(
       child: Padding( 
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            ElasticIn(
              child: Container(
                  margin: const EdgeInsets.only(top: 45 , bottom: 20), // Add margin top here
                  child: Text(
                    "ℹ️ About",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF50C878),
                      shadows: [Shadow(color: Colors.black38, blurRadius: 10)],
                    ),
                  ),
                ),
            ),
            const SizedBox(height: 20),
            _buildStyledText(
              "Recipe Ideas based on your supermarket receipts!",
            ),
            _buildStyledText(
              "Welcome to the Recipe Idea Generator App!\n\nOur app takes your scanned grocery receipts and transforms them into creative recipe suggestions, helping you get the most out of the ingredients you already have.",
            ),
            _buildStyledText(
              "Key Features:"
              "\n"
              " \n ✔️ Scan your supermarket receipts to generate meal ideas based on the items you bought."
              " \n "
              " \n ✔️ Get fresh, creative recipe suggestions every week, "
                        "helping you make the most of your ingredients."
              " \n "
              " \n ✔️ Save and organize your favorite recipes"
                        "in a personalized cookbook."
              " \n "
              "\n ✔️ Stay inspired with new meal ideas"
                        " for every occasion!",
            ),
            _buildStyledText(
              "Our goal is to make cooking fun, easy, and full of surprises. Let's turn your grocery list into delicious meals, one receipt at a time! ",
            ),

           ],
         ),
        ),
      ),
    );
  }

  Widget _buildStyledText(String text) {
    return BounceInUp(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
          // ignore: deprecated_member_use
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildSettingsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BounceInRight(
            child: Text(
              "⚙️ Settings",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          const SizedBox(height: 10),
          BounceInRight(
            child: SwitchListTile(
              title: Text("Enable Notifications", style: GoogleFonts.roboto(fontSize: 16, color: Colors.black)),
              value: true,
              onChanged: (bool value) {},
              activeColor: Color(0xFF50C878),
            ),
          ),
          BounceInRight(
            child: SwitchListTile(
              title: Text("Dark Mode", style: GoogleFonts.roboto(fontSize: 16, color: Colors.black)),
              value: widget.isDarkMode,
              onChanged: (bool value) {
                widget.onThemeChanged(value);
              },
              activeColor: Color(0xFF50C878),
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
              gradient: LinearGradient(
                colors: [Color(0xFFF5E6DA), Color(0xFFFFF8F2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              // ignore: deprecated_member_use
              child: Container(color: Colors.white.withOpacity(0.2)),
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
            children: [
              TextSpan(text: "Meal ", style: TextStyle(color: Color(0xFF50C878))),
              TextSpan(text: "Scan", style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
            },
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // ignore: deprecated_member_use
        backgroundColor: Color(0xFF50C878).withOpacity(0.9),
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class YourRecipesPage extends StatelessWidget {
  const YourRecipesPage({super.key});

  final List<Map<String, String>> dummyRecipes = const [
    {"title": "Avocado Toast", "description": "Quick healthy breakfast idea."},
    {"title": "Choco Smoothie", "description": "Energy booster drink."},
    {"title": "Spicy Tofu Bowl", "description": "Vegan lunch option."},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF5E6DA), Color(0xFFFFF7F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: FadeIn(
        duration: const Duration(milliseconds: 800),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Your AI Recipes",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
            const SizedBox(height: 25),
            ...dummyRecipes.map(
              (recipe) => BounceInUp(
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      recipe['title']!,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green.shade800,
                      ),
                    ),
                    subtitle: Text(
                      recipe['description']!,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

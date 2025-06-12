import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'openai_service.dart';

class YourRecipesPage extends StatelessWidget {
  const YourRecipesPage({super.key});

  Future<void> _generateRecipes(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final productsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('extractedData')
        .doc('products')
        .get();

    if (!productsSnapshot.exists || productsSnapshot.data() == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Няма намерени продукти.")),
      );
      return;
    }

    final data = productsSnapshot.data()!;
    final List<dynamic> productsList = data['products'] ?? [];

    if (productsList.isEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Няма налични продукти за генериране на рецепти.")),
      );
      return;
    }

    final formattedProducts = productsList.join(', ');

    try {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Генериране на рецепти...")),
      );

      final recipesText = await OpenAIService.generateRecipes(formattedProducts);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('extractedData')
          .doc('recipes')
          .set({'recipesText': recipesText});

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Рецептите са генерирани успешно!")),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Грешка при генериране: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("Please log in to see your recipes."));
    }

    final recipesDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('extractedData')
        .doc('recipes');

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF5E6DA), Color(0xFFFFF7F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: StreamBuilder<DocumentSnapshot>(
        stream: recipesDocRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<Map<String, String>> recipesList = [];

          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final String recipesText = data['recipesText'] ?? '';

            final sections = recipesText.split(RegExp(r'Рецепта \d+:'));
            for (int i = 1; i < sections.length; i++) {
              final section = sections[i].trim();
              final lines = section.split('\n');
              final title = lines[0].trim();
              String description = '';
              final descIndex = lines.indexWhere((l) => l.startsWith('Описание:'));
              if (descIndex != -1) {
                description = lines.sublist(descIndex).join('\n').replaceFirst('Описание:', '').trim();
              }
              recipesList.add({'title': title, 'description': description});
            }
          }

          return FadeIn(
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
                const SizedBox(height: 15),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _generateRecipes(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Генерирай рецепти',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                if (recipesList.isEmpty)
                  Center(
                    child: Text(
                      "Все още няма рецепти.",
                      style: GoogleFonts.poppins(fontSize: 18, color: Colors.green.shade700),
                    ),
                  )
                else
                  ...recipesList.map(
                    (recipe) => BounceInUp(
                      child: Card(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: ExpansionTile(
                          title: Text(
                            recipe['title'] ?? 'No title',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.green.shade800,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                recipe['description'] ?? 'No description',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

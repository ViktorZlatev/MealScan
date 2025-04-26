import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  final List<Map<String, String>> products = const [
    {"name": "Tomatoes", "desc": "Fresh and organic."},
    {"name": "Olive Oil", "desc": "Cold-pressed extra virgin."},
    {"name": "Garlic", "desc": "Flavor booster for every dish."},
    {"name": "Basil", "desc": "Aromatic and fresh."},
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
                "Available Products",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
            const SizedBox(height: 25),
            ...products.map(
              (item) => BounceInLeft(
                child: Card(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      item['name']!,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green.shade800,
                      ),
                    ),
                    subtitle: Text(
                      item['desc']!,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

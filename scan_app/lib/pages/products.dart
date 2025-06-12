import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _productController = TextEditingController();

  Future<void> _addProduct(String newProduct) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || newProduct.trim().isEmpty) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('extractedData')
        .doc('products');

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final existingProducts = List<String>.from(docSnapshot.data()?['products'] ?? []);
      existingProducts.add(newProduct.trim());
      await docRef.set({'products': existingProducts}, SetOptions(merge: true));
    } else {
      await docRef.set({'products': [newProduct.trim()]});
    }

    _productController.clear();
  }

  Future<void> _deleteProduct(String productToRemove) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('extractedData')
        .doc('products');

    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      final List<dynamic> currentProducts = docSnapshot.data()?['products'] ?? [];
      currentProducts.remove(productToRemove);

      await docRef.set({'products': currentProducts}, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("Please log in to see your products."));
    }

    final productsDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('extractedData')
        .doc('products');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5E6DA), Color(0xFFFFF7F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Your Products",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                   textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _productController,
                      decoration: InputDecoration(
                        labelText: "Add product manually",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _addProduct(_productController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Add"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: productsDocRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(
                      child: Text(
                        "No scanned products found yet.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final List<dynamic> products = data['products'] ?? [];

                  if (products.isEmpty) {
                    return const Center(
                      child: Text("Your product list is empty."),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index].toString();

                      return FadeInUp(
                        delay: Duration(milliseconds: 100 * index),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.shopping_basket_rounded),
                            title: Text(
                              product,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => _deleteProduct(product),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

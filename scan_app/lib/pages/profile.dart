import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email = "";
  String creationDate = "";
  String username = "";
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  void fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email ?? "";
      creationDate =
          user.metadata.creationTime?.toLocal().toString().split(' ')[0] ?? "";
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        username = doc['username'] ?? "User";
        _usernameController.text = username;
        setState(() {});
      }
    }
  }

  void updateUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'username': _usernameController.text.trim(),
      });
      setState(() {
        username = _usernameController.text.trim();
      });

      // Show custom snackbar in the center
      // ignore: use_build_context_synchronously
      final overlay = Overlay.of(context);
      final overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          left: MediaQuery.of(context).size.width * 0.25,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
             
              child: Text(
                'Saved!',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
              ),
             
            ),
          ),
        ),
      );

      overlay.insert(overlayEntry);
      await Future.delayed(const Duration(seconds: 2));
      overlayEntry.remove();
    }
  }

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
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green.shade100,
                    child: Icon(Icons.person, size: 40, color: Colors.green.shade800),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        BounceInLeft(
                          child: ListTile(
                            leading: const Icon(Icons.email, color: Colors.green),
                            title: Text("Email", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                            subtitle: Text(email),
                          ),
                        ),
                        BounceInRight(
                          child: ListTile(
                            leading: const Icon(Icons.calendar_today, color: Colors.green),
                            title: Text("Account Created", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                            subtitle: Text(creationDate),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "Edit Username",
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.green.shade900),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 3,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter new username',
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: updateUsername,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.save, color: Colors.white),
              label: Text("Save", style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

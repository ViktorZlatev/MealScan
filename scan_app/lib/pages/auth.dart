import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:scan_app/pages/home.dart';
import 'package:scan_app/pages/start.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  bool isLogin = true;
  String errorMessage = '';

  void authenticateUser() async {
    try {
      if (isLogin) {
        if (usernameController.text.isEmpty) {
          setState(() {
            errorMessage = "Please enter your username.";
          });
          return;
        }

        var userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: usernameController.text.trim())
            .get();

        if (userQuery.docs.isEmpty) {
          setState(() {
            errorMessage = "No account found for this username.";
          });
          return;
        }

        String userEmail = userQuery.docs.first['email'];

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail,
          password: passwordController.text.trim(),
        );
      } else {
        if (usernameController.text.isEmpty) {
          setState(() {
            errorMessage = "Username cannot be empty.";
          });
          return;
        }

        var usernameCheck = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: usernameController.text.trim())
            .get();

        if (usernameCheck.docs.isNotEmpty) {
          setState(() {
            errorMessage = "This username is already taken.";
          });
          return;
        }

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'createdAt': Timestamp.now(),
        });
      }

      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = "No account found for this username.";
            break;
          case 'wrong-password':
            errorMessage = "Incorrect password. Please try again.";
            break;
          case 'email-already-in-use':
            errorMessage = "This email is already registered.";
            break;
          case 'invalid-email':
            errorMessage = "Please enter a valid email address.";
            break;
          case 'weak-password':
            errorMessage = "Password must be at least 6 characters.";
            break;
          default:
            errorMessage = "Authentication failed. Please try again.";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Start()),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF5E6DA),
          image: const DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: FadeIn(
            duration: const Duration(milliseconds: 1200),
            child: Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLogin ? "Login" : "Sign Up",
                    style: GoogleFonts.lobster(
                      fontSize: 30,
                      color: Colors.green.shade700,
                    ),
                  ),
                  if (errorMessage.isNotEmpty)
                    FadeInUp(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                  if (!isLogin)
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: "Email"),
                    ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: authenticateUser,
                    child: Text(isLogin ? "Login" : "Sign Up"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                        errorMessage = '';
                        usernameController.clear();
                        emailController.clear();
                        passwordController.clear();
                      });
                    },
                    child: Text(isLogin ? "Create an Account" : "Already have an account? Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

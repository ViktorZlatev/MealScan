import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String username = "User";
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  Uint8List? _webImageBytes;
  String _extractedText = "";
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  void fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          username = userDoc['username'] ?? "User";
        });
      }
    }
  }

  Future<void> uploadImg() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  if (kIsWeb) {
                    final bytes = await pickedFile.readAsBytes();
                    setState(() {
                      _webImageBytes = bytes;
                      _image = pickedFile;
                      _extractedText = '';
                    });
                  } else {
                    setState(() {
                      _image = pickedFile;
                      _extractedText = '';
                    });
                  }
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                if (!kIsWeb) {
                  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _image = pickedFile;
                      _extractedText = '';
                    });
                  }
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scanText() async {
    if (_image == null || _isProcessing) return;

    setState(() {
      _isProcessing = true;
      _extractedText = '';
    });

    try {
      final inputImage = kIsWeb
          ? InputImage.fromBytes(
              bytes: _webImageBytes!,
              metadata: InputImageMetadata(
                size: Size(1000, 1000),
                rotation: InputImageRotation.rotation0deg,
                format: InputImageFormat.bgra8888,
                bytesPerRow: 1000 * 4,
              ),
            )
          : InputImage.fromFilePath(_image!.path);

      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      setState(() {
        _extractedText = recognizedText.text;
      });

      // ✅ Save to Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('scans')
            .add({
              'text': recognizedText.text,
              'timestamp': FieldValue.serverTimestamp(),
            });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scan saved to your account.')),
        );
      }

      textRecognizer.close();
    } catch (e) {
      setState(() {
        _extractedText = "Error during scan: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey("scan"),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF5E6DA), Color(0xFFFFF7F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: FadeIn(
          duration: const Duration(seconds: 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: uploadImg,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Welcome, $username",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      BounceInDown(
                        child: Icon(
                          MdiIcons.barcodeScan,
                          size: 100,
                          color: Colors.green.shade800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Scan to get creative recipes",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (_image != null)
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: kIsWeb
                                  ? Image.memory(_webImageBytes!, height: 150)
                                  : Image.file(File(_image!.path), height: 150),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _isProcessing ? null : scanText,
                              child: _isProcessing
                                  ? const CircularProgressIndicator()
                                  : const Text("Scan Text"),
                            ),
                          ],
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
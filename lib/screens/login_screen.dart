import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panchayat_raj/screens/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/logbg.jpg"), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // Allow scrolling if content overflows
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 250),
                    const Center(
                      child: Text(
                        "Login with Phone Number",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Phone Number Input
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: const TextStyle(color: Colors.white),
                        prefixText: "+91 ",
                        prefixStyle: const TextStyle(color: Colors.white),
                        suffixIcon:
                            const Icon(Icons.phone, color: Colors.white),
                        filled: true,
                        fillColor: Colors.black.withOpacity(
                            0.5), // Semi-transparent black background
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.green),
                        ),
                      ),
                      style: const TextStyle(
                          color: Colors.white), // White text inside the input
                    ),
                    const SizedBox(height: 20),
                    // Send OTP Button
                    ElevatedButton(
                      onPressed: () async {
                        final phoneNumber = "+91${phoneController.text.trim()}";

                        if (phoneController.text.isEmpty ||
                            phoneController.text.length < 10) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Enter a valid phone number")),
                          );
                          return;
                        }

                        try {
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: phoneNumber,
                            verificationCompleted:
                                (PhoneAuthCredential credential) {
                              print("Auto-verification completed: $credential");
                            },
                            verificationFailed: (FirebaseAuthException e) {
                              print("Verification failed: ${e.message}");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: ${e.message}")),
                              );
                            },
                            codeSent:
                                (String verificationId, int? resendToken) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OtpScreen(verificationId: verificationId),
                                ),
                              );
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {
                              print("Code auto-retrieval timeout.");
                            },
                          );
                        } catch (e) {
                          print("Error sending OTP: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to send OTP: $e")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Button color
                        minimumSize: const Size(
                            double.infinity, 60), // Larger button size
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Send OTP",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
  }
}

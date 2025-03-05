import 'dart:developer';
import 'package:panchayat_raj/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpScreen extends StatefulWidget {
  String verificationId;
  OtpScreen({super.key,required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter OTP"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/logbg.jpg', // Replace with your actual image path
              fit: BoxFit.cover,
            ),
          ),
          // Foreground Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.symmetric(horizontal: 25),),
                const Text(
                  "Enter the OTP sent to your phone",
                  style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold), // Add color for better visibility
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "OTP",
                    hintStyle: const TextStyle(color: Colors.white), // Add hint color for better visibility
                    suffixIcon: const Icon(Icons.phone, color: Colors.white),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.green), // Border color
                    ),
                  ),
                  style: const TextStyle(color: Colors.green), // Text color
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential credential =
                      await PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: otpController.text.toString(),
                      );
                      FirebaseAuth.instance.signInWithCredential(credential).then((value){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context)=> HomeScreen()));
                      });
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Button color
                    minimumSize: const Size(double.infinity, 60), // Larger button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Verify OTP",
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
        ],
      ),
    );
  }
}



import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/logbg.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: const TextStyle(color: Colors.black), // White label text
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[400]!), // Green border when focused
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), // Grey border when not focused
                    ),
                    filled: true,
                    fillColor: Colors.white70, // Semi-transparent white background
                  ),
                  cursorColor: Colors.green, // Green cursor
                  style: const TextStyle(color: Colors.black), // Black input text
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    labelStyle: const TextStyle(color: Colors.black), // White label text
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[400]!), // Green border when focused
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), // Grey border when not focused
                    ),
                    filled: true,
                    fillColor: Colors.white70, // Semi-transparent white background
                  ),
                  cursorColor: Colors.green, // Green cursor
                  style: const TextStyle(color: Colors.black), // Black input text
                  keyboardType: TextInputType.phone, // Phone keyboard for phone number field
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Green button background
                    foregroundColor: Colors.white, // White button text color
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Button padding
                    textStyle: const TextStyle(fontSize: 18), // Button text size
                  ),
                  child: const Text(
                    "Sign Up",
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
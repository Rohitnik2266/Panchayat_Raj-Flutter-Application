import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          // Car Illustration
          Center(
            child: Image.asset(
              'assets/images/login.jpg',
              height: 300,
            ),
          ),
          const SizedBox(height: 20),
          // Title with modern font
          Text(
            'Welcome',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle with improved font
          Text(
            'Ghar bete Paye Yojanao Ka Labh..!!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          // Navigation Button
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueGrey,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () {
                  // Navigate to the next screen
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

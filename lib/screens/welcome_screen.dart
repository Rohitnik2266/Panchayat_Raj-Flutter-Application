import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          // Illustration
          Center(
            child: Image.asset(
              'assets/images/login.jpg',
              height: 300,
            ),
          ),
          const SizedBox(height: 20),
          // Title
          Text(
            'Welcome',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          Text(
            'Ghar bete Paye Yojanao Ka Labh..!!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.9),
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

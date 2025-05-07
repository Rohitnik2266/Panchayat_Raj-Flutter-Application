import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme mode (dark or light)
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
            AppLocalizations.of(context)!.welcome, // Fetching localized 'Welcome' text
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          Text(
            AppLocalizations.of(context)!.subTitle, // Fetching localized subtitle text
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.9),
            ),
          ),
          const Spacer(),
          // Theme Switcher (commented out as per request)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.darkMode, // Localized text for Dark Mode
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: isDark,
                  onChanged: (value) {
                    // Toggle the theme
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Navigation Button
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
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

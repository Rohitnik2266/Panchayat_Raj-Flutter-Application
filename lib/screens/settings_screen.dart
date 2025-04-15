import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:panchayat_raj/theme_provider.dart';
import 'package:panchayat_raj/main.dart'; // For MyApp.setLocale
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'en';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the current locale from context and update dropdown
    final locale = Localizations.localeOf(context);
    if (_selectedLanguage != locale.languageCode) {
      setState(() {
        _selectedLanguage = locale.languageCode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// 🌗 Theme Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t.darkMode),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🌐 Language Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t.language),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  onChanged: (String? newLang) {
                    if (newLang != null) {
                      setState(() {
                        _selectedLanguage = newLang;
                      });
                      MyApp.setLocale(context, Locale(newLang));
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'mr', child: Text('Marathi')),
                    DropdownMenuItem(value: 'kn', child: Text('Kannada')),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ℹ️ About App
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(t.aboutApp),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Panchayat Raj App',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.apps),
                  children: [Text('This app helps villagers access government services, '
                      'track application statuses, and stay updated on new schemes.')],
                );
              },
            ),

            const SizedBox(height: 10),

            /// 🔓 Sign Out
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: Text(t.signOut),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => true);
              },
            ),
          ],
        ),
      ),
    );
  }
}

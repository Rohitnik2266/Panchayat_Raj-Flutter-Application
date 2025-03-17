import 'package:flutter/material.dart';
import 'package:panchayat_raj/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:panchayat_raj/screens/feedback_screen.dart';
import 'package:panchayat_raj/screens/welcome_screen.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDarkMode = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
          body: WillPopScope(
            onWillPop: () async => false,
            child: SingleChildScrollView(
              child: Padding( // Added Padding for better spacing
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 30.0),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            isDarkMode ? Colors.grey[800]! : const Color.fromARGB(255, 7, 225, 7),
                            isDarkMode ? Colors.grey[700]! : const Color.fromARGB(255, 193, 234, 193),
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'UserName',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildSettingsOption(
                      context,
                      icon: Icons.info,
                      title: 'About',
                      subtitle: 'Learn more about the app',
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Panchayat Raj App',
                          applicationVersion: '1.0.0',
                          applicationIcon: const Icon(Icons.app_settings_alt),
                          children: const [
                            Text(
                              'This app helps villagers access government services, '
                                  'track application statuses, and stay updated on new schemes.',
                            ),
                          ],
                        );
                      },
                    ),
                    _buildSettingsOption(
                      context,
                      icon: Icons.feedback,
                      title: 'Send Feedback',
                      subtitle: 'Let us know how we can improve',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Divider(color: isDarkMode ? Colors.grey[600] : Colors.grey[300]),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildAccountOption(
                            context,
                            title: 'Sign Out',
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                                    (Route<dynamic> route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsOption(BuildContext context,
      {required IconData icon,
        required String title,
        required String subtitle,
        Widget? trailing,
        required VoidCallback onTap}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return ListTile(
      leading: Icon(icon, color: isDarkMode ? Colors.white : Colors.green),
      title: Text(title, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
      subtitle: Text(subtitle, style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, color: Colors.grey,),
      onTap: onTap,
    );
  }

  Widget _buildAccountOption(BuildContext context,
      {required String title, required VoidCallback onTap}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    return ListTile(
      title: Text(title, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
      onTap: onTap,
    );
  }
}
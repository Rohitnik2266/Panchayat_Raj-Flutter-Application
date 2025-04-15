import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:panchayat_raj/theme_provider.dart';
import 'package:panchayat_raj/screens/feedback_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? userName;
  String? imageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userName = userDoc.data()?['name'];
        imageUrl = userDoc.data()?['profilePhoto'];
        isLoading = false;
      });
    }
  }

  Future<void> pickAndUploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      final storageRef =
      FirebaseStorage.instance.ref().child('profile_photos/${user.uid}.jpg');
      await storageRef.putFile(file);

      final url = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'profilePhoto': url,
      });

      setState(() {
        imageUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    isDarkMode ? Colors.grey[800]! : const Color(0xFF0C50AA),
                    isDarkMode ? Colors.grey[700]! : const Color(0xFF7995BA),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: pickAndUploadImage,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: imageUrl != null
                                ? NetworkImage(imageUrl!)
                                : const AssetImage('assets/images/default_profile.png')
                            as ImageProvider,
                          ),
                          const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit, size: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      userName ?? t.defaultUserName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildSettingsOption(
              context,
              icon: Icons.feedback,
              title: t.sendFeedback,
              subtitle: t.feedbackSubtitle,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FeedbackScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context,
      {required IconData icon,
        required String title,
        required String subtitle,
        Widget? trailing,
        required VoidCallback onTap}) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return ListTile(
      leading: Icon(icon, color: isDarkMode ? Colors.white : Colors.blueGrey),
      title: Text(title,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
      subtitle: Text(subtitle,
          style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,
    );
  }
}

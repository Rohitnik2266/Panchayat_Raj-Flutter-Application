import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Localization import
import 'otp_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> _verifyPhoneAndProceed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    String phone = numberController.text.trim();
    String name = nameController.text.trim();
    String completePhone = "+91$phone";

    try {
      // Check if the number is already registered
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where('number', isEqualTo: phone)
          .get();

      if (query.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.phoneNumberAlreadyRegistered)),
        );
        setState(() => isLoading = false);
        return;
      }

      // Start phone number verification
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: completePhone,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.verificationFailed(e.message ?? 'Unknown error'))),
          );
          setState(() => isLoading = false);
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                verificationId: verificationId,
                name: name,
                number: phone,
              ),
            ),
          );
          setState(() => isLoading = false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorOccurred)),
      );
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                Center(
                  child: Image.asset(
                    "assets/images/lo.png",
                    height: 250,
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: nameController,
                  validator: (value) => value!.isEmpty
                      ? AppLocalizations.of(context)!.enterFullName
                      : null,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.fullName,
                    prefixIcon: Icon(Icons.person, color: theme.iconTheme.color),
                    filled: true,
                    fillColor: theme.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelStyle: TextStyle(color: theme.hintColor),
                  ),
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: numberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.length != 10
                      ? AppLocalizations.of(context)!.enterValidPhoneNumber
                      : null,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.phoneNumber,
                    prefixText: "+91 ",
                    prefixIcon: Icon(Icons.phone, color: theme.iconTheme.color),
                    filled: true,
                    fillColor: theme.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelStyle: TextStyle(color: theme.hintColor),
                  ),
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _verifyPhoneAndProceed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      AppLocalizations.of(context)!.signup,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.alreadyHaveAccount,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context)!.login,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

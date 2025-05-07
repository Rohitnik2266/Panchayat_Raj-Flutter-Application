import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:panchayat_raj/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SoilHealthCardFormPage extends StatefulWidget {
  const SoilHealthCardFormPage({super.key});

  @override
  State<SoilHealthCardFormPage> createState() => SoilHealthCardFormPageState();
}

class SoilHealthCardFormPageState extends State<SoilHealthCardFormPage> {
  String captchaUrl = generateCaptchaUrl();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSubmitted = false;

  static String generateCaptchaUrl() {
    final random = Random();
    return 'https://dummyimage.com/120x40/000/fff&text=8FKW8C&cacheBust=${random.nextInt(999999)}';
  }

  void refreshCaptcha() {
    setState(() {
      captchaUrl = generateCaptchaUrl();
    });
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Check if the form has already been submitted
        var snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('applications')
            .doc('soilHealthCard')
            .get();

        if (snapshot.exists) {
          setState(() {
            isSubmitted = true;
          });
          // Show a message that the form has already been submitted
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.formAlreadySubmitted)));
        } else {
          // Store the form data in Firestore under the current user's UID
          FirebaseFirestore.instance.collection('users').doc(uid).collection('applications').doc('soilHealthCard').set({
            'firstName': 'John', // Replace with actual form data
            'middleName': 'Doe', // Replace with actual form data
            'lastName': 'Smith', // Replace with actual form data
            'email': 'john.doe@example.com', // Replace with actual form data
            'mobileNumber': '1234567890', // Replace with actual form data
            'organisation': 'NIC', // Replace with actual form data
            'captcha': '8FKW8C', // Replace with captcha code
            'status': 'applied', // New field to indicate application status
            'SchemeName': 'Soil Health Card', // New field to store the name of the scheme
            // Add all other form fields here
          });

          // After submission
          setState(() {
            isSubmitted = true;
          });

          // Show a message that the form was successfully submitted
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.formSubmitted)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.registrationFormTitle),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle(AppLocalizations.of(context)!.user_organisation_details),
                  orgDetailsSection(),
                  sectionTitle(AppLocalizations.of(context)!.language),
                  languageDropdown(),
                  sectionTitle(AppLocalizations.of(context)!.userDetails),
                  userDetailsSection(),
                  sectionTitle(AppLocalizations.of(context)!.userLoginAccountDetails),
                  loginDetailsSection(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isSubmitted ? null : submitForm,
                    child: Text(AppLocalizations.of(context)!.submit),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget languageDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.language),
      items: ['English', 'Hindi', 'Marathi']
          .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
          .toList(),
      onChanged: (_) {},
    );
  }

  Widget orgDetailsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: Text(AppLocalizations.of(context)!.central),
                value: 'Central',
                groupValue: 'State',
                onChanged: (_) {},
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: Text(AppLocalizations.of(context)!.state),
                value: 'State',
                groupValue: 'State',
                onChanged: (_) {},
              ),
            ),
          ],
        ),
        ...[AppLocalizations.of(context)!.stateName, AppLocalizations.of(context)!.departmentName, AppLocalizations.of(context)!.officeType, AppLocalizations.of(context)!.organisationName, AppLocalizations.of(context)!.officeName]
            .map((label) {
          List<String> items = [];
          if (label == AppLocalizations.of(context)!.stateName) items = ['Maharashtra', 'Karnataka', 'Delhi'];
          if (label == AppLocalizations.of(context)!.departmentName) items = ['IT', 'Finance', 'Health'];
          if (label == AppLocalizations.of(context)!.officeType) items = ['Head Office', 'Regional Office'];
          if (label == AppLocalizations.of(context)!.organisationName) items = ['NIC', 'DRDO', 'ISRO'];
          if (label == AppLocalizations.of(context)!.officeName) items = ['NIC Pune', 'DRDO Delhi'];

          return DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: label),
            items: items
                .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                .toList(),
            onChanged: (_) {},
            validator: (val) => val == null || val.isEmpty ? AppLocalizations.of(context)!.required : null,
          );
        }).toList(),
      ],
    );
  }

  Widget userDetailsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.firstName),
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.middleName),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.lastName),
              ),
            ),
          ],
        ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.designation),
          items: ['Officer', 'Manager', 'Developer']
              .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
              .toList(),
          onChanged: (_) {},
          validator: (val) => val == null || val.isEmpty ? AppLocalizations.of(context)!.required : null,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email),
          validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.mobileNumber),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget loginDetailsSection() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.loginName),
          validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.password),
          obscureText: true,
          validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.confirmPassword),
          obscureText: true,
          validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.userRole),
          validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.network(captchaUrl),
                  TextButton.icon(
                    onPressed: refreshCaptcha,
                    icon: Icon(Icons.refresh),
                    label: Text(AppLocalizations.of(context)!.refresh),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.imageCode),
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

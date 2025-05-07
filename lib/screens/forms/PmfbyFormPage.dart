import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:panchayat_raj/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PMFBYFormPage extends StatefulWidget {
  const PMFBYFormPage({super.key});

  @override
  State<PMFBYFormPage> createState() => _PMFBYFormPageState();
}

class _PMFBYFormPageState extends State<PMFBYFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();

  String? _uploadedFile;
  String generatedCaptcha = '';
  bool _alreadyApplied = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
    _checkIfAlreadyApplied();
  }

  Future<void> _checkIfAlreadyApplied() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('applications')
        .doc('PMFBY');

    final doc = await docRef.get();
    if (doc.exists) {
      setState(() {
        _alreadyApplied = true;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  void _generateCaptcha() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ123456789';
    setState(() {
      generatedCaptcha =
          List.generate(5, (index) => chars[Random().nextInt(chars.length)]).join();
    });
  }

  void _simulateOTP(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(local.otpSent)),
    );
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.name != null) {
      setState(() {
        _uploadedFile = result.files.single.name;
      });
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    final local = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    if (_captchaController.text.trim() != generatedCaptcha) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.captchaIncorrect)),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('applications')
        .doc('PMFBY');

    final doc = await docRef.get();
    if (doc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.alreadyApplied)),
      );
      return;
    }

    // Save the application data, including status and scheme name
    await docRef.set({
      'uploadedFile': _uploadedFile ?? '',
      'submittedAt': FieldValue.serverTimestamp(),
      'status': 'applied', // Status added
      'schemeName': 'PMFBY', // Scheme name added
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(local.formSubmitted)),
    );

    setState(() => _alreadyApplied = true);
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(local.pmfbyTitle),
        backgroundColor: Colors.green[700],
      ),
      body: _alreadyApplied
          ? Center(
        child: Text(local.alreadyApplied,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(local.farmerName, local.enterName),
              _buildTextField(local.aadhaarNumber, local.enterAadhaar,
                  keyboardType: TextInputType.number),
              _buildTextField(local.mobileNumber, local.enterMobile,
                  keyboardType: TextInputType.phone),

              ElevatedButton(
                onPressed: () => _simulateOTP(context),
                child: Text(local.sendOtp),
              ),
              _buildTextField(local.enterOtp, local.enterOtp,
                  controller: _otpController),

              _buildTextField(local.bankAccount, local.enterAccount,
                  keyboardType: TextInputType.number),
              _buildTextField(local.ifscCode, local.enterIfsc),
              _buildTextField(local.cropType, local.enterCrop),
              _buildTextField(local.areaHectare, local.enterArea,
                  keyboardType: TextInputType.number),

              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.upload_file),
                label: Text(local.uploadDocument),
              ),
              if (_uploadedFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('${local.fileSelected}: $_uploadedFile',
                      style: const TextStyle(color: Colors.green, fontSize: 14)),
                ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Text('${local.captcha}: ',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  Text(generatedCaptcha,
                      style: const TextStyle(
                          fontSize: 18, letterSpacing: 3, color: Colors.blue)),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _generateCaptcha,
                  ),
                ],
              ),
              _buildTextField(local.enterCaptcha, local.enterCaptcha,
                  controller: _captchaController),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: Text(local.submit),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String validatorText, {
        TextInputType? keyboardType,
        TextEditingController? controller,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? validatorText : null,
      ),
    );
  }
}

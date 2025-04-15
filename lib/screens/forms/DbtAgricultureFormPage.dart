import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DbtAgricultureFormPage extends StatefulWidget {
  const DbtAgricultureFormPage({super.key});

  @override
  State<DbtAgricultureFormPage> createState() => _DbtAgricultureFormPageState();
}

class _DbtAgricultureFormPageState extends State<DbtAgricultureFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _landController = TextEditingController();

  File? _selectedFile;
  bool _alreadyApplied = false;
  bool _canRefill = false;

  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkIfApplied();
  }

  Future<void> _checkIfApplied() async {
    final doc = await firestore
        .collection('applications')
        .doc(user!.uid)
        .collection('schemes')
        .doc('dbt_agriculture')
        .get();

    if (doc.exists) {
      setState(() {
        _alreadyApplied = doc['applied'] ?? false;
        _canRefill = doc['canRefill'] ?? false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedFile != null) {
      final docRef = firestore
          .collection('applications')
          .doc(user!.uid)
          .collection('schemes')
          .doc('dbt_agriculture');

      await docRef.set({
        'aadhar': _aadharController.text,
        'bank': _bankController.text,
        'land': _landController.text,
        'fileName': _selectedFile!.path.split('/').last,
        'applied': true,
        'canRefill': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _alreadyApplied = true;
        _canRefill = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.applied)),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.dbtAgriTitle),
        backgroundColor: Colors.green[700],
      ),
      body: _alreadyApplied && !_canRefill
          ? Center(
        child: Text(
          local.applied,
          style: const TextStyle(fontSize: 20),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _aadharController,
                decoration: InputDecoration(
                  labelText: 'Aadhaar Number',
                  labelStyle: TextStyle(
                      color: isDark ? Colors.white : Colors.black),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.length != 12) {
                    return 'Enter valid 12-digit Aadhaar';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bankController,
                decoration: InputDecoration(
                  labelText: 'Bank Account Number',
                  labelStyle: TextStyle(
                      color: isDark ? Colors.white : Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter bank account number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _landController,
                decoration: InputDecoration(
                  labelText: 'Landholding Details',
                  labelStyle: TextStyle(
                      color: isDark ? Colors.white : Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter landholding details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: Text(_selectedFile == null
                    ? 'Upload Document'
                    : 'File Selected'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(local.applyNow),
              )
            ],
          ),
        ),
      ),
    );
  }
}

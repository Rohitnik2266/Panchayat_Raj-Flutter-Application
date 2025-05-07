import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DbtAgricultureFormPage extends StatefulWidget {
  const DbtAgricultureFormPage({super.key});

  @override
  State<DbtAgricultureFormPage> createState() => _DbtAgricultureFormPageState();
}

class _DbtAgricultureFormPageState extends State<DbtAgricultureFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  PlatformFile? selectedFile;
  bool hasApplied = false;
  bool canRefill = false;
  bool isLoading = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkApplicationStatus();
  }

  Future<void> checkApplicationStatus() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final doc = await _firestore.collection('users').doc(uid).collection('applications').get();
      if (doc.docs.any((d) => d.data().containsKey('schemeName') && d['schemeName'] == 'DBT Agriculture')) {
        setState(() {
          hasApplied = true;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  Future<void> submitForm() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final formData = {
      'name': nameController.text,
      'mobile': mobileController.text,
      'address': addressController.text,
      'fileName': selectedFile?.name ?? '',
      'submittedAt': Timestamp.now(),
    };

    final applicationRef = _firestore.collection('users').doc(uid).collection('applications').doc();

    await applicationRef.set({
      'schemeName': 'DBT Agriculture',
      'status': 'applied',
      'dbt_applied': true,
      'dbt_canRefill': false,
      'dbt_form_data': formData,
    });

    setState(() {
      hasApplied = true;
      canRefill = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.formSubmitted)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (hasApplied && !canRefill) {
      return Scaffold(
        appBar: AppBar(
          title: Text(local.dbtAgricultureTitle),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Text(
            local.formAlreadySubmitted,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(local.dbtAgricultureTitle),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(local.nameLabel, nameController),
              buildTextField(local.mobile, mobileController, isMobile: true),
              buildTextField(local.address, addressController),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: pickFile,
                icon: const Icon(Icons.upload_file),
                label: Text(local.uploadAadhar),
              ),
              if (selectedFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    selectedFile!.name,
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text(local.submit),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isMobile = false}) {
    final local = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isMobile ? TextInputType.phone : TextInputType.text,
        maxLength: isMobile ? 10 : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return local.requiredField;
          if (isMobile && value.length != 10) return local.invalidMobile;
          return null;
        },
      ),
    );
  }
}

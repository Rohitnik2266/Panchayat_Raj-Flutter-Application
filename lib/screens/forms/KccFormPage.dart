import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';

class KccFormPage extends StatefulWidget {
  const KccFormPage({super.key});

  @override
  State<KccFormPage> createState() => _KccFormPageState();
}

class _KccFormPageState extends State<KccFormPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final mobileController = TextEditingController();
  final aadhaarController = TextEditingController();

  final nomineeNameController = TextEditingController();
  final nomineeRelationController = TextEditingController();

  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscController = TextEditingController();

  final cropNameController = TextEditingController();
  final landAreaController = TextEditingController();

  bool isLoading = true;
  bool applied = false;
  bool canRefill = false;
  String? filePath;

  @override
  void initState() {
    super.initState();
    _checkApplicationStatus();
  }

  Future<void> _checkApplicationStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('applications')
          .doc('KCC')
          .get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          applied = data['applied'] ?? false;
          canRefill = data['canRefill'] ?? false;
        });
      }
    }
    setState(() => isLoading = false);
  }

  Future<void> _submitForm() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Save the application data to Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('applications')
        .doc('KCC')
        .set({
      'applied': true,
      'canRefill': false,
      'status': 'applied', // Adding the status
      'schemeName': 'KCC', // Adding the name of the scheme
      'submittedAt': Timestamp.now(),
      'name': nameController.text,
      'fatherName': fatherNameController.text,
      'mobile': mobileController.text,
      'aadhaar': aadhaarController.text,
      'nomineeName': nomineeNameController.text,
      'nomineeRelation': nomineeRelationController.text,
      'bankName': bankNameController.text,
      'accountNumber': accountNumberController.text,
      'ifsc': ifscController.text,
      'cropName': cropNameController.text,
      'landArea': landAreaController.text,
      'filePath': filePath,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.formSubmitted)),
      );
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (applied && !canRefill) {
      return Scaffold(
        appBar: AppBar(title: Text(t.kccFormTitle)),
        body: Center(child: Text(t.alreadyApplied)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.kccFormTitle)),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 4) {
              setState(() => _currentStep += 1);
            } else {
              if (_formKey.currentState!.validate()) {
                _submitForm();
              }
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            }
          },
          steps: [
            Step(
              title: Text(t.personalDetails),
              content: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: t.name),
                    validator: (v) => v!.isEmpty ? t.requiredField : null,
                  ),
                  TextFormField(
                    controller: fatherNameController,
                    decoration: InputDecoration(labelText: t.fatherName),
                    validator: (v) => v!.isEmpty ? t.requiredField : null,
                  ),
                  TextFormField(
                    controller: mobileController,
                    decoration: InputDecoration(labelText: t.mobile),
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                    v!.length != 10 ? t.enterValidNumber : null,
                  ),
                  TextFormField(
                    controller: aadhaarController,
                    decoration: InputDecoration(labelText: t.aadhaar),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                    v!.length != 12 ? t.enterValidAadhaar : null,
                  ),
                ],
              ),
            ),
            Step(
              title: Text(t.nomineeDetails),
              content: Column(
                children: [
                  TextFormField(
                    controller: nomineeNameController,
                    decoration: InputDecoration(labelText: t.nomineeName),
                    validator: (v) => v!.isEmpty ? t.requiredField : null,
                  ),
                  TextFormField(
                    controller: nomineeRelationController,
                    decoration: InputDecoration(labelText: t.nomineeRelation),
                  ),
                ],
              ),
            ),
            Step(
              title: Text(t.bankDetails),
              content: Column(
                children: [
                  TextFormField(
                    controller: bankNameController,
                    decoration: InputDecoration(labelText: t.bankName),
                  ),
                  TextFormField(
                    controller: accountNumberController,
                    decoration: InputDecoration(labelText: t.accountNumber),
                  ),
                  TextFormField(
                    controller: ifscController,
                    decoration: InputDecoration(labelText: t.ifscCode),
                  ),
                ],
              ),
            ),
            Step(
              title: Text(t.cropDetails),
              content: Column(
                children: [
                  TextFormField(
                    controller: cropNameController,
                    decoration: InputDecoration(labelText: t.cropName),
                  ),
                  TextFormField(
                    controller: landAreaController,
                    decoration: InputDecoration(labelText: t.landArea),
                  ),
                ],
              ),
            ),
            Step(
              title: Text(t.uploadDocuments),
              content: Column(
                children: [
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: Text(t.uploadDocuments),
                  ),
                  filePath == null
                      ? Text(t.uploadPlaceholder)
                      : Text(filePath!),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(t.back),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _submitForm();
                }
              },
              child: Text(t.submit),
            ),
          ],
        ),
      ),
    );
  }
}

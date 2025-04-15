import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ACABCFormPage extends StatefulWidget {
  const ACABCFormPage({super.key});

  @override
  State<ACABCFormPage> createState() => _ACABCFormPageState();
}

class _ACABCFormPageState extends State<ACABCFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedState;
  String? selectedDistrict;
  String? selectedBank;
  PlatformFile? selectedFile;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  bool hasApplied = false;
  bool isLoading = true;

  final Map<String, List<String>> districtMap = {
    "Maharashtra": ["Mumbai", "Pune", "Nagpur", "Nashik", "Thane"]
  };

  final List<String> states = ["Maharashtra"];
  final List<String> educationLevels = [
    "10th", "12th", "B.Sc", "B.Com", "B.A", "B.E", "B.Tech", "BBA", "BCA"
  ];
  final List<String> banks = [
    "State Bank of India", "Bank of Maharashtra", "ICICI Bank",
    "HDFC Bank", "Axis Bank", "Punjab National Bank", "Kotak Mahindra Bank"
  ];

  @override
  void initState() {
    super.initState();
    checkIfAlreadyApplied();
  }

  Future<void> checkIfAlreadyApplied() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final doc = await _firestore.collection('applications').doc(uid).get();
      if (doc.exists && doc.data()?['acabc_applied'] == true) {
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
    final uid = _auth.currentUser!.uid;

    await _firestore.collection('applications').doc(uid).set({
      'acabc_applied': true,
      'form_data': {
        // Optional: Add data here if needed
        'submittedAt': Timestamp.now(),
      }
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.formSubmitted)),
    );

    setState(() {
      hasApplied = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(local.acabcTitle),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: hasApplied
          ? Center(
        child: Text(
          local.formAlreadySubmitted,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle(local.personalDetails),
              buildTextField(local.nameLabel),
              buildTextField(local.fatherMotherName),
              buildTextField(local.mobile, isMobile: true),
              buildDropdown(local.gender, ["Male", "Female", "Other"]),
              buildTextField(local.address),

              buildStateDropdown(local.state),
              if (selectedState != null) buildDistrictDropdown(local.district),

              buildTextField(local.aadharNumber, isAadhar: true),

              sectionTitle(local.educationalQualifications),
              buildDropdown(local.educationLevel, educationLevels),
              buildTextField(local.institute),
              buildTextField(local.universityBoard),
              buildTextField(local.yearOfPassing),
              buildTextField(local.totalMarks),
              buildTextField(local.marksObtained),

              sectionTitle(local.bankDetails),
              buildDropdown(local.bankName, banks),
              buildTextField(local.ifscCode),
              buildTextField(local.branchAddress),
              buildTextField(local.accountNumber),

              sectionTitle(local.uploadDocuments),
              ElevatedButton.icon(
                onPressed: pickFile,
                icon: const Icon(Icons.upload_file),
                label: Text(local.uploadAadhar),
              ),
              if (selectedFile != null)
                Text(selectedFile!.name, style: const TextStyle(color: Colors.green)),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
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

  Widget sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
    child: Text(title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  Widget buildTextField(String label,
      {bool isMobile = false, bool isAadhar = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        keyboardType:
        isMobile || isAadhar ? TextInputType.number : TextInputType.text,
        maxLength: isMobile ? 10 : isAadhar ? 12 : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';
          if (isMobile && value.length != 10) return 'Enter valid 10-digit mobile';
          if (isAadhar && value.length != 12) return 'Enter valid 12-digit Aadhar';
          return null;
        },
      ),
    );
  }

  Widget buildDropdown(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: (_) {},
      ),
    );
  }

  Widget buildStateDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: states
            .map((state) => DropdownMenuItem(value: state, child: Text(state)))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedState = value;
            selectedDistrict = null;
          });
        },
      ),
    );
  }

  Widget buildDistrictDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: districtMap[selectedState!]!
            .map((district) =>
            DropdownMenuItem(value: district, child: Text(district)))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedDistrict = value;
          });
        },
      ),
    );
  }
}

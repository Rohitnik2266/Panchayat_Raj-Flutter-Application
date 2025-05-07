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
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  bool hasApplied = false;
  bool isLoading = true;
  PlatformFile? selectedFile;

  String? selectedState;
  String? selectedDistrict;
  String? selectedGender;
  String? selectedEducation;
  String? selectedBank;

  final List<String> states = ['Maharashtra'];
  final Map<String, List<String>> districtMap = {
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Thane'],
  };

  final List<String> educationLevels = [
    '10th', '12th', 'B.Sc', 'B.Com', 'B.A', 'B.E', 'B.Tech', 'BBA', 'BCA'
  ];
  final List<String> banks = [
    'State Bank of India',
    'Bank of Maharashtra',
    'ICICI Bank',
    'HDFC Bank',
    'Axis Bank',
    'Punjab National Bank',
    'Kotak Mahindra Bank'
  ];

  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'parentName': TextEditingController(),
    'mobile': TextEditingController(),
    'address': TextEditingController(),
    'aadhar': TextEditingController(),
    'institute': TextEditingController(),
    'university': TextEditingController(),
    'year': TextEditingController(),
    'totalMarks': TextEditingController(),
    'marksObtained': TextEditingController(),
    'ifsc': TextEditingController(),
    'branch': TextEditingController(),
    'account': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    checkIfAlreadyApplied();
  }

  Future<void> checkIfAlreadyApplied() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('applications')
          .doc('acabc')
          .get();
      if (doc.exists && doc.data()?['applied'] == true) {
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
      'name': controllers['name']!.text,
      'parentName': controllers['parentName']!.text,
      'mobile': controllers['mobile']!.text,
      'gender': selectedGender,
      'address': controllers['address']!.text,
      'state': selectedState,
      'district': selectedDistrict,
      'aadhar': controllers['aadhar']!.text,
      'education': selectedEducation,
      'institute': controllers['institute']!.text,
      'university': controllers['university']!.text,
      'year': controllers['year']!.text,
      'totalMarks': controllers['totalMarks']!.text,
      'marksObtained': controllers['marksObtained']!.text,
      'bank': selectedBank,
      'ifsc': controllers['ifsc']!.text,
      'branch': controllers['branch']!.text,
      'account': controllers['account']!.text,
      'fileName': selectedFile?.name ?? '',
      'submittedAt': Timestamp.now(),
    };

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('applications')
        .doc('acabc')
        .set({
      'applied': true,
      'status': 'Applied',
      'schemeName': 'ACABC',
      'formData': formData,
    });

    setState(() {
      hasApplied = true;
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
              buildTextField(local.nameLabel, controllers['name']!),
              buildTextField(local.fatherMotherName, controllers['parentName']!),
              buildTextField(local.mobile, controllers['mobile']!, isMobile: true),
              buildDropdown(local.gender, ['Male', 'Female', 'Other'],
                      (val) => selectedGender = val),
              buildTextField(local.address, controllers['address']!),
              buildStateDropdown(local.state),
              if (selectedState != null)
                buildDistrictDropdown(local.district),
              buildTextField(local.aadharNumber, controllers['aadhar']!,
                  isAadhar: true),

              sectionTitle(local.educationalQualifications),
              buildDropdown(local.educationLevel, educationLevels,
                      (val) => selectedEducation = val),
              buildTextField(local.institute, controllers['institute']!),
              buildTextField(local.universityBoard, controllers['university']!),
              buildTextField(local.yearOfPassing, controllers['year']!),
              buildTextField(local.totalMarks, controllers['totalMarks']!),
              buildTextField(local.marksObtained, controllers['marksObtained']!),

              sectionTitle(local.bankDetails),
              buildDropdown(local.bankName, banks,
                      (val) => selectedBank = val),
              buildTextField(local.ifscCode, controllers['ifsc']!),
              buildTextField(local.branchAddress, controllers['branch']!),
              buildTextField(local.accountNumber, controllers['account']!),

              sectionTitle(local.uploadDocuments),
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
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
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Text(title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  Widget buildTextField(String label, TextEditingController controller,
      {bool isMobile = false, bool isAadhar = false}) {
    final local = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType:
        isMobile || isAadhar ? TextInputType.number : TextInputType.text,
        maxLength: isMobile
            ? 10
            : isAadhar
            ? 12
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return local.requiredField;
          if (isMobile && value.length != 10) return local.invalidMobile;
          if (isAadhar && value.length != 12) return local.invalidAadhar;
          return null;
        },
      ),
    );
  }

  Widget buildDropdown(
      String label, List<String> items, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration:
        InputDecoration(labelText: label, border: const OutlineInputBorder()),
        items:
        items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (value) =>
        value == null ? AppLocalizations.of(context)!.requiredField : null,
      ),
    );
  }

  Widget buildStateDropdown(String label) {
    return buildDropdown(label, states, (val) {
      setState(() {
        selectedState = val;
        selectedDistrict = null;
      });
    });
  }

  Widget buildDistrictDropdown(String label) {
    return buildDropdown(label, districtMap[selectedState!]!, (val) {
      setState(() {
        selectedDistrict = val;
      });
    });
  }
}

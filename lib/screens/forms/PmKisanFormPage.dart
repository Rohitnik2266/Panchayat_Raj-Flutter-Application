import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PMKisanFormPage extends StatefulWidget {
  const PMKisanFormPage({super.key});

  @override
  State<PMKisanFormPage> createState() => _PMKisanFormPageState();
}

class _PMKisanFormPageState extends State<PMKisanFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool isSubmitted = false;

  String gender = 'Female';
  String landHolding = 'Single';
  String idType = 'Aadhaar Card';
  String? captchaInput;
  String generatedCaptcha = 'XyZ12';

  String? selectedState = 'Select';
  String? selectedDistrict = 'Select';
  String? selectedSubDistrict = 'Select';
  String? selectedBlock = 'Select';
  String? selectedVillage = 'Select';

  final Map<String, Map<String, Map<String, Map<String, List<String>>>>> locationData = {
    'Maharashtra': {
      'Pune': {
        'Haveli': {
          'Wagholi': ['Bakori', 'Kesnand'],
          'Shivapur': ['Shivane', 'Donje'],
        }
      },
      'Nagpur': {
        'Nagpur (Rural)': {
          'Kamptee': ['Kamptee Village', 'Kawtha'],
        }
      },
    },
    'Karnataka': {
      'Bengaluru': {
        'South': {
          'Anekal': ['Anekal Town', 'Jigani'],
        }
      },
    },
    'Uttar Pradesh': {
      'Sitapur': {
        'Sadar': {
          'Khairabad': ['Laharpur', 'Tikari'],
        }
      },
    },
  };

  List<String> get states => ['Select', ...locationData.keys];
  List<String> get districts => selectedState != null && selectedState != 'Select'
      ? ['Select', ...locationData[selectedState]!.keys]
      : ['Select'];
  List<String> get subDistricts => selectedDistrict != null && selectedDistrict != 'Select'
      ? ['Select', ...locationData[selectedState]![selectedDistrict]!.keys]
      : ['Select'];
  List<String> get blocks => selectedSubDistrict != null && selectedSubDistrict != 'Select'
      ? ['Select', ...locationData[selectedState]![selectedDistrict]![selectedSubDistrict]!.keys]
      : ['Select'];
  List<String> get villages => selectedBlock != null && selectedBlock != 'Select'
      ? ['Select', ...locationData[selectedState]![selectedDistrict]![selectedSubDistrict]![selectedBlock]!]
      : ['Select'];

  @override
  void initState() {
    super.initState();
    generatedCaptcha = generateCaptcha();
    checkIfAlreadyApplied();
  }

  Future<void> checkIfAlreadyApplied() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('applications')
          .doc('pmkisan')
          .get();
      if (doc.exists) {
        setState(() {
          isSubmitted = true;
        });
      }
    }
  }

  Future<void> submitFormToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final data = {
        'gender': gender,
        'landHolding': landHolding,
        'state': selectedState,
        'district': selectedDistrict,
        'subDistrict': selectedSubDistrict,
        'block': selectedBlock,
        'village': selectedVillage,
        'submittedAt': Timestamp.now(),
        'status': 'applied',  // New status field
        'schemeName': 'PM Kisan',  // New scheme name field
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('applications')
          .doc('pmkisan')
          .set(data);

      setState(() => isSubmitted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.pmKisanRegistration)),
      body: isSubmitted
          ? Center(child: Text(t.formAlreadySubmitted, style: const TextStyle(fontSize: 18)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle(t.locationDetails),
              dropdownField(label: t.state, items: states, value: selectedState, onChanged: (val) {
                setState(() {
                  selectedState = val;
                  selectedDistrict = 'Select';
                  selectedSubDistrict = 'Select';
                  selectedBlock = 'Select';
                  selectedVillage = 'Select';
                });
              }),
              dropdownField(label: t.district, items: districts, value: selectedDistrict, onChanged: (val) {
                setState(() {
                  selectedDistrict = val;
                  selectedSubDistrict = 'Select';
                  selectedBlock = 'Select';
                  selectedVillage = 'Select';
                });
              }),
              dropdownField(label: t.subDistrict, items: subDistricts, value: selectedSubDistrict, onChanged: (val) {
                setState(() {
                  selectedSubDistrict = val;
                  selectedBlock = 'Select';
                  selectedVillage = 'Select';
                });
              }),
              dropdownField(label: t.block, items: blocks, value: selectedBlock, onChanged: (val) {
                setState(() {
                  selectedBlock = val;
                  selectedVillage = 'Select';
                });
              }),
              dropdownField(label: t.village, items: villages, value: selectedVillage, onChanged: (val) {
                setState(() => selectedVillage = val);
              }),

              const SizedBox(height: 20),
              sectionTitle(t.farmerPersonalDetails),
              textField(t.farmerName),
              dropdownField(label: t.gender, items: [t.male, t.female, t.other], value: gender, onChanged: (val) => setState(() => gender = val!)),
              dropdownField(label: t.category, items: [t.selectCategory, "General", "SC", "ST", "OBC"]),
              dropdownField(label: t.farmerType, items: [t.selectFarmerType, "Small", "Marginal"]),
              textField(t.aadhaarNumber),
              textField(t.mobileNumber),
              textField(t.address),
              textField(t.pincode),
              textField(t.relativeName),
              textField(t.dateOfBirth),
              dropdownField(label: t.pmKisanMandhanAcceptance, items: [t.yes, t.no]),

              const SizedBox(height: 10),
              Text(t.ownershipLandHolding, style: TextStyle(color: textColor)),
              Row(
                children: [
                  Radio(value: "Single", groupValue: landHolding, onChanged: (value) => setState(() => landHolding = value!)),
                  Text(t.single),
                  Radio(value: "Joint", groupValue: landHolding, onChanged: (value) => setState(() => landHolding = value!)),
                  Text(t.joint),
                ],
              ),

              const SizedBox(height: 20),
              sectionTitle(t.landDetails),
              textField(t.surveyKhataNo),
              textField(t.dagKhasraNo),
              textField(t.areaHa),
              textField(t.landTransferStatus),
              textField(t.landTransferDetails),
              textField(t.landDateVesting),
              textField(t.pattaNoRfa),
              textField(t.landRegistrationId),
              textField(t.aadhaarForLand),

              const SizedBox(height: 20),
              Text(t.uploadDocuments),
              ElevatedButton(onPressed: () {}, child: Text(t.chooseFile)),

              const SizedBox(height: 20),
              Text(t.captchaVerification),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${t.captcha}: $generatedCaptcha", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {
                        generatedCaptcha = generateCaptcha();
                      });
                    },
                  )
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: t.enterCaptcha),
                validator: (value) {
                  if (value != generatedCaptcha) return t.captchaMismatch;
                  return null;
                },
                onSaved: (value) => captchaInput = value,
              ),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await submitFormToFirestore();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.formSubmittedSuccessfully)));
                    }
                  },
                  child: Text(t.submit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(String label) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
    ),
  );

  Widget dropdownField({
    required String label,
    required List<String> items,
    String? value,
    ValueChanged<String?>? onChanged,
  }) {
    final dropdownItems = ['Select', ...items.where((e) => e != 'Select')];
    final validValue = dropdownItems.contains(value) ? value : 'Select';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        value: validValue,
        items: dropdownItems.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        validator: (val) => val == null || val == 'Select' ? 'Required' : null,
      ),
    );
  }

  Widget sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  String generateCaptcha() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ1234567890';
    final rand = Random();
    return List.generate(5, (index) => chars[rand.nextInt(chars.length)]).join();
  }
}

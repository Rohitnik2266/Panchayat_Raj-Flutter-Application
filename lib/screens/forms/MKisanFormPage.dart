import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MkisanFormPage extends StatefulWidget {
  const MkisanFormPage({super.key});

  @override
  _MkisanFormPageState createState() => _MkisanFormPageState();
}

class _MkisanFormPageState extends State<MkisanFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? name, mobile, state, district, gender, qualification;
  bool _isSubmitted = false;
  bool _canRefill = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadySubmitted();
  }

  Future<void> _checkIfAlreadySubmitted() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('applications')
        .doc('mkisan');

    final doc = await docRef.get();

    if (doc.exists) {
      setState(() {
        _isSubmitted = true;
        _canRefill = doc.data()?['canRefill'] == true;
      });
    }
  }

  Future<void> _submitForm() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final data = {
      'name': name,
      'mobile': mobile,
      'gender': gender,
      'state': state,
      'district': district,
      'qualification': qualification,
      'submittedAt': FieldValue.serverTimestamp(),
      'status': 'applied',
      'schemeName': 'M-Kisan', // ✅ This makes it show up correctly in TrackStatusScreen
      'canRefill': false,
    };

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('applications')
        .doc('mkisan')
        .set(data);

    setState(() {
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(local.scheme_name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isSubmitted && !_canRefill
            ? Center(
          child: Text(
            local.alreadyApplied,
            style: const TextStyle(fontSize: 18, color: Colors.green),
          ),
        )
            : Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration:
                InputDecoration(labelText: local.mobileNumber),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.length == 10
                    ? null
                    : local.validPhoneNumber,
                onSaved: (value) => mobile = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: local.name),
                onSaved: (value) => name = value,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: local.gender),
                items: [
                  local.male,
                  local.female,
                  local.other,
                ]
                    .map((g) =>
                    DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => gender = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: local.state),
                onSaved: (value) => state = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: local.district),
                onSaved: (value) => district = value,
              ),
              TextFormField(
                decoration:
                InputDecoration(labelText: local.qualification),
                onSaved: (value) => qualification = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _submitForm();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(local.formSubmitted)),
                      );
                    }
                  }
                },
                child: Text(local.submit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

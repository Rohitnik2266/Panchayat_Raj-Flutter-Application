import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path show basename;
import 'package:file_picker/file_picker.dart';

class ShivSanmanFormPage extends StatefulWidget {
  final String userId;
  const ShivSanmanFormPage({super.key, required this.userId});

  @override
  State<ShivSanmanFormPage> createState() => _ShivSanmanFormPageState();
}

class _ShivSanmanFormPageState extends State<ShivSanmanFormPage> {
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String aadhaar = '';
  String landDetails = '';
  String loanAmount = '';
  File? uploadedFile;
  bool alreadyApplied = false;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyApplied();
  }

  Future<void> _checkIfAlreadyApplied() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('applications')
        .doc(widget.userId)
        .get();

    if (doc.exists && doc['shivsanman_applied'] == true) {
      setState(() {
        alreadyApplied = true;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && uploadedFile != null) {
      _formKey.currentState!.save();

      final fileName = path.basename(uploadedFile!.path);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('shivsanman_documents/${widget.userId}/$fileName');

      try {
        // Upload file
        await storageRef.putFile(uploadedFile!);
        final fileURL = await storageRef.getDownloadURL();

        // Save to Firestore
        await FirebaseFirestore.instance
            .collection('applications')
            .doc(widget.userId)
            .set({
          'shivsanman_applied': true,
          'shivsanman_data': {
            'fullName': fullName,
            'aadhaar': aadhaar,
            'landDetails': landDetails,
            'loanAmount': loanAmount,
            'documentURL': fileURL,
            'scheme': 'Shivaji Maharaj Sanman Yojana',
            'appliedOn': DateTime.now(),
          },
        }, SetOptions(merge: true));

        setState(() {
          alreadyApplied = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Applied Successfully!')),
        );

        Navigator.pop(context, 'applied');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } else if (uploadedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload required documents.')),
      );
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );
    if (result != null) {
      setState(() {
        uploadedFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Shivaji Maharaj Sanman Yojana'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: alreadyApplied
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have already applied!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  alreadyApplied = false; // Allow refill
                });
              },
              child: const Text('Refill Form'),
            )
          ],
        )
            : Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                value!.isEmpty ? 'Enter name' : null,
                onSaved: (value) => fullName = value!,
              ),
              TextFormField(
                decoration:
                const InputDecoration(labelText: 'Aadhaar Number'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.length != 12
                    ? 'Enter valid Aadhaar'
                    : null,
                onSaved: (value) => aadhaar = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Land Details (Survey No, Area)'),
                validator: (value) =>
                value!.isEmpty ? 'Enter land details' : null,
                onSaved: (value) => landDetails = value!,
              ),
              TextFormField(
                decoration:
                const InputDecoration(labelText: 'Loan Amount'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Enter loan amount' : null,
                onSaved: (value) => loanAmount = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: Text(uploadedFile != null
                    ? 'File: ${uploadedFile!.path.split('/').last}'
                    : 'Upload Document'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700]),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

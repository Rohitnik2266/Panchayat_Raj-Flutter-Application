
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NafedFormPage extends StatefulWidget {
  const NafedFormPage({super.key});

  @override
  State<NafedFormPage> createState() => _NafedFormPageState();
}

class _NafedFormPageState extends State<NafedFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  bool _submitted = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final docRef = FirebaseFirestore.instance
          .collection('applications')
          .doc(uid)
          .collection('nafed')
          .doc('form');

      final snapshot = await docRef.get();
      if (snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Already applied for this scheme.')),
        );
        return;
      }

      await docRef.set({
        'name': _nameController.text,
        'details': _detailsController.text,
        'submittedAt': FieldValue.serverTimestamp(),
      });

      setState(() => _submitted = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application submitted successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nafed Form')),
        body: const Center(child: Text('Form already submitted.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nafed Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(labelText: 'Details'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter details' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

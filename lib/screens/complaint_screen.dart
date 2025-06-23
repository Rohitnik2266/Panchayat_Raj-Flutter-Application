import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _complaintController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setInitialDate();
    _fetchUserName();
  }

  void _setInitialDate() {
    final today = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(today);
  }

  Future<void> _fetchUserName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()!.containsKey('name')) {
        _nameController.text = doc['name'];
      }
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('complaints')
          .add({
        'name': _nameController.text,
        'complaint': _complaintController.text,
        'date': _dateController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.complaintSubmitted)),
      );

      _formKey.currentState!.reset();
      _setInitialDate();
      _fetchUserName();
    }
  }

  @override
  void dispose() {
    _complaintController.dispose();
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.submitComplaint),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: t.yourName,
                  labelStyle: TextStyle(color: theme.colorScheme.onBackground),
                ),
                validator: (value) => value!.isEmpty ? t.enterYourName : null,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _pickDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: t.date,
                      labelStyle: TextStyle(color: theme.colorScheme.onBackground),
                      hintText: t.dateFormatHint,
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    validator: (value) => value!.isEmpty ? t.enterDate : null,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _complaintController,
                decoration: InputDecoration(
                  labelText: t.complaint,
                  labelStyle: TextStyle(color: theme.colorScheme.onBackground),
                ),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? t.enterComplaint : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text(t.submit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

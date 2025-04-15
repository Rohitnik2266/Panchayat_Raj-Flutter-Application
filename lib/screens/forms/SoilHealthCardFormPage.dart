import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Form',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  String captchaUrl = generateCaptchaUrl();

  static String generateCaptchaUrl() {
    final random = Random();
    return 'https://dummyimage.com/120x40/000/fff&text=8FKW8C&cacheBust=${random.nextInt(999999)}';
  }

  void refreshCaptcha() {
    setState(() {
      captchaUrl = generateCaptchaUrl();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration Form')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle('User Organisation Details'),
              orgDetailsSection(),
              sectionTitle('Language'),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Language'),
                items: ['English', 'Hindi', 'Marathi']
                    .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                    .toList(),
                onChanged: (_) {},
              ),
              sectionTitle('User Details'),
              userDetailsSection(),
              sectionTitle('User Login Account Details'),
              loginDetailsSection(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget orgDetailsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: Text('Central'),
                value: 'Central',
                groupValue: 'State',
                onChanged: (_) {},
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: Text('State'),
                value: 'State',
                groupValue: 'State',
                onChanged: (_) {},
              ),
            ),
          ],
        ),
        ...[
          'State Name',
          'Department Name',
          'Office Type',
          'Organisation Name',
          'Office Name'
        ].map((label) {
          List<String> items = [];
          if (label == 'State Name') items = ['Maharashtra', 'Karnataka', 'Delhi'];
          if (label == 'Department Name') items = ['IT', 'Finance', 'Health'];
          if (label == 'Office Type') items = ['Head Office', 'Regional Office'];
          if (label == 'Organisation Name') items = ['NIC', 'DRDO', 'ISRO'];
          if (label == 'Office Name') items = ['NIC Pune', 'DRDO Delhi'];

          return DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: label),
            items: items
                .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                .toList(),
            onChanged: (_) {},
            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
          );
        }).toList(),
      ],
    );
  }

  Widget userDetailsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Middle Name'),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
            ),
          ],
        ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: 'Designation'),
          items: ['Officer', 'Manager', 'Developer']
              .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
              .toList(),
          onChanged: (_) {},
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Email'),
          validator: (val) => val!.isEmpty ? 'Required' : null,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Mobile Number'),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget loginDetailsSection() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'Login Name'),
          validator: (val) => val!.isEmpty ? 'Required' : null,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (val) => val!.isEmpty ? 'Required' : null,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Confirm Password'),
          obscureText: true,
          validator: (val) => val!.isEmpty ? 'Required' : null,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'User Role'),
          validator: (val) => val!.isEmpty ? 'Required' : null,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.network(captchaUrl),
                  TextButton.icon(
                    onPressed: refreshCaptcha,
                    icon: Icon(Icons.refresh),
                    label: Text('Refresh'),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Image Code'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

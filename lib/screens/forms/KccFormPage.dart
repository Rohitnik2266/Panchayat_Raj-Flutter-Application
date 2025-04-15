import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registration Form")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle("Personal Details"),
              buildTextField("Name (as per Aadhar)"),
              buildTextField("Father/Mother/Spouse Name"),
              buildTextField("Mobile"),
              buildDropdown("Gender", ["Male", "Female", "Other"]),
              buildTextField("Address"),
              buildDropdown("State", ["Select State"]),
              buildDropdown("District", ["Select District"]),
              buildTextField("Aadhar No."),

              buildSectionTitle("Select NTI"),
              buildDropdown("NTI State 1", ["Select State"]),
              buildDropdown("NTI (1st priority)", ["Select NTI"]),
              buildDropdown("NTI State 2", ["Select State"]),
              buildDropdown("NTI (2nd priority)", ["Select NTI"]),
              buildDropdown("NTI State 3", ["Select State"]),
              buildDropdown("NTI (3rd priority)", ["Select NTI"]),

              buildSectionTitle("Educational Qualifications"),
              buildDropdown("Degree/Diploma", ["Select Degree"]),
              buildDropdown("Specialisation", ["Select Specialisation"]),
              buildTextField("Institute"),
              buildTextField("University/Board"),
              buildTextField("Year of Passing"),
              buildTextField("Total Marks"),
              buildTextField("Marks Obtained"),

              buildSectionTitle("Bank Account Details"),
              buildDropdown("Bank Name", ["Select Bank Name"]),
              buildTextField("IFSC Code"),
              buildTextField("Branch Address"),
              buildTextField("Account No."),

              buildSectionTitle("Family Background"),
              buildDropdown("Background Type", ["Select Family Background"]),
              buildTextField("Experience in Enterprise"),
              buildTextField("Proposed Place of Establishment"),
              buildTextField("Nature of Enterprise Being Planned"),
              buildTextField("Brief Details on Future Vision"),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Form Submitted Successfully')),
                    );
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => value!.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget buildDropdown(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (value) {},
      ),
    );
  }
}
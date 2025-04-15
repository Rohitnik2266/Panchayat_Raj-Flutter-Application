import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ENamFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.registrationForm),
      ),
      body: ENamFormContent(),
    );
  }
}

class ENamFormContent extends StatefulWidget {
  @override
  _ENamFormContentState createState() => _ENamFormContentState();
}

class _ENamFormContentState extends State<ENamFormContent> {
  final _formKey = GlobalKey<FormState>();

  String selectedOrgType = 'Central';
  String captchaText = generateCaptchaText();

  static String generateCaptchaText() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void refreshCaptcha() {
    setState(() {
      captchaText = generateCaptchaText();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final t = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: DefaultTextStyle(
          style: TextStyle(color: textColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle(t.userOrgDetails),
              orgDetailsSection(t),
              sectionTitle(t.language),
              buildDropdown(t.language, ['English', 'Hindi', 'Marathi']),
              sectionTitle(t.userDetails),
              userDetailsSection(t),
              sectionTitle(t.loginAccountDetails),
              loginDetailsSection(t),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(t.processingData)),
                    );
                  }
                },
                child: Text(t.submit),
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
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget orgDetailsSection(AppLocalizations t) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: Text(t.central),
                value: 'Central',
                groupValue: selectedOrgType,
                onChanged: (value) {
                  setState(() {
                    selectedOrgType = value.toString();
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: Text(t.state),
                value: 'State',
                groupValue: selectedOrgType,
                onChanged: (value) {
                  setState(() {
                    selectedOrgType = value.toString();
                  });
                },
              ),
            ),
          ],
        ),
        buildDropdown(t.stateName, ['Maharashtra', 'Karnataka', 'Delhi']),
        buildDropdown(t.departmentName, ['IT', 'Finance', 'Health']),
        buildDropdown(t.officeType, ['Head Office', 'Regional Office']),
        buildDropdown(t.organizationName, ['NIC', 'DRDO', 'ISRO']),
        buildDropdown(t.officeName, ['NIC Pune', 'DRDO Delhi']),
      ],
    );
  }

  Widget buildDropdown(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
        onChanged: (_) {},
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget userDetailsSection(AppLocalizations t) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: buildTextField(t.firstName, true)),
            SizedBox(width: 8),
            Expanded(child: buildTextField(t.middleName, false)),
            SizedBox(width: 8),
            Expanded(child: buildTextField(t.lastName, false)),
          ],
        ),
        buildDropdown(t.designation, ['Officer', 'Manager', 'Developer']),
        buildTextField(t.email, true),
        buildTextField(t.mobileNumber, false, keyboardType: TextInputType.phone),
      ],
    );
  }

  Widget buildTextField(String label, bool isRequired,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: isRequired ? (val) => val!.isEmpty ? 'Required' : null : null,
      ),
    );
  }

  Widget loginDetailsSection(AppLocalizations t) {
    return Column(
      children: [
        buildTextField(t.loginName, true),
        buildPasswordField(t.password),
        buildPasswordField(t.confirmPassword),
        buildTextField(t.userRole, true),
        captchaSection(t),
      ],
    );
  }

  Widget buildPasswordField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (val) => val!.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget captchaSection(AppLocalizations t) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.black,
                child: Text(
                  captchaText,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: refreshCaptcha,
                icon: Icon(Icons.refresh),
                label: Text(t.refresh),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        Expanded(child: buildTextField(t.enterCaptcha, true)),
      ],
    );
  }
}

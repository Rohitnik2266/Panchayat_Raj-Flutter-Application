import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NaifFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.beneficiaryRegistration)),
      body: NaifFormContent(),
    );
  }
}

class NaifFormContent extends StatefulWidget {
  @override
  _NaifFormContentState createState() => _NaifFormContentState();
}

class _NaifFormContentState extends State<NaifFormContent> {
  final _formKey = GlobalKey<FormState>();
  String _captcha = generateCaptcha();

  static String generateCaptcha() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(6, (index) => chars[Random().nextInt(chars.length)]).join();
  }

  void refreshCaptcha() {
    setState(() {
      _captcha = generateCaptcha();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle(t.beneficiaryDetails, textColor),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: t.beneficiaryType),
              items: [t.agriEntrepreneur, t.farmer, t.fpo].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (_) {},
              validator: (val) => val == null ? t.requiredField : null,
            ),
            TextFormField(decoration: InputDecoration(labelText: t.name), validator: (val) => val!.isEmpty ? t.requiredField : null),
            TextFormField(decoration: InputDecoration(labelText: t.aadhaar), keyboardType: TextInputType.number),
            TextFormField(decoration: InputDecoration(labelText: t.mobile), keyboardType: TextInputType.phone),
            TextFormField(decoration: InputDecoration(labelText: t.email), keyboardType: TextInputType.emailAddress),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: t.gender),
              items: [t.male, t.female, t.other].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (_) {},
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: t.category),
              items: [t.sc, t.st, t.obc, t.general, t.others].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (_) {},
            ),

            sectionTitle(t.beneficiaryAddress, textColor),
            TextFormField(decoration: InputDecoration(labelText: t.address)),
            TextFormField(decoration: InputDecoration(labelText: t.cityVillage)),
            TextFormField(decoration: InputDecoration(labelText: t.pinCode), keyboardType: TextInputType.number),

            sectionTitle(t.projectAddress, textColor),
            TextFormField(decoration: InputDecoration(labelText: t.projectAddress)),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: t.projectState),
              items: ['Madhya Pradesh', 'Maharashtra', 'Karnataka'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (_) {},
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: t.projectDistrict),
              items: ['Ujjain', 'Indore', 'Bhopal'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (_) {},
            ),
            TextFormField(decoration: InputDecoration(labelText: t.projectCityVillage)),
            TextFormField(decoration: InputDecoration(labelText: t.pinCode), keyboardType: TextInputType.number),

            sectionTitle(t.projectGeoLocation, textColor),
            TextFormField(decoration: InputDecoration(labelText: t.longitude)),
            TextFormField(decoration: InputDecoration(labelText: t.latitude)),

            sectionTitle(t.loanDetails, textColor),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: t.lendingInstitution),
              items: ['State Bank', 'Bank of India', 'PNB'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (_) {},
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: t.branchState),
              items: ['Madhya Pradesh', 'Rajasthan'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (_) {},
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: t.branchDistrict),
              items: ['Ujjain', 'Indore'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (_) {},
            ),
            TextFormField(decoration: InputDecoration(labelText: t.loanAmount), keyboardType: TextInputType.number),
            TextFormField(decoration: InputDecoration(labelText: t.beneficiaryContribution), keyboardType: TextInputType.number),
            Row(
              children: [
                Expanded(child: TextFormField(decoration: InputDecoration(labelText: t.termYear), keyboardType: TextInputType.number)),
                SizedBox(width: 10),
                Expanded(child: TextFormField(decoration: InputDecoration(labelText: t.termMonth), keyboardType: TextInputType.number)),
              ],
            ),
            TextFormField(decoration: InputDecoration(labelText: t.indicativeInterest), keyboardType: TextInputType.number),
            TextFormField(decoration: InputDecoration(labelText: t.effectiveInterest), keyboardType: TextInputType.number),

            sectionTitle(t.captchaVerification, textColor),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  color: Colors.grey[300],
                  child: Text(_captcha, style: TextStyle(fontSize: 18, letterSpacing: 3)),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: refreshCaptcha,
                  tooltip: t.refreshCaptcha,
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: t.enterCaptcha),
                    validator: (val) => val != _captcha ? t.invalidCaptcha : null,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.formSubmitted)));
                    }
                  },
                  child: Text(t.submit),
                ),
                SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    _formKey.currentState!.reset();
                    refreshCaptcha();
                  },
                  child: Text(t.clear),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }
}

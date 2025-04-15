import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KisanSuvidhaFormPage extends StatefulWidget {
  const KisanSuvidhaFormPage({Key? key}) : super(key: key);

  @override
  State<KisanSuvidhaFormPage> createState() => _KisanSuvidhaFormPageState();
}

class _KisanSuvidhaFormPageState extends State<KisanSuvidhaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _captchaController = TextEditingController();
  String _generatedCaptcha = '';

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ123456789';
    _generatedCaptcha = List.generate(6, (index) {
      final rand = Random();
      return chars[rand.nextInt(chars.length)];
    }).join();
    setState(() {});
  }

  @override
  void dispose() {
    _captchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.kisanSuvidhaForm),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.farmerDetails, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
              _buildTextField(t.fullName, t.enterFullName),
              _buildTextField(t.relativeName, t.enterRelativeName),
              _buildTextField(t.mobileNumber, t.enterMobileNumber, TextInputType.phone),
              _buildTextField(t.age, t.enterAge, TextInputType.number),
              _buildDropdownField(t.gender, [t.male, t.female, t.other], t.selectGender),
              _buildDropdownField(t.farmerType, [t.marginal, t.small, t.large], t.selectFarmerType),

              const SizedBox(height: 20),
              Text(t.accountDetails, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
              _buildTextField(t.ifsc, t.enterIFSC),
              _buildTextField(t.accountNumber, t.enterAccountNumber, TextInputType.number),
              _buildTextField(t.confirmAccountNumber, t.confirmAccountNumber, TextInputType.number),

              const SizedBox(height: 20),
              Text(t.captchaCode, style: TextStyle(fontSize: 16, color: textColor)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.shade200,
                    ),
                    child: Text(
                      _generatedCaptcha,
                      style: const TextStyle(fontSize: 18, letterSpacing: 3, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _generateCaptcha,
                    icon: const Icon(Icons.refresh, color: Colors.green),
                    tooltip: t.refreshCaptcha,
                  )
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _captchaController,
                decoration: InputDecoration(
                  labelText: t.captchaEnter,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return t.enterCaptcha;
                  if (value.trim().toUpperCase() != _generatedCaptcha.toUpperCase()) return t.incorrectCaptcha;
                  return null;
                },
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Firebase logic can be added here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${t.success}: ${t.formSubmittedSuccessfully}")),
                      );
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

  Widget _buildTextField(String label, String validatorText, [TextInputType? keyboardType]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? validatorText : null,
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String validatorText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        validator: (value) => value == null ? validatorText : null,
        onChanged: (value) {},
      ),
    );
  }
}

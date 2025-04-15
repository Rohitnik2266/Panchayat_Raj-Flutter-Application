import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PkvFormPage extends StatefulWidget {
  const PkvFormPage({super.key});

  @override
  State<PkvFormPage> createState() => _PkvFormPageState();
}

class _PkvFormPageState extends State<PkvFormPage> {
  final _formKey = GlobalKey<FormState>();

  String? aadharFile, landDocFile, bankPassbookFile;
  String generatedCaptcha = '';
  final TextEditingController _captchaController = TextEditingController();

  bool agree = false;

  @override
  void initState() {
    super.initState();
    generatedCaptcha = generateCaptcha();
  }

  String generateCaptcha() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      5,
          (index) => chars[(chars.length * (DateTime.now().millisecondsSinceEpoch % 100 + index) ~/ 100) % chars.length],
    ).join();
  }

  Future<void> pickFile(String field) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String path = result.files.single.name;
      setState(() {
        if (field == "aadhaar") aadharFile = path;
        if (field == "land") landDocFile = path;
        if (field == "bank") bankPassbookFile = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.pkvFormTitle),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitle(t.personalDetails, textColor),
              buildTextField(t.fullName, t.enterName),
              buildTextField(t.aadharNumber, t.enterAadhar, TextInputType.number),

              buildTitle(t.agricultureDetails, textColor),
              buildTextField(t.landSize, t.enterLandSize, TextInputType.number),
              buildDropdown(t.irrigationType, [t.drip, t.sprinkler, t.surface], t.selectIrrigation),
              buildDropdown(t.cropType, [t.wheat, t.rice, t.vegetables, t.fruits], t.selectCrop),
              buildDropdown(t.waterSource, [t.well, t.canal, t.pond, t.borewell], t.selectSource),

              buildTitle(t.bankDetails, textColor),
              buildDropdown(t.needLoan, [t.yes, t.no], t.selectLoan),
              buildTextField(t.bankAccountNumber, t.enterAccount, TextInputType.number),
              buildTextField(t.ifscCode, t.enterIFSC),

              buildTitle(t.uploadDocuments, textColor),
              buildFileUpload(t.uploadAadhar, aadharFile, () => pickFile("aadhaar")),
              buildFileUpload(t.uploadLandDoc, landDocFile, () => pickFile("land")),
              buildFileUpload(t.uploadPassbook, bankPassbookFile, () => pickFile("bank")),

              buildTitle(t.securityCheck, textColor),
              buildCaptchaField(t),

              CheckboxListTile(
                title: Text(t.declaration),
                value: agree,
                onChanged: (val) => setState(() => agree = val!),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && agree) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(t.formSuccess)),
                      );
                    }
                  },
                  child: Text(t.submitApplication),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String validatorText, [TextInputType? type]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value!.isEmpty ? validatorText : null,
      ),
    );
  }

  Widget buildDropdown(String label, List<String> items, String validatorText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        validator: (value) => value == null ? validatorText : null,
        onChanged: (value) {},
      ),
    );
  }

  Widget buildFileUpload(String label, String? fileName, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.upload_file),
                label: const Text("Choose File"),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(fileName ?? "No file chosen")),
            ],
          )
        ],
      ),
    );
  }

  Widget buildTitle(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget buildCaptchaField(AppLocalizations t) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  generatedCaptcha,
                  style: const TextStyle(
                    fontSize: 18,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    generatedCaptcha = generateCaptcha();
                    _captchaController.clear();
                  });
                },
              )
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _captchaController,
            decoration: InputDecoration(
              labelText: t.enterCaptcha,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return t.required;
              if (value.trim().toUpperCase() != generatedCaptcha.toUpperCase()) {
                return t.incorrectCaptcha;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

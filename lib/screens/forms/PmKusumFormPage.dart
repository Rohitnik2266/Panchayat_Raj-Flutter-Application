import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PmKusumFormPage extends StatefulWidget {
  const PmKusumFormPage({super.key});

  @override
  State<PmKusumFormPage> createState() => _PmKusumFormPageState();
}

class _PmKusumFormPageState extends State<PmKusumFormPage> {
  final _formKey = GlobalKey<FormState>();
  final captchaCode = '7G5H2';

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final landAreaController = TextEditingController();
  final infraDetailsController = TextEditingController();
  final projectCostController = TextEditingController();
  final loanAmountController = TextEditingController();
  final bankDetailsController = TextEditingController();
  final captchaController = TextEditingController();

  void handleSubmit(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      if (captchaController.text.trim() == captchaCode) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(t.success),
            content: Text(t.formSubmittedSuccessfully),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(t.captchaIncorrect),
            content: Text(t.enterCorrectCaptcha),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(title: Text(t.pmKusumScheme)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.beneficiaryDetails, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: t.nameOfApplicant, border: const OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? t.requiredField : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: t.mobileNumber, border: const OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (val) => val!.isEmpty ? t.requiredField : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: t.emailAddress, border: const OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              Text(t.projectDetails, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 10),
              TextFormField(
                controller: infraDetailsController,
                decoration: InputDecoration(labelText: t.infrastructureDetails, border: const OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? t.requiredField : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: landAreaController,
                decoration: InputDecoration(labelText: t.landAreaAcre, border: const OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? t.requiredField : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: projectCostController,
                decoration: InputDecoration(labelText: t.projectCost, border: const OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? t.requiredField : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: loanAmountController,
                decoration: InputDecoration(labelText: t.loanAmountRequired, border: const OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? t.requiredField : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: bankDetailsController,
                decoration: InputDecoration(labelText: t.bankDetails, border: const OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? t.requiredField : null,
              ),
              const SizedBox(height: 20),

              Text("${t.captchaEnter} $captchaCode", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: captchaController,
                decoration: InputDecoration(labelText: t.enterCaptcha, border: const OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? t.requiredField : null,
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => handleSubmit(context),
                  child: Text(t.submit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

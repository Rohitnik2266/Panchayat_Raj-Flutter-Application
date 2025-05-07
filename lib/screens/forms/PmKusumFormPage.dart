import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // Firebase Auth and Firestore instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void handleSubmit(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      // Handle the case where the user is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.notAuthenticated)));
      return;
    }

    // Check if the user has already submitted the form
    DocumentReference userDoc = _firestore.collection('users').doc(currentUser.uid);
    DocumentSnapshot userSnapshot = await userDoc.get();

    if (userSnapshot.exists && userSnapshot.get('applications.pmKusum') == true) {
      // Show a dialog indicating the form has already been submitted
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(t.alreadyApplied),
          content: Text(t.youHaveAlreadySubmittedTheForm),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
        ),
      );
      return;
    }

    // Validate form and captcha
    if (_formKey.currentState!.validate()) {
      if (captchaController.text.trim() == captchaCode) {
        // Save data to Firestore
        await userDoc.collection('applications').doc('pmKusum').set({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'landArea': landAreaController.text,
          'infraDetails': infraDetailsController.text,
          'projectCost': projectCostController.text,
          'loanAmount': loanAmountController.text,
          'bankDetails': bankDetailsController.text,
          'submittedAt': Timestamp.now(),
          'status': 'applied', // Added status field
          'schemeName': 'pmKusum', // Added schemeName field
        });

        // Mark form as submitted in Firestore
        await userDoc.update({
          'applications.pmKusum': true,
        });

        // Show success dialog
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(t.success),
            content: Text(t.formSubmittedSuccessfully),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
          ),
        );
      } else {
        // Show captcha error
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

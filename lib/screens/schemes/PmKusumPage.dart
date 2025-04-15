import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panchayat_raj/screens/forms/PmKusumFormPage.dart';

class PmKusumPage extends StatefulWidget {
  const PmKusumPage({super.key});

  @override
  State<PmKusumPage> createState() => _PmKusumPageState();
}

class _PmKusumPageState extends State<PmKusumPage> {
  bool hasApplied = false;
  bool canRefill = false;

  @override
  void initState() {
    super.initState();
    _checkFormStatus();
  }

  Future<void> _checkFormStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('scheme_forms')
        .doc(uid)
        .collection('pmkusum_form')
        .doc('status')
        .get();
    if (doc.exists) {
      setState(() {
        hasApplied = doc['applied'] ?? false;
        canRefill = doc['canRefill'] ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.pmKusumScheme),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.aboutScheme,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 10),
            Text(t.pmKusumAbout,
                style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7), height: 1.5)),

            const SizedBox(height: 20),
            Text(t.keyBenefits,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),

            const SizedBox(height: 10),
            BenefitTile(icon: Icons.solar_power, title: t.solarPump, description: t.solarPumpDesc),
            BenefitTile(icon: Icons.energy_savings_leaf, title: t.cleanEnergy, description: t.cleanEnergyDesc),
            BenefitTile(icon: Icons.attach_money, title: t.extraIncome, description: t.extraIncomeDesc),

            const SizedBox(height: 20),
            Text(t.eligibility,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 10),
            Text(t.pmKusumEligibility,
                style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7), height: 1.5)),

            const SizedBox(height: 20),
            Text(t.howToApply,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 10),
            Text(t.pmKusumApplySteps,
                style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7), height: 1.5)),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: hasApplied && !canRefill
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PmKusumFormPage()),
                    );
                  },
                  icon: const Icon(Icons.app_registration),
                  label: Text(hasApplied && !canRefill ? t.alreadyApplied : t.applyNow),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    hasApplied && !canRefill ? Colors.grey : Colors.green[600],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: Text(t.back),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BenefitTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const BenefitTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700], size: 30),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
        subtitle: Text(description, style: TextStyle(fontSize: 15, color: theme.textTheme.bodySmall?.color)),
      ),
    );
  }
}

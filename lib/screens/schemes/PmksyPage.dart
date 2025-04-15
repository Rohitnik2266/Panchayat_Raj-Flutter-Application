import 'package:flutter/material.dart';
import 'package:panchayat_raj/screens/forms/PmksyFormPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PmksyPage extends StatefulWidget {
  const PmksyPage({super.key});

  @override
  State<PmksyPage> createState() => _PmksyPageState();
}

class _PmksyPageState extends State<PmksyPage> {
  bool _isApplied = false;
  bool _canRefill = false;

  @override
  void initState() {
    super.initState();
    checkApplicationStatus();
  }

  Future<void> checkApplicationStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('applications')
        .doc(user.uid)
        .collection('pmksy')
        .doc('form')
        .get();

    if (doc.exists) {
      setState(() {
        _isApplied = doc.data()?['applied'] ?? false;
        _canRefill = doc.data()?['canRefill'] ?? false;
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
        title: Text(t.pmksyTitle),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: TextStyle(color: textColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.aboutScheme, style: theme.textTheme.titleLarge?.copyWith(color: textColor)),
              const SizedBox(height: 10),
              Text(t.pmksyAboutDesc, style: theme.textTheme.bodyMedium),

              const SizedBox(height: 20),
              Text(t.keyBenefits, style: theme.textTheme.titleMedium?.copyWith(color: Colors.green)),
              const SizedBox(height: 10),
              const BenefitTile(
                icon: Icons.water,
                titleKey: 'pmksyBenefit1Title',
                descKey: 'pmksyBenefit1Desc',
              ),
              const BenefitTile(
                icon: Icons.water_drop_outlined,
                titleKey: 'pmksyBenefit2Title',
                descKey: 'pmksyBenefit2Desc',
              ),
              const BenefitTile(
                icon: Icons.landscape,
                titleKey: 'pmksyBenefit3Title',
                descKey: 'pmksyBenefit3Desc',
              ),

              const SizedBox(height: 20),
              Text(t.eligibility, style: theme.textTheme.titleMedium?.copyWith(color: Colors.green)),
              const SizedBox(height: 10),
              Text(t.pmksyEligibility, style: theme.textTheme.bodyMedium),

              const SizedBox(height: 20),
              Text(t.applicationProcess, style: theme.textTheme.titleMedium?.copyWith(color: Colors.green)),
              const SizedBox(height: 10),
              Text(t.pmksyProcess, style: theme.textTheme.bodyMedium),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isApplied && !_canRefill
                        ? null
                        : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PkvFormPage()),
                      );
                    },
                    icon: const Icon(Icons.assignment),
                    label: Text(_isApplied && !_canRefill ? t.alreadyApplied : t.applyNow),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
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
      ),
    );
  }
}

class BenefitTile extends StatelessWidget {
  final IconData icon;
  final String titleKey;
  final String descKey;

  const BenefitTile({
    super.key,
    required this.icon,
    required this.titleKey,
    required this.descKey,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700], size: 30),
        title: Text(t.get, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(t.get),
      ),
    );
  }
}

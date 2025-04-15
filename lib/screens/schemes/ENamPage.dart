import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panchayat_raj/screens/forms/EnamFormPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ENamPage extends StatefulWidget {
  const ENamPage({super.key});

  @override
  State<ENamPage> createState() => _ENamPageState();
}

class _ENamPageState extends State<ENamPage> {
  bool hasApplied = false;
  bool canRefill = false;

  @override
  void initState() {
    super.initState();
    checkApplicationStatus();
  }

  Future<void> checkApplicationStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('scheme_applications')
        .doc(uid)
        .collection('schemes')
        .doc('eNam')
        .get();

    if (doc.exists) {
      setState(() {
        hasApplied = doc.data()?['applied'] ?? false;
        canRefill = doc.data()?['canRefill'] ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.eNamTitle),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTextStyle(
          style: TextStyle(color: textColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.aboutScheme,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                t.eNamAbout,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                t.keyBenefits,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              BenefitTile(
                icon: Icons.language,
                title: t.onlineMarketAccess,
                description: t.onlineMarketAccessDesc,
              ),
              BenefitTile(
                icon: Icons.attach_money,
                title: t.betterPriceDiscovery,
                description: t.betterPriceDiscoveryDesc,
              ),
              BenefitTile(
                icon: Icons.inventory,
                title: t.reducedMiddlemen,
                description: t.reducedMiddlemenDesc,
              ),
              const SizedBox(height: 20),

              Text(
                t.eligibilityCriteria,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              Text(
                t.eNamEligibility,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                t.applicationProcess,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              Text(
                t.eNamProcess,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ENamFormPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.app_registration),
                    label: Text(t.applyNow),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: Text(t.back),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
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
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87,
          ),
        ),
      ),
    );
  }
}

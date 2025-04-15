import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:panchayat_raj/screens/forms/DbtAgricultureFormPage.dart';
import '../services/application_service.dart'; // your Firestore logic file

class DbtAgriculturePage extends StatelessWidget {
  const DbtAgriculturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.dbtAgriTitle),
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
                loc.aboutScheme,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                loc.dbtAgriAbout,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              Text(
                loc.keyBenefits,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              BenefitTile(
                icon: Icons.account_balance_wallet,
                title: loc.dbtAgriBenefit1Title,
                description: loc.dbtAgriBenefit1Desc,
              ),
              BenefitTile(
                icon: Icons.verified_user,
                title: loc.dbtAgriBenefit2Title,
                description: loc.dbtAgriBenefit2Desc,
              ),
              BenefitTile(
                icon: Icons.speed,
                title: loc.dbtAgriBenefit3Title,
                description: loc.dbtAgriBenefit3Desc,
              ),
              const SizedBox(height: 20),

              Text(
                loc.eligibility,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              Text(
                loc.dbtAgriEligibility,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              Text(
                loc.applicationProcess,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              Text(
                loc.dbtAgriApplySteps,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FutureBuilder<bool>(
                    future: ApplicationService.hasAppliedForScheme('dbt_agriculture'),
                    builder: (context, snapshot) {
                      final hasApplied = snapshot.data ?? false;
                      return ElevatedButton.icon(
                        onPressed: hasApplied
                            ? null
                            : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DbtAgricultureFormPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.app_registration),
                        label: Text(hasApplied ? loc.applied : loc.applyNow),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasApplied ? Colors.grey : Colors.green[600],
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: Text(loc.back),
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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700], size: 30),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}

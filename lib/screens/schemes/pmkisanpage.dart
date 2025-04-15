import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:panchayat_raj/screens/forms/PmKisanFormPage.dart';

class PmKisanPage extends StatelessWidget {
  const PmKisanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.pmKisanTitle),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.aboutScheme,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                t.pmKisanAboutDesc,
                style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7), height: 1.5),
              ),
              const SizedBox(height: 20),

              Text(
                t.keyBenefits,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              BenefitTile(
                icon: Icons.attach_money,
                title: t.incomeSupport,
                description: t.incomeSupportDesc,
                textColor: textColor,
              ),
              BenefitTile(
                icon: Icons.agriculture,
                title: t.agriAssistance,
                description: t.agriAssistanceDesc,
                textColor: textColor,
              ),
              BenefitTile(
                icon: Icons.family_restroom,
                title: t.directBenefitTransfer,
                description: t.directBenefitTransferDesc,
                textColor: textColor,
              ),
              const SizedBox(height: 20),

              Text(
                t.eligibilityCriteria,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              Text(
                t.pmKisanEligibility,
                style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7), height: 1.5),
              ),
              const SizedBox(height: 20),

              Text(
                t.applicationProcess,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              Text(
                t.pmKisanApplicationSteps,
                style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7), height: 1.5),
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
                          builder: (context) => const PMKisanFormPage(),
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
  final Color textColor;

  const BenefitTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700], size: 30),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
        subtitle: Text(description, style: TextStyle(fontSize: 15, color: textColor.withOpacity(0.7))),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:panchayat_raj/screens/forms/NaifFormPage.dart';

class NaifPage extends StatelessWidget {
  const NaifPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.nationalAgriInfraFinancingFacility),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
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
              t.naifAboutText,
              style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7), height: 1.5),
            ),
            const SizedBox(height: 20),

            Text(
              t.keyBenefits,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            BenefitTile(
              icon: Icons.account_balance,
              title: t.loanSupport,
              description: t.loanSupportDesc,
            ),
            BenefitTile(
              icon: Icons.local_shipping,
              title: t.infrastructureDevelopment,
              description: t.infrastructureDevelopmentDesc,
            ),
            BenefitTile(
              icon: Icons.group,
              title: t.broadBeneficiaryBase,
              description: t.broadBeneficiaryBaseDesc,
            ),
            const SizedBox(height: 20),

            Text(
              t.eligibilityCriteria,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              t.naifEligibility,
              style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7), height: 1.5),
            ),
            const SizedBox(height: 20),

            Text(
              t.applicationProcess,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              t.naifApplicationProcess,
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
                      MaterialPageRoute(builder: (_) => NaifFormPage()),
                    );
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: Text(t.applyNow),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
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
    final theme = Theme.of(context); // ✅ Fix applied here

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700], size: 30),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

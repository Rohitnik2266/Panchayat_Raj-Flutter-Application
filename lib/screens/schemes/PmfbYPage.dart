import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:panchayat_raj/screens/forms/PmfbyFormPage.dart';

class PmfbYPage extends StatelessWidget {
  const PmfbYPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.pmfbyTitle),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.aboutTheScheme,
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              locale.pmfbyAbout,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            Text(
              locale.keyBenefits,
              style: theme.textTheme.titleMedium!.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            BenefitTile(
              icon: Icons.security,
              title: locale.cropInsurance,
              description: locale.cropInsuranceDesc,
            ),
            BenefitTile(
              icon: Icons.stacked_line_chart,
              title: locale.financialStability,
              description: locale.financialStabilityDesc,
            ),
            BenefitTile(
              icon: Icons.agriculture,
              title: locale.modernTechniques,
              description: locale.modernTechniquesDesc,
            ),
            const SizedBox(height: 20),

            Text(
              locale.eligibilityCriteria,
              style: theme.textTheme.titleMedium!.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              locale.pmfbyEligibility,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            Text(
              locale.applicationProcess,
              style: theme.textTheme.titleMedium!.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              locale.pmfbyApplicationProcess,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PMFBYFormPage()),
                    );
                  },
                  icon: const Icon(Icons.open_in_browser),
                  label: Text(locale.applyNow),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: Text(locale.back),
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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700], size: 30),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

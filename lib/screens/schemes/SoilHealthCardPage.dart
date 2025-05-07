import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Ensure to import localization
import 'package:panchayat_raj/screens/forms/SoilHealthCardFormPage.dart'; // Assuming this is the form page for the Soil Health Card scheme

class SoilHealthCardPage extends StatelessWidget {
  const SoilHealthCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme using Theme.of(context)
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.soil_health_card_scheme), // Localized title
        backgroundColor: theme.brightness == Brightness.dark ? Colors.green[900] : Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.about_the_scheme, // Localized string
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.soil_health_card_description, // Localized description
              style: TextStyle(fontSize: 16, color: theme.brightness == Brightness.dark ? Colors.white70 : Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            Text(
              AppLocalizations.of(context)!.key_benefits, // Localized benefits title
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
              BenefitTile(
              icon: Icons.article,
                title: AppLocalizations.of(context)!.soilCardBenefit1Title,
                description: AppLocalizations.of(context)!.soilCardBenefit1Description,
              ),
              BenefitTile(
                icon: Icons.eco,
                title: AppLocalizations.of(context)!.soilCardBenefit2Title,
                description: AppLocalizations.of(context)!.soilCardBenefit2Description,
              ),
              BenefitTile(
                icon: Icons.spa,
                title: AppLocalizations.of(context)!.soilCardBenefit3Title,
                description: AppLocalizations.of(context)!.soilCardBenefit3Description,
            ),
            const SizedBox(height: 20),

            Text(
              AppLocalizations.of(context)!.eligibility_criteria, // Localized eligibility title
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.eligibility_description, // Localized eligibility description
              style: TextStyle(fontSize: 16, color: theme.brightness == Brightness.dark ? Colors.white70 : Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            Text(
              AppLocalizations.of(context)!.application_process, // Localized process title
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.application_steps, // Localized steps description
              style: TextStyle(fontSize: 16, color: theme.brightness == Brightness.dark ? Colors.white70 : Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SoilHealthCardFormPage()),
                    );
                  },
                  icon: const Icon(Icons.language),
                  label: Text(AppLocalizations.of(context)!.apply_now), // Localized apply now text
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
                  label: Text(AppLocalizations.of(context)!.back), // Localized back text
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
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: theme.brightness == Brightness.dark ? Colors.white : Colors.green[700], size: 30),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
        subtitle: Text(description, style: TextStyle(fontSize: 15, color: theme.brightness == Brightness.dark ? Colors.white70 : Colors.black54)),
      ),
    );
  }
}

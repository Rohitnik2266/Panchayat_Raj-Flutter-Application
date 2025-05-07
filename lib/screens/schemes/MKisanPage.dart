import 'package:flutter/material.dart';
import 'package:panchayat_raj/screens/forms/MKisanFormPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:panchayat_raj/theme_provider.dart';

class MKisanPage extends StatelessWidget {
  const MKisanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final local = AppLocalizations.of(context)!;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.mkisanTitle),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(local.aboutScheme,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 10),
            Text(local.mkisanAbout,
              style: TextStyle(fontSize: 16, color: subTextColor, height: 1.5),
            ),
            const SizedBox(height: 20),

            Text(local.keyBenefits,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            BenefitTile(
              icon: Icons.sms,
              title: local.smsAdvisory,
              description: local.smsAdvisoryDesc,
              textColor: textColor,
              subTextColor: subTextColor,
            ),
            BenefitTile(
              icon: Icons.language,
              title: local.multiLanguageSupport,
              description: local.multiLanguageSupportDesc,
              textColor: textColor,
              subTextColor: subTextColor,
            ),
            BenefitTile(
              icon: Icons.access_time,
              title: local.timelyUpdates,
              description: local.timelyUpdatesDesc,
              textColor: textColor,
              subTextColor: subTextColor,
            ),
            const SizedBox(height: 20),

            Text(local.eligibility,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(local.mkisanEligibility,
              style: TextStyle(fontSize: 16, color: subTextColor, height: 1.5),
            ),
            const SizedBox(height: 20),

            Text(local.howToApply,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(local.mkisanHowToApply,
              style: TextStyle(fontSize: 16, color: subTextColor, height: 1.5),
            ),
            const SizedBox(height: 20),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MkisanFormPage()),
                  );
                },
                icon: const Icon(Icons.assignment),
                label: Text(local.applyNow),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: Text(local.back),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
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
  final Color textColor;
  final Color subTextColor;

  const BenefitTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.textColor,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700], size: 30),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
        subtitle: Text(description, style: TextStyle(fontSize: 15, color: subTextColor)),
      ),
    );
  }
}

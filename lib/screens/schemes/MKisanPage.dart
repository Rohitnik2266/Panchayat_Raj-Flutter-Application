import 'package:flutter/material.dart';

class MKisanPage extends StatelessWidget {
  const MKisanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mKisan Portal'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About the Scheme',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'The mKisan Portal is an initiative by the Ministry of Agriculture, Government of India, to provide timely information and advisories to farmers via SMS. '
                  'It enables government officials and experts to reach out directly to farmers across India with location-specific messages related to weather, market prices, farming practices, and more.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              'Key Benefits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const BenefitTile(
              icon: Icons.sms,
              title: 'SMS Advisory',
              description: 'Farmers receive SMS-based alerts about weather, prices, pest outbreaks, and best practices.',
            ),
            const BenefitTile(
              icon: Icons.language,
              title: 'Multi-language Support',
              description: 'Messages are sent in the regional language of the farmer for better understanding.',
            ),
            const BenefitTile(
              icon: Icons.access_time,
              title: 'Timely Updates',
              description: 'Critical information is shared in real-time to help farmers make informed decisions.',
            ),
            const SizedBox(height: 20),

            const Text(
              'Eligibility Criteria',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const Text(
              '✔️ All farmers with a mobile phone number.\n'
                  '✔️ No restriction based on location, income, or landholding.\n'
                  '✔️ Basic knowledge of mobile phone usage.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              'How to Register',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Visit the mKisan portal using the link below.\n'
                  '2. Click on "Farmer Registration".\n'
                  '3. Enter your mobile number and location details.\n'
                  '4. Choose preferred crops and language.\n'
                  '5. Submit to start receiving advisories via SMS.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening mKisan Portal...')),
                    );
                  },
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text('Visit Portal'),
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
                  label: const Text('Back'),
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
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: const TextStyle(fontSize: 15, color: Colors.black54)),
      ),
    );
  }
}

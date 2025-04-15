import 'package:flutter/material.dart';

class KayakaMitraPage extends StatelessWidget {
  const KayakaMitraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayaka Mitra App'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About the App',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            const Text(
              'The Kayaka Mitra App enables farmers and agricultural laborers to apply for employment under the Mahatma Gandhi National Rural Employment Guarantee Act (MGNREGA). '
                  'It facilitates 100 days of assured wage employment to rural households willing to do unskilled manual work.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              'Key Benefits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const BenefitTile(
              icon: Icons.work,
              title: '100 Days of Work',
              description: 'Assured employment for up to 100 days per year under MGNREGA.',
            ),
            const BenefitTile(
              icon: Icons.phone_android,
              title: 'Easy Access via Mobile App',
              description: 'Farmers and laborers can apply and track status directly through the app.',
            ),
            const BenefitTile(
              icon: Icons.security,
              title: 'Transparency and Monitoring',
              description: 'Ensures better transparency in work allotment and payments.',
            ),
            const SizedBox(height: 20),

            const Text(
              'Eligibility Criteria',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const Text(
              '✔️ Any rural household willing to do unskilled manual work.\n'
                  '✔️ Applicants must be registered under MGNREGA.\n'
                  '✔️ Should possess a valid job card issued under the scheme.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              'How to Use the App',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Download the Kayaka Mitra App from the Google Play Store (link below).\n'
                  '2. Register using your job card and Aadhaar details.\n'
                  '3. Apply for work or check work status from the dashboard.\n'
                  '4. Track payment and employment details within the app.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Redirecting to Play Store...')),
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download App'),
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

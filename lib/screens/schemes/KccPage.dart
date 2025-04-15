import 'package:flutter/material.dart';

class KccPage extends StatelessWidget {
  const KccPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kisan Credit Card (KCC)'),
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
              'The Kisan Credit Card (KCC) scheme provides timely credit to farmers to meet their agricultural and other needs. '
                  'It enables farmers to access short-term loans at low interest rates and offers flexibility for withdrawal.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              'Key Benefits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const BenefitTile(
              icon: Icons.credit_card,
              title: 'Flexible Credit',
              description: 'Farmers can withdraw credit as needed for agriculture and allied activities.',
            ),
            const BenefitTile(
              icon: Icons.percent,
              title: 'Low Interest Rates',
              description: 'Interest subsidies reduce the effective loan interest rates.',
            ),
            const BenefitTile(
              icon: Icons.sync_alt,
              title: 'Simple Renewal',
              description: 'Easy renewal and access to extended credit limits based on repayment.',
            ),
            const SizedBox(height: 20),

            const Text(
              'Eligibility Criteria',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const Text(
              '✔️ All farmers - individual, joint borrowers, tenant farmers, and sharecroppers.\n'
                  '✔️ Should own or cultivate agricultural land.\n'
                  '✔️ Must not be a defaulter in any bank.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              'Application Process',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Visit your bank’s branch or access the official KCC application link.\n'
                  '2. Submit necessary documents such as land records and ID proof.\n'
                  '3. Fill out the KCC application form.\n'
                  '4. Submit and wait for verification and card issuance.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening KCC application PDF...')),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Apply Now'),
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

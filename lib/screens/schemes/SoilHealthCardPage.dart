import 'package:flutter/material.dart';

class SoilHealthCardPage extends StatelessWidget {
  const SoilHealthCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soil Health Card Scheme'),
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
              'The Soil Health Card Scheme provides farmers with detailed information about the nutrient status of their soil. '
                  'It helps them understand the right amount of fertilizers and other inputs to be used, ensuring improved productivity and soil conservation.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              'Key Benefits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const BenefitTile(
              icon: Icons.article,
              title: 'Soil Reports',
              description: 'Farmers receive reports on soil pH, nutrient levels, and suggestions for improvement.',
            ),
            const BenefitTile(
              icon: Icons.eco,
              title: 'Better Fertilizer Usage',
              description: 'Improves fertilizer application based on scientific data.',
            ),
            const BenefitTile(
              icon: Icons.spa,
              title: 'Soil Conservation',
              description: 'Promotes long-term soil health and reduces overuse of chemicals.',
            ),
            const SizedBox(height: 20),

            const Text(
              'Eligibility Criteria',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const Text(
              '✔️ All farmers across India are eligible.\n'
                  '✔️ Must have cultivable land for testing.\n'
                  '✔️ Soil sample collection by designated labs or officers.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              'Application Process',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Visit the official Soil Health Card portal.\n'
                  '2. Provide details like location, landholding, and soil sample.\n'
                  '3. Submit sample at designated collection center.\n'
                  '4. Receive the soil health report and recommendations.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening Soil Health portal...')),
                    );
                  },
                  icon: const Icon(Icons.language),
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

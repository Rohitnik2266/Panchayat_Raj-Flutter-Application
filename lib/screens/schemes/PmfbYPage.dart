import 'package:flutter/material.dart';

class PmfbYPage extends StatelessWidget {
  const PmfbYPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pradhan Mantri Fasal Bima Yojana (PMFBY)'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                'PMFBY is a crop insurance scheme launched by the Government of India to provide insurance coverage and financial support to farmers in the event of crop failure. '
                    'It aims to stabilize farmers’ income and encourage them to adopt innovative and modern agricultural practices.',
                style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 20),

              const Text(
                'Key Benefits',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              const BenefitTile(
                icon: Icons.security,
                title: 'Crop Insurance',
                description: 'Protects farmers against crop losses due to natural calamities, pests, and diseases.',
              ),
              const BenefitTile(
                icon: Icons.stacked_line_chart,
                title: 'Financial Stability',
                description: 'Compensates for loss, helping farmers recover and reinvest in farming.',
              ),
              const BenefitTile(
                icon: Icons.agriculture,
                title: 'Modern Techniques',
                description: 'Encourages farmers to use advanced agricultural practices.',
              ),
              const SizedBox(height: 20),

              const Text(
                'Eligibility Criteria',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              const Text(
                '✔️ All farmers including sharecroppers and tenant farmers.\n'
                    '✔️ Must have insurable interest in the crop.\n'
                    '✔️ Should cultivate notified crops in notified areas.',
                style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 20),

              const Text(
                'Application Process',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              const Text(
                '1. Visit the PMFBY official website or your nearest CSC (Common Service Center).\n'
                    '2. Submit required documents such as land ownership, sowing proof, and Aadhaar.\n'
                    '3. Choose the insured crops and fill out the insurance application.\n'
                    '4. Submit and keep the acknowledgment receipt.',
                style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Redirecting to PMFBY portal...'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.open_in_browser),
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

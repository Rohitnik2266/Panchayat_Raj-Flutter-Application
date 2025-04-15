import 'package:flutter/material.dart';

class MahaDBTMechanizationPage extends StatelessWidget {
  const MahaDBTMechanizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MahaDBT Agriculture Mechanization Scheme'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About the Scheme',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            const Text(
              'The State Agriculture Mechanization Scheme under MahaDBT provides subsidies to farmers in Maharashtra for purchasing agricultural machinery. '
                  'The scheme encourages modern farming techniques to increase productivity, reduce labor dependency, and save time.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              'Key Benefits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const BenefitTile(
              icon: Icons.agriculture,
              title: 'Subsidy on Equipment',
              description: 'Farmers receive subsidies on tractors, seeders, sprayers, and other machinery.',
            ),
            const BenefitTile(
              icon: Icons.timelapse,
              title: 'Time Saving',
              description: 'Mechanization reduces time and effort in various agricultural activities.',
            ),
            const BenefitTile(
              icon: Icons.speed,
              title: 'Increased Productivity',
              description: 'Improved efficiency and higher crop yields with better machinery.',
            ),
            const SizedBox(height: 20),

            const Text(
              'Eligibility Criteria',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const Text(
              '✔️ Must be a resident farmer of Maharashtra.\n'
                  '✔️ Should own or lease agricultural land.\n'
                  '✔️ Must register on the MahaDBT portal.\n'
                  '✔️ Possession of valid land records and identity proof.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              'Application Process',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Visit the MahaDBT official website (link below).\n'
                  '2. Register and log in using Aadhaar credentials.\n'
                  '3. Select the Agriculture Mechanization Scheme.\n'
                  '4. Upload required documents and submit the application.\n'
                  '5. Await subsidy approval and purchase authorization.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening MahaDBT website...')),
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

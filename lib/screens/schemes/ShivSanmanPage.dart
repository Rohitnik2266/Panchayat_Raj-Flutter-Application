import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:panchayat_raj/screens/forms/shivsanman_form.dart';

class ShivSanmanPage extends StatefulWidget {
  const ShivSanmanPage({super.key});

  @override
  State<ShivSanmanPage> createState() => _ShivSanmanPageState();
}

class _ShivSanmanPageState extends State<ShivSanmanPage> {
  bool _isApplied = false;
  bool _loading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
    if (_userId != null) {
      checkApplicationStatus();
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> checkApplicationStatus() async {
    final doc = await FirebaseFirestore.instance
        .collection('applications')
        .doc(_userId)
        .get();

    if (mounted) {
      setState(() {
        _isApplied = doc.exists && doc.data()?['shivsanman_applied'] == true;
        _loading = false;
      });
    }
  }

  ButtonStyle _buttonStyle(Color color) => ElevatedButton.styleFrom(
    backgroundColor: color,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  );

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chhatrapati Shivaji Maharaj Shetkari Sanman Yojana'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About
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
              'The Chhatrapati Shivaji Maharaj Shetkari Sanman Yojana (CSMSSY) is a farm loan waiver scheme initiated by the Government of Maharashtra. '
                  'It aims to reduce the debt burden on farmers by waiving outstanding loans. The scheme provides financial stability, '
                  'promotes agricultural sustainability, and prevents farmer suicides by alleviating financial stress.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Benefits
            const Text(
              'Key Benefits',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            const BenefitTile(
              icon: Icons.money_off,
              title: 'Loan Waiver',
              description: 'Farmers benefit from complete or partial loan waivers, reducing their debt burden.',
            ),
            const BenefitTile(
              icon: Icons.security,
              title: 'Financial Security',
              description: 'Improved financial stability for farmers and their families.',
            ),
            const BenefitTile(
              icon: Icons.grain,
              title: 'Agricultural Support',
              description: 'Support for better crop production through financial aid and reduced interest rates.',
            ),
            const SizedBox(height: 20),

            // Eligibility
            const Text(
              'Eligibility Criteria',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '✔️ Farmers who have taken agricultural loans from cooperative, nationalized, and rural banks.\n'
                  '✔️ Loans availed between April 1, 2009, and June 30, 2017.\n'
                  '✔️ Farmers with outstanding loans of up to ₹1.5 lakh.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Application Process
            const Text(
              'Application Process',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Visit the nearest cooperative or nationalized bank.\n'
                  '2. Submit the necessary documents (Aadhaar card, land records, and loan papers).\n'
                  '3. Fill out the scheme application form.\n'
                  '4. Submit the application and await verification.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isApplied
                      ? null
                      : () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ShivSanmanFormPage(userId: _userId!),
                      ),
                    );

                    if (result == 'applied' && mounted) {
                      setState(() => _isApplied = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('You applied successfully!')),
                      );
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: Text(_isApplied ? 'Already Applied' : 'Apply Now'),
                  style: _buttonStyle(
                      _isApplied ? Colors.grey : Colors.green[600]!),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                  style: _buttonStyle(Colors.grey[600]!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Benefit tile widget
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
        leading: Icon(
          icon,
          color: Colors.green[700],
          size: 30,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

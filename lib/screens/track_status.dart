import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrackStatusScreen extends StatelessWidget {
  const TrackStatusScreen({super.key});

  // Map Firestore document IDs to user-friendly scheme names
  static const Map<String, String> schemeNameMap = {
    'mkisan': 'M-Kisan',
    'KCC': 'Kisan Credit Card',
    'ACABC': 'Agri Clinics & Agri Business Centers',
    'PM Kisan': 'PM-Kisan Samman Nidhi',
    'pmKusum': 'PM-Kusum Yojana',
    'Soil Health Card': 'Soil Health Card Scheme',
    'PMFBY': 'Pradhan Mantri Fasal Bima Yojana',
    'DBT Agriculture': 'DBT Agriculture',
    'eNAM': 'eNAM (Electronic National Agriculture Market)',
    'naif': 'National Agri Infra Financing Facility',
    'KisanSuvidha': 'Kisan Suvidha Portal',
    'PKV Scheme': 'PMKSY – Pradhan Mantri Krishi Sinchayee Yojana',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Status"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getAppliedForms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }

          final appliedForms = snapshot.data ?? [];

          if (appliedForms.isEmpty) {
            return const Center(
              child: Text(
                "No applications to track yet.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: appliedForms.length,
            itemBuilder: (context, index) {
              final form = appliedForms[index];
              final docId = form['id'] ?? '';
              final schemeName = form['schemeName'] ?? schemeNameMap[docId] ?? 'Unknown Scheme';
              final status = form['status'] ?? 'No Status';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: ListTile(
                  title: Text(schemeName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Status: $status'),
                  leading: const Icon(Icons.description),
                  onTap: () {
                    // Optional: Navigate to detail screen or dialog
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getAppliedForms() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('applications')
          .where('status', isEqualTo: 'applied')
          .get();

      if (snapshot.docs.isEmpty) return [];

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Attach document ID for fallback
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching applied forms: $e');
      return [];
    }
  }
}

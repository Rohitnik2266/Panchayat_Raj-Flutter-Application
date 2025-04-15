import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicationService {
  static Future<bool> hasAppliedForScheme(String schemeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('applications')
        .doc(user.uid)
        .collection('schemes')
        .doc(schemeId)
        .get();

    return doc.exists && (doc['applied'] ?? false);
  }
}
// TODO Implement this library.
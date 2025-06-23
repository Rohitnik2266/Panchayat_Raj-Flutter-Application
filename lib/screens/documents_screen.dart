import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // ← import localization

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  List<Map<String, dynamic>> documents = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final schemesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('schemes')
        .get();

    List<Map<String, dynamic>> allDocs = [];

    for (var schemeDoc in schemesSnapshot.docs) {
      final schemeName = schemeDoc.id;
      final data = schemeDoc.data();

      if (data['documents'] != null && data['documents'] is Map) {
        final docsMap = Map<String, dynamic>.from(data['documents']);
        for (var entry in docsMap.entries) {
          allDocs.add({
            'name': entry.key,
            'url': entry.value,
            'form': schemeName,
          });
        }
      }
    }

    setState(() {
      documents = allDocs;
      loading = false;
    });
  }

  void _openDocument(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.couldNotOpenDoc)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.myDocuments),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : documents.isEmpty
          ? Center(child: Text(t.noDocuments))
          : ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final doc = documents[index];
          return ListTile(
            leading: const Icon(Icons.insert_drive_file),
            title: Text(doc['name']),
            subtitle: Text("${t.scheme}: ${doc['form']}"),
            trailing: IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () => _openDocument(doc['url']),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TrackStatusScreen extends StatelessWidget {
  const TrackStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Status"),
      ),
      body: const Center(
        child: Text(
          "No applications to track yet.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

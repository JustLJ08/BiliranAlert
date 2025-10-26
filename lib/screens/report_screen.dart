import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report an Incident')),
      body: const Center(
        child: Text(
          'Report form will go here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

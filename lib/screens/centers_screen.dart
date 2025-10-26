import 'package:flutter/material.dart';

class CentersScreen extends StatelessWidget {
  const CentersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evacuation Centers')),
      body: const Center(
        child: Text(
          'List of nearby evacuation centers will appear here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

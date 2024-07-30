// Example page for Money
import 'package:flutter/material.dart';

class StashPage extends StatelessWidget {
  const StashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Page'),
      ),
      body: const Center(
        child: Text('Money Page Content'),
      ),
    );
  }
}
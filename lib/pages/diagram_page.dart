import 'package:flutter/material.dart';

class DiagramPage extends StatefulWidget {
  const DiagramPage({super.key});

  @override
  State<DiagramPage> createState() => _DiagramPageState();
}

class _DiagramPageState extends State<DiagramPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diagram"),
      ),
      body: const Center(
        child: Text("Diagram under development"),
      ),
    );
  }
}

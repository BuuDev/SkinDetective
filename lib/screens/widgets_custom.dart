import 'package:flutter/material.dart';

class WidgetsCustom extends StatelessWidget {
  const WidgetsCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widgets custom'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [],
      ),
    );
  }
}

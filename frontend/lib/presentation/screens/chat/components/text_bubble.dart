import 'package:flutter/material.dart';

class TextBubble extends StatelessWidget {
  final String text;

  const TextBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(text),
      ),
    );
  }
}

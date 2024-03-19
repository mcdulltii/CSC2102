import 'package:flutter/material.dart';

class TextBubble extends StatelessWidget {
  final String text;
  final bool isBot;

  const TextBubble({Key? key, required this.text, required this.isBot})
      : super(key: key);

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

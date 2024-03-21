import 'package:flutter/material.dart';
import 'package:frontend/presentation/theme/theme.dart';

class TextBubble extends StatelessWidget {
  final String text;
  final bool isBot;

  const TextBubble({Key? key, required this.text, required this.isBot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isBot ? AppTheme.primaryColor: null,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(text.trim(),
        style: TextStyle(color: isBot? AppTheme.whiteBackgroundColor: AppTheme.blackColor)),
      ),
    );
  }
}

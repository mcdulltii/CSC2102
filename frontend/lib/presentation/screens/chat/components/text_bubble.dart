import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

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
        child: isBot
            ? AnimatedTextKit(
                isRepeatingAnimation: false,
                totalRepeatCount: 1,
                animatedTexts: [
                  TyperAnimatedText(
                    text,
                    textStyle: const TextStyle(fontSize: 16),
                    speed: const Duration(milliseconds: 20),
                  ),
                ],
              )
            : Text(text),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:frontend/presentation/theme/theme.dart';

class AnimationBubble extends StatelessWidget {
  final String text;
  final Function callback;
  const AnimationBubble({
    Key? key,
    required this.text,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String truncatedText = _truncateText(text.trim(), 15);
    return GestureDetector(
      onTap: () => callback(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        constraints: const BoxConstraints(maxWidth: 350),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: AnimatedTextKit(
          onTap: () => callback(),
          animatedTexts: [
            TyperAnimatedText(
              truncatedText,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.start,
              speed: const Duration(milliseconds: 40),
            ),
          ],
          isRepeatingAnimation: false,
          totalRepeatCount: 1,
        ),
      ),
    );
  }

  String _truncateText(String text, int maxWords) {
    List<String> words = text.split(' ');
    if (words.length <= maxWords) {
      return text; // Return original text if it contains 30 or fewer words
    } else {
      // Truncate the text to the original 30 words and add "..."
      return "${words.take(maxWords).join(' ')}...";
    }
  }
}
import 'package:flutter/material.dart';
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
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void navigateWithFadeTransition(
  BuildContext context,
  Widget destinationPage, {
  int durationTime = 500,
}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destinationPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: durationTime),
    ),
  );
}

import 'package:flutter/material.dart';
import "package:animations/animations.dart";

class ScreenChangeAnimation extends StatefulWidget {
  const ScreenChangeAnimation({super.key, required this.child});

  final Widget child;

  @override
  State<ScreenChangeAnimation> createState() => _ScreenChangeAnimationState();
}

class _ScreenChangeAnimationState extends State<ScreenChangeAnimation> {
  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return SharedAxisTransition(
          transitionType: SharedAxisTransitionType.horizontal,
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      duration: const Duration(milliseconds: 400),
      child: widget.child,
    );
  }
}

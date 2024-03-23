import 'package:flutter/material.dart';
import "package:animations/animations.dart";

class SlidingFadeTransition extends StatefulWidget {
  const SlidingFadeTransition({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
  });

  final Widget child;
  final Duration duration;

  @override
  State<SlidingFadeTransition> createState() => _SlidingFadeTransitionState();
}

class _SlidingFadeTransitionState extends State<SlidingFadeTransition>
    with TickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      duration: widget.duration,
      child: widget.child,
    );
    // return PageTransitionSwitcher(
    //   transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
    //     return SharedAxisTransition(
    //       transitionType: SharedAxisTransitionType.horizontal,
    //       animation: primaryAnimation,
    //       secondaryAnimation: secondaryAnimation,
    //       child: child,
    //     );
    //   },
    //   duration: widget.duration,
    //   child: widget.child,
    // );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

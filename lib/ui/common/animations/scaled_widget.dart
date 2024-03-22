import 'package:flutter/material.dart';

class ScaledAnimation extends StatefulWidget {
  const ScaledAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
  });

  final Widget child;
  final Duration duration;

  @override
  State<ScaledAnimation> createState() => _ScaledAnimationState();
}

class _ScaledAnimationState extends State<ScaledAnimation>
    with TickerProviderStateMixin {
  late final animationController = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..animateTo(1);
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animationController,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
      child: widget.child,
    );
  }
  
  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }
}

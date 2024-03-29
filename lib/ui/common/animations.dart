import 'package:flutter/material.dart';

class ColorChangingContainer extends StatefulWidget {
  const ColorChangingContainer({
    super.key,
    required this.child,
    this.color,
    this.duration = const Duration(seconds: 1),
    this.curves = Curves.ease,
  });

  final Widget child;
  final Duration duration;
  final Color? color;
  final Curve curves;

  @override
  State<ColorChangingContainer> createState() => _ColorChangingContainerState();
}

class _ColorChangingContainerState extends State<ColorChangingContainer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: widget.curves,
      color: widget.color ?? Theme.of(context).primaryColor,
      child: widget.child,
    );
  }
}

class SlidingFadeTransition extends StatefulWidget {
  const SlidingFadeTransition({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.offsetBegin = const Offset(1, 0),
    this.offsetEnd = Offset.zero,
  });

  final Widget child;
  final Duration duration;
  final Offset offsetBegin;
  final Offset offsetEnd;

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
            begin: widget.offsetBegin,
            end: widget.offsetEnd,
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
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class ScaledAnimation extends StatefulWidget {
  const ScaledAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
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
        curve: Curves.ease,
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

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

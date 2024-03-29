import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoadingAnimationWidget.discreteCircle(
        color: Theme.of(context).primaryColor,
        size: 50,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scf_new/ui/common/animations/change_screen.dart';
import 'package:scf_new/ui/common/animations/scaled_widget.dart';

class FirstTestScreen extends StatelessWidget {
  const FirstTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text("Next"),
        ),
      ),
    );
  }
}

class SecondTestScreen extends StatelessWidget {
  const SecondTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Center(
        child: ScaledAnimation(
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("Back"),
          ),
        ),
      ),
    );
  }
}

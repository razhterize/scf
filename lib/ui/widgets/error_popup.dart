import 'package:flutter/material.dart';

class WarningPopup extends StatelessWidget {
  const WarningPopup(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Text(message),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}

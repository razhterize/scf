import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  const Popup(this.message, {super.key, this.callback});

  final String message;
  final void Function()? callback;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      content: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(message),
      ),
      actions: [
        MaterialButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Nah, go back"),
        ),
        MaterialButton(
          onPressed: () {
            callback != null ? callback!() : null;
            Navigator.pop(context);
          },
          child: const Text("DO IT!!!"),
        )
      ],
    );
  }
}

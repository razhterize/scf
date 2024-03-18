import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  const Popup(this.message, {super.key, this.callback});

  final String message;
  final void Function()? callback;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Text(message),
          Row(
            children: [
              const Spacer(),
              Expanded(
                child: MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () => callback,
                  child: const Text("DO IT!!!"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

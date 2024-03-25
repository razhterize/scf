import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConfirmationPopup extends StatelessWidget {
  const ConfirmationPopup(this.content, {super.key, this.callback});

  final void Function()? callback;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: [
            Center(child: Text(content, textAlign: TextAlign.center,)),
            const SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Nah, go back"),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      callback?.call();
                      Navigator.of(context).pop();
                    },
                    child: const Text("DO IT!!"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

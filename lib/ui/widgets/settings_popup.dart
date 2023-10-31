import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_management/providers/settings_bloc.dart';

class SettingsPopup extends StatefulWidget {
  const SettingsPopup({super.key});

  @override
  State<SettingsPopup> createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<SettingsPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ListView(
        children: const [
          ListTile(
            title: Text("Theme"),
            trailing: DropdownMenu(
              label: Text("Theme"),
              dropdownMenuEntries: [
                DropdownMenuEntry(value: false, label: "Dark"),
                DropdownMenuEntry(value: true, label: "Light"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

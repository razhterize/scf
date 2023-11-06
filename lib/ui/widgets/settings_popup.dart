import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_management/providers/settings_bloc.dart';

class SettingsPopup extends StatefulWidget {
  const SettingsPopup({super.key});

  @override
  State<SettingsPopup> createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<SettingsPopup> {
  final TextEditingController databaseController = TextEditingController();
  final TextEditingController themeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        return AlertDialog(
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 10, 10),
              child: ElevatedButton.icon(
                onPressed: () {
                  if (databaseController.text == "") databaseController.text = state.databaseUrl;
                  BlocProvider.of<SettingBloc>(context).add(SetSettings(databaseUrl: databaseController.text));
                },
                icon: const Icon(Icons.save),
                label: const Text("Save"),
              ),
            ),
          ],
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: content(state, context),
            ),
          ),
        );
      },
    );
  }

  ListView content(SettingState state, BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: state.lightMode ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
          title: const Text("Theme"),
          trailing: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownMenu(
              label: const Text("Theme"),
              initialSelection: state.lightMode,
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: false, label: "Dark"),
                DropdownMenuEntry(value: true, label: "Light"),
              ],
              onSelected: (value) {
                BlocProvider.of<SettingBloc>(context).add(SetSettings(lightMode: value!));
              },
            ),
          ),
        ),
        ListTile(
          title: TextField(
            decoration: InputDecoration(
              label: const Text("Database URL"),
              hintText: state.databaseUrl,
            ),
            controller: databaseController,
          ),
        )
      ],
    );
  }
}

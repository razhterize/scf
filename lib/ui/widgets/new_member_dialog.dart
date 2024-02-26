import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:scf_management/blocs/guild_bloc.dart';

class NewMemberDialog extends StatefulWidget {
  const NewMemberDialog({super.key});

  @override
  State<NewMemberDialog> createState() => _NewMemberDialogState();
}

class _NewMemberDialogState extends State<NewMemberDialog> {
  final nameController = TextEditingController();
  final pgrIdController = TextEditingController();
  final discIdController = TextEditingController();
  final discUsernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(label: Text("Name")),
                  controller: nameController,
                  onFieldSubmitted: (value) => validate(),
                  validator: (value) => (value == null || value == "") ? "Name cannot be empty" : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(label: Text("PGR ID")),
                  controller: pgrIdController,
                  onFieldSubmitted: (value) => validate(),
                  validator: (value) => (value!.length != 8) ? "PGR ID must be 8 digits long" : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(label: Text("Discord Username")),
                  controller: discUsernameController,
                  onFieldSubmitted: (value) => validate(),
                ),
                TextFormField(
                  decoration: const InputDecoration(label: Text("Discord ID")),
                  controller: discIdController,
                  onFieldSubmitted: (value) => validate(),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text("Cancel"),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: BlocProvider.of<GuildBloc>(context).state.operation
                      ? null
                      : () {
                          validate();
                          Navigator.pop(context);
                        },
                  icon: BlocProvider.of<GuildBloc>(context).state.operation ? LoadingAnimationWidget.horizontalRotatingDots(color: Colors.white, size: 25) : const Icon(Icons.save),
                  label: const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void validate() {
    BlocProvider.of<GuildBloc>(context).add(Busy(true));
    if (formKey.currentState!.validate()) {
      BlocProvider.of<GuildBloc>(context).add(Busy(true));
      var data = {
        "name": nameController.text,
        "pgr_id": int.tryParse(pgrIdController.text),
        "discord_username": discUsernameController.text,
        "discord_id": discIdController.text,
        "guild": BlocProvider.of<GuildBloc>(context).state.guild.name,
        "siege": {"status": "noScore", "current_score": 0, "past_scores": []},
        "maze": {
          "status": "unknown",
          "energy_overcap": [
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
          ],
          "energy_used": [0, 0, 0],
          "energy_wrong_node": [
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
          ],
          "total_points": [0, 0, 0]
        }
      };
      BlocProvider.of<GuildBloc>(context).add(AddMember(data));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New member ${nameController.text} has been added")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong, or you entered invalid data, either way, it didn't success"),
        ),
      );
    }
    BlocProvider.of<GuildBloc>(context).add(Busy(false));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/guild_cubit.dart';

import '../../models/member_model.dart';

class MemberEdit extends StatefulWidget {
  const MemberEdit({super.key, required this.member});

  final Member member;

  @override
  State<MemberEdit> createState() => _MemberEditState();
}

class _MemberEditState extends State<MemberEdit> {
  late Member member;

  final formKey = GlobalKey<FormState>();
  final List<TextEditingController> controllers = [];

  @override
  void initState() {
    member = widget.member;

    controllers.add(TextEditingController(text: member.name));
    controllers.add(TextEditingController(text: member.pgrId.toString()));
    controllers.add(TextEditingController(text: member.discordUsername));
    controllers.add(TextEditingController(text: member.discordId.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(4),
        child: Wrap(
          children: [
            TextFormField(
              controller: controllers[0],
              decoration: const InputDecoration(labelText: "Name"),
              onFieldSubmitted: (_) => validate(),
              validator: (value) =>
                  value != null && value != "" ? null : "Name Cannot be empty",
              // onChanged: (value) => member.name = value,
            ),
            TextFormField(
                controller: controllers[1],
                decoration: const InputDecoration(labelText: "PGR ID"),
                onFieldSubmitted: (_) => validate(),
                validator: (value) => value != null && value != ""
                    ? value.length != 8
                        ? "PGR ID Must Be 8 Digits"
                        : null
                    : "PGR ID Cannot be empty"),
            TextFormField(
              controller: controllers[2],
              decoration: const InputDecoration(labelText: "Discord Username"),
              onFieldSubmitted: (_) => validate(),
            ),
            TextFormField(
              controller: controllers[3],
              decoration: const InputDecoration(labelText: "Discord ID"),
              onFieldSubmitted: (_) => validate(),
            ),
          ],
        ),
      ),
    );
  }

  void validate() {
    if (formKey.currentState!.validate()) {
      member.name = controllers[0].text;
      member.pgrId = int.parse(controllers[1].text);
      member.discordUsername = controllers[2].text;
      member.discordId = controllers[3].text;
      context.read<GuildCubit>().updateMember(member);
      Navigator.pop(context);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../blocs/guild_bloc.dart';
import '../../models/member_model.dart';

class EditMemberWidget extends StatefulWidget {
  const EditMemberWidget({super.key, required this.member});

  final Member member;

  @override
  State<EditMemberWidget> createState() => _EditMemberWidgetState();
}

class _EditMemberWidgetState extends State<EditMemberWidget> {
  final logger = Logger("Edit Member");
  final formKey = GlobalKey<FormState>();

  late Member member;

  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    member = widget.member;
    controllers[0].text = member.name;
    controllers[1].text = member.pgrId.toString();
    controllers[2].text = member.discordUsername ?? "";
    controllers[3].text = member.discordId ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: formKey,
        child: Wrap(
          children: [
            InfoField(
              controller: controllers[0],
              label: "Name",
              validator: (value) => value == "" || value == null ? "Name cannot be empty" : null,
              onSubmit: (value) => validate(),
            ),
            InfoField(
              validator: (value) => value == null
                  ? "PGR ID cannot be empty"
                  : value.length != 8
                      ? "PGR ID must be 8 digits long"
                      : null,
              onSubmit: (value) => validate(),
              controller: controllers[1],
              label: "PGR ID",
            ),
            InfoField(
              controller: controllers[2],
              label: "Discord Username",
              onSubmit: (value) => validate(),
            ),
            InfoField(
              controller: controllers[3],
              label: "Discord ID",
              onSubmit: (value) => validate(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => validate(),
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
// TODO Fix AddMember
// TODO Find out why it didnt work
// TODO Guild Selection on New Member (Default to current guild from GuildBloc)
  void validate() {
    logger.fine("Validate called");
    if (formKey.currentState!.validate()) {
      logger.fine("Valid Form");
      member.name = controllers[0].text;
      member.pgrId = int.parse(controllers[1].text);
      member.discordUsername = controllers[2].text;
      member.discordId = controllers[3].text;
      if (member.id != '') {
        context.read<GuildBloc>().add(UpdateMember(member));
      }else{
        context.read<GuildBloc>().add(AddMember(member.toMap()));
      }
      Navigator.of(context).pop();
      return;
    }
    logger.fine("Form invalid");
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class InfoField extends StatelessWidget {
  const InfoField({super.key, required this.label, this.controller, this.validator, this.onSubmit});

  final String? Function(String? value)? validator;
  final void Function(String? value)? onSubmit;

  final String label;

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(label: Text(label)),
      validator: (value) => validator == null ? null : validator!(value),
      onFieldSubmitted: (value) => onSubmit == null ? null : onSubmit!(value),
      controller: controller,
    );
  }
}

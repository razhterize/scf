import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_management/models/member.dart';
import 'package:scf_management/providers/guild_bloc.dart';
import 'package:scf_management/providers/login_cubit.dart';

class MemberDetails extends StatefulWidget {
  const MemberDetails({super.key, required this.member});

  final Member member;

  @override
  State<MemberDetails> createState() => _MemberDetailsState();
}

class _MemberDetailsState extends State<MemberDetails> {
  final nameController = TextEditingController();
  final pgrIdController = TextEditingController();
  final discIdController = TextEditingController();
  final discUsernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late Member member;

  @override
  void initState() {
    member = widget.member;
    nameController.text = member.name!;
    pgrIdController.text = member.pgrId.toString();
    discIdController.text = member.discordId!;
    discUsernameController.text = member.discordUsername!;
    super.initState();
  }

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
                  decoration: InputDecoration(hintText: member.name, label: const Text("Name")),
                  controller: nameController,
                  onFieldSubmitted: (value) {
                    validate();
                  },
                  validator: (value) {
                    if (value == null || value == "") return "Name cannot be empty";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "${member.pgrId}", label: const Text("PGR ID")),
                  controller: pgrIdController,
                  onFieldSubmitted: (value) {
                    validate();
                  },
                  validator: (value) {
                    if (value!.length != 8) return "PGR ID must be 8 digits long";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: member.discordUsername, label: const Text("Discord Username")),
                  controller: discUsernameController,
                  onFieldSubmitted: (value) {
                    validate();
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: member.discordId, label: const Text("Discord ID")),
                  controller: discIdController,
                  onFieldSubmitted: (value) {
                    validate();
                  },
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
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    validate();
                  },
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void validate() async {
    if (formKey.currentState!.validate()) {
      member.discordId = discIdController.text;
      member.discordUsername = discUsernameController.text;
      member.name = nameController.text;
      member.pgrId = int.tryParse(pgrIdController.text);
      member.update(BlocProvider.of<LoginCubit>(context).pb);
      setState(() {});
      Navigator.pop(context);
    }
  }
}

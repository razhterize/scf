import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/switch_cubit.dart';

import '../../constants.dart';
import '../../enums.dart';
import '../../blocs/guild_cubit.dart';
import '../../blocs/selection_cubit.dart';
import '../../models/member_model.dart';
import '../../ui/widgets/popup.dart';

class StatusSelections extends StatelessWidget {
  const StatusSelections({
    super.key,
    required this.member,
    required this.statuses,
  });
  final Member member;
  final List statuses;

  @override
  Widget build(BuildContext context) {
    final selectionCubit = context.read<SelectionCubit>();
    return Wrap(
      children: [
        BlocBuilder<SwitchCubit, SwitchState>(
          builder: (context, state) => state.mode == ManagementMode.maze
              ? SizedBox(
                  width: 250,
                  child: energyDamageField(context),
                )
              : Container(),
        ),
        BlocBuilder<SwitchCubit, SwitchState>(
          builder: (context, state) => state.mode == ManagementMode.maze
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 16, 2),
                  child: ChoiceChip(
                    label: const Text("Hidden"),
                    selected: member.mazeData.hidden ?? false,
                    onSelected: (value) {
                      if (selectionCubit.state.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (_) => Popup(
                            "You're about to change ${selectionCubit.state.length} members hidden status\nDo it?",
                            callback: () => _batchHiddenChange(context, value),
                          ),
                        );
                        return;
                      }
                      member.mazeData.hidden = value;
                      context.read<GuildCubit>().updateMember(member);
                    },
                  ),
                )
              : Container(),
        ),
        for (var status in statuses)
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              selectedColor: statusColors[status],
              label: Text(
                statusNames[status] ?? status.name,
                style: TextStyle(
                  color: member.mazeData.status == status ||
                          member.siegeStatus == status
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              selected: member.siegeStatus == status ||
                  member.mazeData.status == status,
              onSelected: (value) {
                if (selectionCubit.state.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => Popup(
                      "You're about to change ${selectionCubit.state.length} members status to ${statusNames[status]}\nDo it?",
                      callback: () => _batchStatusChange(context, status),
                    ),
                  );
                  return;
                }
                SiegeStatus.values.contains(status)
                    ? member.siegeStatus = status
                    : member.mazeData.status = status;
                context.read<GuildCubit>().updateMember(member);
              },
            ),
          )
      ],
    );
  }

  Form energyDamageField(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();
    controller.text = member.mazeData.energyDamage.toString();
    return Form(
      key: formKey,
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
            label: Text("Energy Damage"),
            enabledBorder: InputBorder.none,
            isDense: true),
        keyboardType: TextInputType.number,
        validator: (value) => RegExp(r'^[0-9]+$').hasMatch(value!)
            ? null
            : 'Only numbers allowed',
        onFieldSubmitted: (value) {
          if (formKey.currentState!.validate()) {
            member.mazeData.energyDamage = int.parse(value);
            context.read<GuildCubit>().updateMember(member);
          }
        },
      ),
    );
  }

  void _batchStatusChange(BuildContext context, status) {
    print("Batch Status called");
    context.read<SelectionCubit>().doSomethingAboutSelectedMembers((member) {
      SiegeStatus.values.contains(status)
          ? member.siegeStatus = status
          : member.mazeData.status = status;
      context.read<GuildCubit>().updateMember(member);
    });
  }

  void _batchHiddenChange(BuildContext context, bool value) {
    context.read<SelectionCubit>().doSomethingAboutSelectedMembers(
      (member) {
        member.mazeData.hidden = value;
        context.read<GuildCubit>().updateMember(member);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        for (var status in statuses)
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              selectedColor: statusColors[status],
              label: Text(
                statusNames[status] ?? status.name,
                style: TextStyle(
                  color: member.mazeStatus == status ||
                          member.siegeStatus == status
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              selected:
                  member.siegeStatus == status || member.mazeStatus == status,
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
                    : member.mazeStatus = status;

                context.read<GuildCubit>().updateMember(member);
              },
            ),
          )
      ],
    );
  }

  void _batchStatusChange(BuildContext context, status) {
    print("Batch Status called");
    context.read<SelectionCubit>().doSomethingAboutSelectedMembers((member) {
      SiegeStatus.values.contains(status)
          ? member.siegeStatus = status
          : member.mazeStatus = status;
      context.read<GuildCubit>().updateMember(member);
    });
  }
}

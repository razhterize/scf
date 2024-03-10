import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/guild_bloc.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../models/member_model.dart';

class StatusSelections extends StatelessWidget {
  const StatusSelections({super.key, required this.member, required this.statuses});
  final Member member;
  final List statuses;

  @override
  Widget build(BuildContext context) {
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
                  color: member.mazeStatus == status || member.siegeStatus == status ? Colors.black : Colors.white,
                ),
              ),
              selected: member.siegeStatus == status || member.mazeStatus == status,
              onSelected: (value) {
                if (SiegeStatus.values.contains(status)) {
                  member.siegeStatus = status;
                } else if (MazeStatus.values.contains(status)) {
                  member.mazeStatus = status;
                }
                context.read<GuildBloc>().add(UpdateMember(member));
              },
            ),
          )
      ],
    );
  }
}

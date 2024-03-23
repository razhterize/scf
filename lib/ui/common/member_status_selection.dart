import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/guild_cubit.dart';
import 'package:scf_new/blocs/switch_cubit.dart';
import 'package:scf_new/constants.dart';
import 'package:scf_new/enums.dart';

import '../../models/member_model.dart';
import 'animations/sliding_fade_transition.dart';

class MemberStatusSelection extends StatelessWidget {
  const MemberStatusSelection(this.member, {super.key});

  final Member member;

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<SwitchCubit>().state.mode;
    return SlidingFadeTransition(
      duration: const Duration(milliseconds: 500),
      child: switch (mode) {
        ManagementMode.siege => DropdownButton<SiegeStatus>(
            value: member.siegeStatus,
            items: [
              for (var s in SiegeStatus.values)
                DropdownMenuItem(
                  value: s,
                  child: Text(statusNames[s] ?? s.name),
                )
            ],
            onChanged: (value) {
              member.siegeStatus = value!;
              context.read<GuildCubit>().updateMember(member);
            },
          ),
        ManagementMode.maze => DropdownButton<MazeStatus>(
            value: member.mazeData.status,
            items: [
              for (var m in MazeStatus.values)
                DropdownMenuItem(
                  value: m,
                  child: Text(statusNames[m] ?? m.name),
                )
            ],
            onChanged: (value) {
              member.mazeData.status = value!;
              context.read<GuildCubit>().updateMember(member);
            },
          ),
        _ => IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
      },
    );
  }

  bool isSiege(status) => SiegeStatus.values.contains(status);
}

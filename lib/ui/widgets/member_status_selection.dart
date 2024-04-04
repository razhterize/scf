import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/guild_cubit.dart';
import 'package:scf_new/blocs/selection_cubit.dart';
import 'package:scf_new/blocs/switch_cubit.dart';
import 'package:scf_new/constants.dart';
import 'package:scf_new/enums.dart';
import 'package:scf_new/ui/widgets/member_edit.dart';

import '../../models/member_model.dart';
import '../common/animations.dart';

class MemberStatusSelection extends StatelessWidget {
  const MemberStatusSelection(this.member, {super.key});

  final Member member;

  @override
  Widget build(BuildContext context) {
    return SlidingFadeTransition(
      duration: const Duration(milliseconds: 500),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _additionalInfo(context),
          ),
          _statusSelection(context),
        ],
      ),
    );
  }

  Widget _additionalInfo(BuildContext context) {
    return switch (context.watch<SwitchCubit>().state.mode) {
      ManagementMode.siege => const SizedBox(),
      ManagementMode.maze => BlocBuilder<GuildCubit, GuildState>(
          builder: (context, state) {
            return MaterialButton(
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: member.mazeData.hidden ? Colors.red : Colors.green,
                ),
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(8),
                child: const Text("Hidden"),
              ),
              onPressed: () {
                member.mazeData.hidden = !member.mazeData.hidden;
                context.read<GuildCubit>().updateMember(member);
              },
            );
          },
        ),
      _ => const SizedBox(),
    };
  }

  Widget _statusSelection(BuildContext context) {
    final mode = context.watch<SwitchCubit>().state.mode;
    final selectCubit = context.read<SelectionCubit>();
    return switch (mode) {
      ManagementMode.siege => DropdownButton<SiegeStatus>(
          value: member.siegeStatus,
          items: [
            for (var s in SiegeStatus.values)
              DropdownMenuItem(
                value: s,
                child: Text(
                  statusNames[s] ?? s.name,
                  style: textStyle(s),
                ),
              )
          ],
          onChanged: (value) {
            if (selectCubit.state.isNotEmpty) {
              selectCubit.doSomethingAboutSelectedMembers((m) {
                m.siegeStatus = value!;
                context.read<GuildCubit>().updateMember(m);
              });
              return;
            }
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
                child: Text(
                  statusNames[m] ?? m.name,
                  style: textStyle(m),
                ),
              )
          ],
          onChanged: (value) {
            member.mazeData.status = value!;
            context.read<GuildCubit>().updateMember(member);
          },
        ),
      _ => IconButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (_) {
                  return MemberEdit(member: member);
                });
          },
          icon: const Icon(Icons.edit),
        ),
    };
  }

  TextStyle textStyle(dynamic status) => TextStyle(color: statusColors[status]);

  bool isSiege(status) => SiegeStatus.values.contains(status);
}

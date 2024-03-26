import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/guild_cubit.dart';
import 'package:scf_new/blocs/switch_cubit.dart';
import 'package:scf_new/enums.dart';
import 'package:scf_new/ui/common/animations.dart';
import 'package:scf_new/ui/widgets/member_status_selection.dart';

import '../../blocs/selection_cubit.dart';
import '../../models/member_model.dart';

class MemberCard extends StatefulWidget {
  const MemberCard(this.member, {super.key});

  final Member member;

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  bool isExpanded = false;
  late Member member;

  final subtitleController = TextEditingController();

  @override
  void initState() {
    member = widget.member;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectCubit = context.read<SelectionCubit>();
    // final switchCubit = context.read<SwitchCubit>();
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: BlocBuilder<SelectionCubit, List>(
          builder: (context, state) {
            return ListTile(
              selected: selectCubit.isSelected(member),
              selectedColor:
                  Theme.of(context).textSelectionTheme.selectionHandleColor,
              title: _nameIdText(),
              subtitle: _subtitle(),
              onTap: () => selectCubit.changeSelect(member),
              leading: Checkbox(
                value: selectCubit.isSelected(member),
                onChanged: (_) => selectCubit.changeSelect(member),
              ),
              trailing: MemberStatusSelection(member),
            );
          },
        ),
      ),
    );
  }

  Widget _subtitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: BlocBuilder<SwitchCubit, SwitchState>(
            builder: (context, state) {
              subtitleController.text =
                  context.read<SwitchCubit>().state.mode == ManagementMode.maze
                      ? member.mazeData.energyDamage.toString()
                      : "";
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: state.mode == ManagementMode.members
                    ? const SizedBox()
                    : TextField(
                        key: ValueKey<ManagementMode>(state.mode),
                        style: Theme.of(context).textTheme.bodyMedium,
                        controller: subtitleController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          border: InputBorder.none,
                          labelText: state.mode == ManagementMode.siege
                              ? "Siege Score (WIP)"
                              : state.mode == ManagementMode.maze
                                  ? "Maze Energy Damage"
                                  : "",
                        ),
                        enabled: state.mode != ManagementMode.siege,
                        onSubmitted: (value) {
                          member.mazeData.energyDamage = int.tryParse(value) ?? 0;
                          context.read<GuildCubit>().updateMember(member);
                        },
                      ),
              );
            },
          ),
        ),
      ],
    );
  }

  RichText _nameIdText() {
    return RichText(
      text: TextSpan(
        text: member.name,
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(
              text: "\n${member.pgrId}",
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

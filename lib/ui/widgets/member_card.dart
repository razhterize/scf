import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/switch_cubit.dart';
import 'package:scf_new/enums.dart';
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

  @override
  Widget build(BuildContext context) {
    final selectCubit = context.read<SelectionCubit>();
    final switchCubit = context.read<SwitchCubit>();
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: BlocBuilder<SelectionCubit, List>(
          builder: (context, state) {
            return ListTile(
              selected: selectCubit.isSelected(widget.member),
              selectedColor: Theme.of(context)
                  .textSelectionTheme
                  .selectionHandleColor,
              title: _nameIdText(),
              subtitle: _subtitle(),
              onTap: () => selectCubit.changeSelect(widget.member),
              leading: Checkbox(
                value: selectCubit.isSelected(widget.member),
                onChanged: (_) =>
                    selectCubit.changeSelect(widget.member),
              ),
              trailing: MemberStatusSelection(widget.member),
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
              if (state.mode == ManagementMode.members) return const SizedBox();
              return TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  border: InputBorder.none,
                  labelText: state.mode == ManagementMode.siege
                      ? "Siege Score"
                      : state.mode == ManagementMode.maze
                          ? "Maze Energy Damage"
                          : "",
                ),
                onChanged: (value) {},
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
        text: widget.member.name,
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(
              text: "\n${widget.member.pgrId}",
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

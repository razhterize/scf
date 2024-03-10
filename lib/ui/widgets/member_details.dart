import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/ui/widgets/member_edit_widgets.dart';
import 'package:scf_new/ui/widgets/status_selection.dart';

import '../../blocs/switch_cubit.dart';
import '../../enums.dart';
import '../../models/member_model.dart';

class MemberDetail extends StatefulWidget {
  const MemberDetail({super.key, required this.member, required this.onSelect});
  final Member member;

  final Function(bool selected) onSelect;

  @override
  State<MemberDetail> createState() => _MemberDetailState();
}

class _MemberDetailState extends State<MemberDetail> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        onChanged: (value) {
          setState(() => selected = value as bool);
          widget.onSelect(selected);
        },
        value: selected,
      ),
      title: Text(widget.member.name),
      selectedTileColor: const Color.fromARGB(121, 0, 94, 255),
      onTap: context.read<SwitchCubit>().state.mode == ManagementMode.members
          ? () => openEditWindow(widget.member)
          : () => setState(() {
                selected = !selected;
                widget.onSelect(selected);
              }),
      selected: selected,
      subtitle: Text("${widget.member.pgrId}"),
      trailing: BlocBuilder<SwitchCubit, SwitchState>(
        builder: (context, state) {
          if (state.mode == ManagementMode.members) {
            return SizedBox();
          }
          return context.read<SwitchCubit>().state.mode == ManagementMode.siege
              ? StatusSelections(member: widget.member, statuses: SiegeStatus.values)
              : StatusSelections(member: widget.member, statuses: MazeStatus.values);
        },
      ),
      // trailing:
    );
  }

  void openEditWindow(Member member) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return EditMemberWidget(member: member);
      },
    );
  }
}

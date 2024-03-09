import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          // value: widget.contains(widget.member),
        ),
        title: Text(widget.member.name),
        subtitle: Text("${widget.member.pgrId}"),
        selected: false,
        trailing: context.read<SwitchCubit>().state.mode == ManagementMode.siege
            ? StatusSelections(member: widget.member, statuses: SiegeStatus.values)
            : StatusSelections(member: widget.member, statuses: MazeStatus.values));
  }
}

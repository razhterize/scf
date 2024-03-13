import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/guild_bloc.dart';
import '../../ui/widgets/member_edit_widgets.dart';
import '../../ui/widgets/status_selection.dart';
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
            return const SizedBox();
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
      builder: (_) {
        logger.fine("Current Guild Bloc State: ${context.read<GuildBloc>().state.guild.name}");
        return BlocProvider.value(
          value: context.read<GuildBloc>(),
          child: EditMemberWidget(
            member: member,
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/selection_cubit.dart';

import '../../blocs/guild_bloc.dart';
import '../../ui/widgets/member_edit_widgets.dart';
import '../../ui/widgets/status_selection.dart';
import '../../blocs/switch_cubit.dart';
import '../../enums.dart';
import '../../models/member_model.dart';

import 'package:logging/logging.dart';

final logger = Logger("MemberDetail");

class MemberDetail extends StatefulWidget {
  const MemberDetail({super.key, required this.member});
  final Member member;

  @override
  State<MemberDetail> createState() => _MemberDetailState();
}

class _MemberDetailState extends State<MemberDetail> {
  @override
  Widget build(BuildContext context) {
    final switchCubit = context.read<SwitchCubit>();
    var selectionCubit = context.read<SelectionCubit>();
    return BlocBuilder<SelectionCubit, List>(
      builder: (context, state) {
        return ListTile(
          leading: Checkbox(
            onChanged: (value) => selectionCubit.addToList(widget.member),
            value: selectionCubit.isSelected(widget.member),
          ),
          title: Text(widget.member.name),
          selectedTileColor: const Color.fromARGB(121, 0, 94, 255),
          onTap: switchCubit.state.mode == ManagementMode.members
              ? () => openEditWindow(widget.member)
              : () => selectionCubit.changeSelect(widget.member),
              
          selected: selectionCubit.isSelected(widget.member),
          subtitle: Text("${widget.member.pgrId}"),
          trailing: BlocBuilder<SwitchCubit, SwitchState>(
            builder: (context, state) {
              if (state.mode == ManagementMode.members) {
                return const SizedBox();
              }
              return switchCubit.state.mode == ManagementMode.siege
                  ? StatusSelections(
                      member: widget.member, statuses: SiegeStatus.values)
                  : StatusSelections(
                      member: widget.member, statuses: MazeStatus.values);
            },
          ),
          // trailing:
        );
      },
    );
  }

  void openEditWindow(Member member) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        logger.fine(
            "Current Guild Bloc State: ${context.read<GuildBloc>().state.guild.name}");
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

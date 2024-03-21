import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:scf_new/blocs/guild_cubit.dart';
import 'package:scf_new/ui/widgets/popup.dart';

import '../../blocs/selection_cubit.dart';
import '../../enums.dart';
// import '../../blocs/guild_bloc.dart';
import '../../blocs/switch_cubit.dart';
import '../../models/member_model.dart';
import '../../ui/widgets/member_edit_widgets.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});
  @override
  Widget build(BuildContext context) {
    var selectionCubit = context.read<SelectionCubit>();
    return ExpandableFab(
      type: ExpandableFabType.side,
      childrenOffset: const Offset(0, 15),
      openButtonBuilder: DefaultFloatingActionButtonBuilder(
        child: const Icon(Icons.add),
        fabSize: ExpandableFabSize.regular,
        shape: const CircleBorder(),
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        child: const Icon(Icons.remove),
        fabSize: ExpandableFabSize.regular,
        shape: const CircleBorder(),
      ),
      children: [
        BlocBuilder<SwitchCubit, SwitchState>(
          builder: (context, state) {
            return IconButton.filled(
              onPressed: () => state.mode == ManagementMode.members
                  ? deleteSelectedMembers(context)
                  : selectionCubit.selectAll(),
              tooltip: state.mode == ManagementMode.members
                  ? 'Vent Member'
                  : 'Select All',
              icon: state.mode == ManagementMode.members
                  ? const Icon(Icons.person_remove)
                  : const Icon(Icons.select_all),
            );
          },
        ),
        BlocBuilder<SwitchCubit, SwitchState>(
          builder: (context, state) {
            return IconButton.filled(
              onPressed: () => state.mode == ManagementMode.members
                  ? showModalBottomSheet(
                      context: context, builder: (_) => openNewMember(context))
                  : selectionCubit.clearSelections(),
              tooltip: state.mode == ManagementMode.members
                  ? 'Add Member'
                  : 'Deselect All',
              icon: state.mode == ManagementMode.members
                  ? const Icon(Icons.person_add)
                  : const Icon(Icons.deselect),
            );
          },
        ),
        BlocBuilder<SwitchCubit, SwitchState>(
          builder: (context, state) => state.mode != ManagementMode.members
              ? IconButton.filled(
                  onPressed: () => state.mode == ManagementMode.members
                      ? () {}
                      : selectionCubit.selectRange(),
                  icon: const Icon(Icons.library_add_check),
                  tooltip: "Select Range",
                )
              : Container(),
        ),
        BlocBuilder<SwitchCubit, SwitchState>(
          builder: (context, state) => state.mode != ManagementMode.members
              ? IconButton.filled(
                  onPressed: () => copyMentionText(context),
                  icon: const Icon(Icons.alternate_email),
                  tooltip: "Copy Mention Text",
                )
              : Container(),
        )
      ],
    );
  }

  void deleteSelectedMembers(BuildContext context) {
    final selectCubit = context.read<SelectionCubit>();
    showDialog(
      context: context,
      builder: (_) => Popup(
        "You're about to vent ${selectCubit.state.length} members\nDo it?",
        callback: () {
          selectCubit.doSomethingAboutSelectedMembers(
            (member) => context.read<GuildCubit>().deleteMember(member),
          );
        },
      ),
    );
  }

  void copyMentionText(BuildContext context) {
    String mentionText = context
        .read<SelectionCubit>()
        .state
        .map((e) => e.discordId != "" ? "<@${e.discordId}>" : '')
        .join('\n');
    Clipboard.setData(ClipboardData(text: mentionText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Text("Members mention has been copied to clipboard")),
    );
  }

  Widget openNewMember(BuildContext context) {
    var newMember = Member('', '', 0, SiegeStatus.noScore, MazeStatus.unknown);
    return BlocProvider.value(
      value: context.read<GuildCubit>(),
      child: EditMemberWidget(member: newMember),
    );
  }
}

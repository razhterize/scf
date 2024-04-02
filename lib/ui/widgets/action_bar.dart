import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/guild_cubit.dart';
import 'package:scf_new/blocs/selection_cubit.dart';
import 'package:scf_new/enums.dart';
import 'package:scf_new/models/member_model.dart';
import 'package:scf_new/ui/common/confirm_popup.dart';
import 'package:scf_new/ui/widgets/member_edit.dart';

import '../../blocs/login_bloc.dart';

class ActionBar extends StatelessWidget {
  ActionBar({super.key});

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final selectCubit = context.read<SelectionCubit>();
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.all(6),
        child: Flex(
          direction:
              constraints.maxWidth < 720 ? Axis.horizontal : Axis.vertical,
          children: [
            const Spacer(),
            IconButton(
              onPressed: () {
                String mentionText = selectCubit.state
                    .map((e) => e.discordId != null
                        ? "<@${e.discordId}>"
                        : e.discordUsername != null
                            ? "@${e.discordUsername}"
                            : e.name)
                    .join("\n");
                Clipboard.setData(ClipboardData(text: mentionText));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Mention has been copied to clipboard"),
                  duration: Duration(seconds: 3),
                ));
              },
              tooltip: "Copy mention text",
              icon: const Icon(Icons.alternate_email),
            ),
            const Spacer(),
            BlocBuilder<SelectionCubit, List>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: selectCubit.allSelected
                      ? IconButton(
                          onPressed: () => selectCubit.clearSelections(),
                          tooltip: "Remove All Selection",
                          icon: const Icon(Icons.deselect_outlined),
                        )
                      : IconButton(
                          onPressed: () => selectCubit.selectAll(),
                          tooltip: "Select All",
                          icon: const Icon(Icons.select_all_outlined),
                        ),
                );
              },
            ),
            const Spacer(),
            IconButton(
              onPressed: () => selectCubit.selectRange(),
              tooltip: "Select Range",
              icon: const Icon(Icons.library_add_check_outlined),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Member newMember = Member(
                    "",
                    '',
                    0,
                    discordId: '',
                    discordUsername: '',
                    SiegeStatus.newMember,
                    MazeData());
                showModalBottomSheet(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<GuildCubit>(),
                    child: MemberEdit(member: newMember),
                  ),
                );
              },
              tooltip: "Add Member",
              icon: const Icon(Icons.person_add_alt_1),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                if (selectCubit.state.isNotEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) => ConfirmationPopup(
                            "Are you sure you want to vent selected (${selectCubit.state.length}) members?",
                            callback: () =>
                                selectCubit.doSomethingAboutSelectedMembers(
                              context.read<GuildCubit>().deleteMember,
                            ),
                          ));
                }
              },
              tooltip: "Remove Member",
              icon: const Icon(Icons.person_remove_alt_1),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return ConfirmationPopup(
                        "Logout?",
                        callback: () => context.read<LoginBloc>().add(Logout()),
                      );
                    });
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
      );
    });
  }
}

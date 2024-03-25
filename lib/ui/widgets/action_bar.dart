import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/guild_cubit.dart';
import 'package:scf_new/blocs/selection_cubit.dart';
import 'package:scf_new/ui/common/confirm_popup.dart';

class ActionBar extends StatelessWidget {
  ActionBar({super.key});

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final selectCubit = context.read<SelectionCubit>();
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.all(6),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          const Spacer(),
          IconButton(
            onPressed: () {},
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
            // TODO: New member dialog
            onPressed: () {},
            tooltip: "Add Member",
            icon: const Icon(Icons.person_add_alt_1),
          ),
          const Spacer(),
          IconButton(
            // TODO: Remove Member. Show dialog confirmation
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
        ],
      ),
    );
  }
}

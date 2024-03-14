import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../../blocs/switch_cubit.dart';
import '../../enums.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key, this.onSelectAllTap, this.onSelectNoneTap, this.onSelectRangeTap, this.onMentionTap});

  final void Function()? onSelectAllTap;
  final void Function()? onSelectNoneTap;
  final void Function()? onSelectRangeTap;
  final void Function()? onMentionTap;
  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
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
              onPressed: () => state.mode == ManagementMode.members ? () {} : onSelectAllTap!(),
              tooltip: state.mode == ManagementMode.members ? 'Vent Member' : 'Select All',
              icon: state.mode == ManagementMode.members ? const Icon(Icons.person_remove) : const Icon(Icons.select_all),
            );
          },
        ),
        BlocBuilder<SwitchCubit, SwitchState>(
          builder: (context, state) {
            return IconButton.filled(
              onPressed: () => state.mode == ManagementMode.members ? () {} : onSelectNoneTap!(),
              tooltip: state.mode == ManagementMode.members ? 'Add Member' : 'Deselect All',
              icon: state.mode == ManagementMode.members ? const Icon(Icons.person_add) : const Icon(Icons.deselect),
            );
          },
        ),
        BlocBuilder<SwitchCubit, SwitchState>(
          builder: (context, state) => state.mode != ManagementMode.members
              ? IconButton.filled(
                  onPressed: () => state.mode == ManagementMode.members ? () {} : onSelectRangeTap!(),
                  icon: const Icon(Icons.library_add_check),
                  tooltip: "Select Range",
                )
              : Container(),
        ),
        BlocBuilder<SwitchCubit, SwitchState>(
          builder: (context, state) => state.mode != ManagementMode.members
              ? IconButton.filled(
                  onPressed: () => onMentionTap == null ? null : onMentionTap!(),
                  icon: const Icon(Icons.alternate_email),
                  tooltip: "Copy Mention Text",
                )
              : Container(),
        )
      ],
    );
  }
}

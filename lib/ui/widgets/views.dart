import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:scf_new/enums.dart';
import 'package:scf_new/ui/widgets/filter_widget.dart';
import 'package:scf_new/ui/widgets/member_details.dart';

import '../../blocs/switch_cubit.dart';
import '../../blocs/guild_bloc.dart';
import '../../models/member_model.dart';

import 'package:logging/logging.dart';

class Views extends StatefulWidget {
  const Views({super.key});

  @override
  State<Views> createState() => _ViewsState();
}

class _ViewsState extends State<Views> {
  final logger = Logger("views");
  dynamic selectedFilter;
  List<Member> selectedMembers = [];
  List<Member> filteredMembers = [];
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SwitchCubit, SwitchState>(
      listener: (context, state) => context.read<GuildBloc>().add(GuildInit(state.name)),
      child: Stack(
        children: [
          Center(
            child: BlocBuilder<GuildBloc, GuildState>(
              builder: (context, state) => state.busy ? _loading() : Container(),
            ),
          ),
          BlocBuilder<GuildBloc, GuildState>(
            builder: (context, state) {
              if (searchController.text.isEmpty && selectedFilter == null) {
                filteredMembers = state.guild.members;
              }
              return Scaffold(
                floatingActionButtonLocation: ExpandableFab.location,
                floatingActionButton: _floatingButtons(),
                body: Column(
                  children: [
                    state.busy && !state.ready ? Container() : topBar(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredMembers.length,
                        itemBuilder: (context, index) => MemberDetail(
                          member: filteredMembers[index],
                          onSelect: (selected) {
                            logger.fine("Selected ${filteredMembers[index].name}: $selected");
                            selectedMembers.contains(filteredMembers[index])
                                ? selectedMembers.add(filteredMembers[index])
                                : selectedMembers.remove(filteredMembers[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void filter() {
    if (searchController.text.isNotEmpty) {
      setState(() => filteredMembers = context
          .read<GuildBloc>()
          .state
          .guild
          .members
          .where((member) =>
              member.name.contains(searchController.text) || member.pgrId.toString().contains(searchController.text))
          .toList());
    }
    if (selectedFilter != null) {
      setState(() => filteredMembers = context
          .read<GuildBloc>()
          .state
          .guild
          .members
          .where((member) => member.siegeStatus == selectedFilter || member.mazeStatus == selectedFilter)
          .toList());
    }
  }

  Widget topBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(50, 97, 255, 215),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Filters(
        stringFilter: (value) => setState(() {
          searchController.text = value;
          filter();
        }),
        statusFilter: (value) => setState(() {
          selectedFilter = value;
          filter();
        }),
      ),
    );
  }

  // Bloc Builder below. select all/none/in-between for maze/siege. delete, and add for members

  Widget _floatingButtons() {
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
              onPressed: () {},
              tooltip: state.mode == ManagementMode.members ? 'Add Member' : 'Select All',
              icon: state.mode == ManagementMode.members
                  ? const Icon(Icons.add_photo_alternate)
                  : const Icon(Icons.select_all),
            );
          },
        ),
        BlocBuilder<SwitchCubit, SwitchState>(
          builder: (context, state) {
            return IconButton.filled(
              onPressed: () {},
              tooltip: state.mode == ManagementMode.members ? 'Vent member' : 'Deselect All',
              icon: state.mode == ManagementMode.members ? const Icon(Icons.remove) : const Icon(Icons.deselect),
            );
          },
        ),
        BlocBuilder<SwitchCubit, SwitchState>(
          builder: (context, state) => state.mode != ManagementMode.members
              ? IconButton.filled(
                  onPressed: () {},
                  icon: const Icon(Icons.library_add_check),
                  tooltip: "Select Range",
                )
              : Container(),
        )
      ],
    );
  }

  Widget _loading() => LoadingAnimationWidget.hexagonDots(color: Colors.cyanAccent, size: 40);

  Widget pStatusSelection() {
    return Container();
  }

  String get mentionText => selectedMembers.map((e) => e.discordId != null ? "<@${e.discordId ?? ''}>" : "").join('\n');
}

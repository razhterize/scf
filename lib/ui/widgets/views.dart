import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/switch_cubit.dart';
import '../../constants.dart';
import '../../enums.dart';
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
    return Column(
      children: [
        topBar(),
        Expanded(
          child: BlocBuilder<GuildBloc, GuildState>(
            builder: (context, guildState) {
              if (filteredMembers.isEmpty && searchController.text.isEmpty && selectedFilter == null) {
                filteredMembers = guildState.guild.members;
              }
              return ListView.builder(
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) => memberDetails(filteredMembers[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget memberDetails(Member member) {
    return ListTile(
      leading: Checkbox(
        onChanged: (value) {
          setState(() => selectedMembers.contains(member) ? selectedMembers.add(member) : selectedMembers.remove(member));
        },
        value: selectedMembers.contains(member),
      ),
      title: Text(member.name),
      subtitle: Text("${member.pgrId}"),
      selected: selectedMembers.contains(member),
      trailing: Wrap(
        children: context.read<SwitchCubit>().state.mode == ManagementMode.siege
            ? statusSelection(member, SiegeStatus.values)
            : statusSelection(member, MazeStatus.values),
      ),
    );
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
      child: BlocBuilder<SwitchCubit, SwitchState>(
        builder: (context, state) {
          if (state.mode == ManagementMode.siege) {
            return Row(
              children: filters(SiegeStatus.values),
            );
          } else if (state.mode == ManagementMode.maze) {
            return Row(
              children: filters(MazeStatus.values),
            );
          }
          return Container();
        },
      ),
    );
  }

  List<Widget> filters(List statuses) {
    return [
      Expanded(
        child: Row(
          children: [
            IconButton(
              onPressed: () => setState(() => searchController.clear()),
              icon: searchController.text.isEmpty ? const Icon(Icons.search) : const Icon(Icons.close),
            ),
            Expanded(
              child: BlocBuilder<GuildBloc, GuildState>(
                builder: (context, state) {
                  return TextField(
                    decoration: const InputDecoration(label: Text("Name or PGR ID"), border: InputBorder.none),
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        filteredMembers = state.guild.members
                            .where((element) =>
                                element.name.toLowerCase().contains(value.toLowerCase()) ||
                                element.pgrId.toString().contains(value))
                            .toList();
                      });
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      for (var status in statuses)
        Padding(
          padding: const EdgeInsets.all(2),
          child: MaterialButton(
            color: statusColors[status],
            onPressed: () => setState(() {
              selectedFilter != status ? selectedFilter = status : selectedFilter = null;
              logger.fine("Status: $status | Filter: $selectedFilter");
              if (SiegeStatus.values.contains(selectedFilter)) {
                filteredMembers =
                    context.read<GuildBloc>().state.guild.members.where((element) => element.siegeStatus == status).toList();
              } else if (MazeStatus.values.contains(selectedFilter)) {
                filteredMembers =
                    context.read<GuildBloc>().state.guild.members.where((element) => element.mazeStatus == status).toList();
              } else if (selectedFilter == null) {
                filteredMembers = context.read<GuildBloc>().state.guild.members;
              }
            }),
            child: Row(
              children: [
                selectedFilter == status ? const Icon(Icons.check_sharp) : Container(),
                BlocBuilder<GuildBloc, GuildState>(
                  builder: (context, state) {
                    return Text(
                      "${statusNames[status]}: ${state.guild.members.where(
                            (element) => (SiegeStatus.values.contains(status)
                                ? element.siegeStatus == status
                                : element.mazeStatus == status),
                          ).toList().length}",
                      style: const TextStyle(color: Colors.black),
                    );
                  },
                ),
              ],
            ),
          ),
        )
    ];
  }

  List<Widget> statusSelection(Member member, List statuses) {
    return [
      for (var status in statuses)
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
              label: Text(statusNames[status] ?? status.name),
              selected: member.siegeStatus == status,
              onSelected: (value) {
                if (SiegeStatus.values.contains(status)) {
                  member.siegeStatus = status;
                } else if (MazeStatus.values.contains(status)) {
                  member.mazeStatus = status;
                }
                context.read<GuildBloc>().add(UpdateMember(member));
              }),
        )
    ];
  }

  Widget pStatusSelection() {
    return Container();
  }
}

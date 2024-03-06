import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/switch_cubit.dart';
import 'package:scf_new/constants.dart';
import 'package:scf_new/enums.dart';

import '../../blocs/guild_bloc.dart';
import '../../models/member_model.dart';

class Views extends StatefulWidget {
  const Views({super.key});

  @override
  State<Views> createState() => _ViewsState();
}

class _ViewsState extends State<Views> {
  List<Member> selectedMembers = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<GuildBloc, GuildState>(
            builder: (context, state) {
              return ListView.builder(
                itemCount: state.guild.members.length,
                itemBuilder: (context, index) => memberDetails(state.guild.members[index]),
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
      trailing: lStatusSelection(member),
    );
  }

  Widget lStatusSelection(Member member) {
    return Wrap(
      children: context.read<SwitchCubit>().state.mode == ManagementMode.siege
          ? [
              for (var status in SiegeStatus.values)
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ChoiceChip(
                      label: Text(siegeStatus[status] ?? status.name),
                      selected: member.siegeStatus == status,
                      onSelected: (value) {
                        member.siegeStatus = status;
                        context.read<GuildBloc>().add(UpdateMember(member));
                      }),
                )
            ]
          : [
              for (var status in MazeStatus.values)
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ChoiceChip(
                    label: Text(mazeStatus[status] ?? status.name),
                    selected: member.mazeStatus == status,
                    onSelected: (value) {
                      member.mazeStatus = status;
                      context.read<GuildBloc>().add(UpdateMember(member));
                    },
                  ),
                ),
            ],
    );
  }

  Widget pStatusSelection() {
    return Container();
  }
}

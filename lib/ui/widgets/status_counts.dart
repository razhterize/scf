import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/guild_bloc.dart';
import 'package:scf_new/constants.dart';
import 'package:scf_new/enums.dart';

class StatusCounts extends StatelessWidget {
  const StatusCounts({super.key, required this.isSiege});

  final bool isSiege;

  @override
  Widget build(BuildContext context) {
    return isSiege
        ? BlocBuilder<GuildBloc, GuildState>(
            builder: (context, state) {
              return Row(
                children: [
                  for (var status in SiegeStatus.values)
                    MaterialButton(
                      onPressed: () {},
                      child: Text("${siegeStatus[status]}: ${state.guild.members.where((element) => element.siegeStatus == status).length}"),
                    )
                ],
              );
            },
          )
        : BlocBuilder<GuildBloc, GuildState>(
            builder: (context, state) {
              return Row(
                children: [
                  for (var status in MazeStatus.values)
                    MaterialButton(
                      onPressed: () {},
                      child: Text("${mazeStatus[status]}: ${state.guild.members.where((element) => element.mazeStatus == status).length}"),
                    )
                ],
              );
            },
          );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/filter_cubit.dart';
import 'package:scf_new/blocs/switch_cubit.dart';
import 'package:scf_new/constants.dart';
import 'package:scf_new/enums.dart';

import '../../blocs/guild_bloc.dart';

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwitchCubit, SwitchState>(
      builder: (context, state) {
        List statuses = [];
        if (state.mode == ManagementMode.siege) statuses = SiegeStatus.values;
        if (state.mode == ManagementMode.maze) statuses = MazeStatus.values;
        return Row(
          // direction: Axis.horizontal,
          children: [
            Expanded(
              child: ListTile(
                leading: BlocBuilder<FilterCubit, List>(
                  builder: (context, state) => context.read<FilterCubit>().string == ''
                      ? IconButton(onPressed: () {}, icon: const Icon(Icons.search))
                      : IconButton(
                          onPressed: () => context.read<FilterCubit>().stringFilter(''), icon: const Icon(Icons.close)),
                ),
                title: BlocBuilder<FilterCubit, List>(
                  builder: (context, state) {
                    controller.text = context.read<FilterCubit>().string;
                    return TextField(
                      decoration: const InputDecoration(
                          hintText: "Name or PGR ID",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0),
                          isDense: true),
                      controller: controller,
                      onChanged: (value) => context.read<FilterCubit>().stringFilter(value),
                    );
                  },
                ),
              ),
            ),
            for (var status in statuses) padding(statusButton(status)),
          ],
        );
      },
    );
  }

  Widget statusButton(dynamic status) {
    return MaterialButton(
      color: statusColors[status],
      onPressed: () => context.read<FilterCubit>().statusFilter(status),
      child: Row(
        children: [
          BlocBuilder<FilterCubit, List>(
              builder: (context, state) =>
                  context.read<FilterCubit>().status == status ? const Icon(Icons.check) : Container()),
          BlocBuilder<GuildBloc, GuildState>(
            builder: (context, state) => Text(
              "${statusNames[status]}: ${state.guild.members.where((element) => (SiegeStatus.values.contains(status) ? element.siegeStatus == status : element.mazeStatus == status)).toList().length}",
              style: const TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget padding(Widget child) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
        child: child,
      );
}

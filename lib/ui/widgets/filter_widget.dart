import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/filter_cubit.dart';
import '../../blocs/switch_cubit.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../blocs/guild_cubit.dart';

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final filterCubit = context.read<FilterCubit>();
    return BlocBuilder<SwitchCubit, SwitchState>(
      builder: (context, state) {
        List statuses = [];
        if (state.mode == ManagementMode.siege) statuses = SiegeStatus.values;
        if (state.mode == ManagementMode.maze) statuses = MazeStatus.values;
        return Row(
          children: [
            Expanded(
              child: ListTile(
                leading: BlocBuilder<FilterCubit, List>(
                  builder: (context, state) => filterCubit.string == ''
                      ? IconButton(
                          onPressed: () {}, icon: const Icon(Icons.search))
                      : IconButton(
                          onPressed: () => filterCubit.stringFilter(''),
                          icon: const Icon(Icons.close)),
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
                      onChanged: (value) => filterCubit.stringFilter(value),
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
    final filterCubit = context.read<FilterCubit>();
    return MaterialButton(
      color: statusColors[status],
      onPressed: () => filterCubit.statusFilter(status),
      child: Row(
        children: [
          BlocBuilder<FilterCubit, List>(
              builder: (context, state) => filterCubit.status == status
                  ? const Icon(Icons.check)
                  : Container()),
          BlocBuilder<GuildCubit, GuildState>(
            builder: (context, state) {
              int count = state.guild.members
                  .where((element) => (SiegeStatus.values.contains(status)
                      ? element.siegeStatus == status
                      : element.mazeStatus == status))
                  .toList()
                  .length;
              return Text(
                "${statusNames[status]}: $count",
                style: const TextStyle(color: Colors.black),
              );
            },
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

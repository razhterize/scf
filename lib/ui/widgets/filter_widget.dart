import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/switch_cubit.dart';
import 'package:scf_new/constants.dart';
import 'package:scf_new/enums.dart';

import '../../blocs/guild_bloc.dart';

class Filters extends StatefulWidget {
  const Filters({super.key, required this.stringFilter, required this.statusFilter});

  final void Function(String value) stringFilter;
  final void Function(dynamic value) statusFilter;

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  final textController = TextEditingController();
  dynamic selectedStatus;

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
                leading: textController.text.isEmpty
                    ? IconButton(onPressed: () {}, icon: const Icon(Icons.search))
                    : IconButton(onPressed: () => setState(() => textController.clear()), icon: const Icon(Icons.close)),
                title: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                      hintText: "Name or PGR ID",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                      isDense: true),
                  onChanged: (value) => setState(() => widget.stringFilter(value)),
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
      onPressed: () => widget.statusFilter(status),
      child: Row(
        children: [
          selectedStatus == status ? const Icon(Icons.check) : Container(),
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

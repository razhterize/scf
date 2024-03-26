import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/guild_cubit.dart';
import 'package:scf_new/blocs/switch_cubit.dart';
import 'package:scf_new/constants.dart';
import 'package:scf_new/enums.dart';
import 'package:scf_new/ui/common/animations.dart';

import '../../blocs/filter_cubit.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  bool isSearch = false;
  final searchController = TextEditingController();
  final duration = const Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          height: 40,
          duration: duration,
          margin: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: constraints.maxWidth < 700 ? _smallWidth() : _largeWidth(),
        );
      },
    );
  }

  Widget _smallWidth() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            if (isSearch) searchController.clear();
            toggle();
          },
          icon: isSearch
              ? const Icon(Icons.search)
              : const Icon(Icons.arrow_circle_down_outlined),
          tooltip: "Chage Filter Type",
        ),
        Expanded(
          child: AnimatedSwitcher(
            transitionBuilder: (child, animation) {
              return SizeTransition(
                axisAlignment: BorderSide.strokeAlignInside,
                axis: Axis.horizontal,
                sizeFactor: animation,
                child: child,
              );
            },
            duration: duration,
            child: isSearch ? searchBar() : _filterStatuses(),
          ),
        ),
      ],
    );
  }

  Widget _largeWidth() {
    final _cubit = context.read<FilterCubit>();
    return Row(
      children: [
        BlocBuilder<FilterCubit, List>(
          builder: (context, state) => IconButton(
              onPressed: () => _cubit.stringFilter(""),
              icon: _cubit.string != ""
                  ? const Icon(Icons.close)
                  : const Icon(Icons.search)),
        ),
        Expanded(child: searchBar()),
        Expanded(child: _filterStatuses()),
      ],
    );
  }

  Widget searchBar() {
    return TextField(
      decoration: const InputDecoration(
        hintText: "Name or PGR ID",
        isDense: true,
      ),
      onChanged: (value) => context.read<FilterCubit>().stringFilter(value),
      controller: searchController,
    );
  }

  Widget _filterStatuses() {
    return BlocBuilder<SwitchCubit, SwitchState>(
      builder: (context, state) {
        return SlidingFadeTransition(
          duration: duration,
          offsetBegin: const Offset(0.1, 0),
          child: ListView(
            key: ValueKey<ManagementMode>(state.mode),
            scrollDirection: Axis.horizontal,
            children: switch (state.mode) {
              ManagementMode.siege =>
                SiegeStatus.values.map((e) => statusButton(e)).toList(),
              ManagementMode.maze =>
                MazeStatus.values.map((e) => statusButton(e)).toList(),
              _ => [],
            },
          ),
        );
      },
    );
  }

  Widget statusButton(dynamic status) => MaterialButton(
        onPressed: () => context.read<FilterCubit>().statusFilter(status),
        child: Text(
          "${statusNames[status]}: ${context.read<GuildCubit>().state.guild.members.where(
                (m) => m.siegeStatus == status || m.mazeData.status == status,
              ).length}",
          style: TextStyle(color: statusColors[status]),
        ),
      );

  void toggle() => setState(() => isSearch = !isSearch);
}

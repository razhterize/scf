import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ActionBar extends StatelessWidget {
  ActionBar({super.key});

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).buttonTheme.colorScheme?.primary,
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
          IconButton(
            onPressed: () {},
            tooltip: "Select All",
            icon: const Icon(Icons.select_all_outlined),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            tooltip: "Remove All Selection",
            icon: const Icon(Icons.deselect_outlined),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            tooltip: "Select Range",
            icon: const Icon(Icons.library_add_check_outlined),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            tooltip: "Add Member",
            icon: const Icon(Icons.person_add_alt_1),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            tooltip: "Remove Member",
            icon: const Icon(Icons.person_remove_alt_1),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/switch_cubit.dart';
import 'package:scf_new/enums.dart';

import '../../blocs/login_bloc.dart';
import '../../constants.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    isLandscape ? _expanded = true : _expanded = false;
    final loginBloc = context.read<LoginBloc>();
    final switchCubit = context.read<SwitchCubit>();
    // TODO Animations on expand/collapse
    return AnimatedSize(
        onEnd: () => setState(() => _expanded = true),
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SidebarItem(
                icon: Icons.flag_rounded,
                label: "Guilds",
                isExpanded: _expanded,
                onTap: () {},
                subMenuWidgets: [
                  for (var guild in loginBloc
                      .state.authStore.model.data['managed_guilds'])
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton.icon(
                          icon: const Icon(Icons.group),
                          label: Text(guildNames[guild] ?? guild),
                          onPressed: () => switchCubit.switchGuild(guild)),
                    ),
                ],
              ),
              SidebarItem(
                icon: Icons.settings,
                label: "Mode",
                subMenuWidgets: [
                  for (var mode in ManagementMode.values)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 4, 2, 4),
                      child: ElevatedButton.icon(
                        onPressed: () => switchCubit.switchMode(mode),
                        icon: const Icon(Icons.flag),
                        label: Text(mode.name),
                      ),
                    )
                ],
                isExpanded: _expanded,
              ),
              const Spacer(),
              SidebarItem(
                icon: Icons.logout,
                label: "Logout",
                onTap: () => loginBloc.add(Logout()),
              ),
              SidebarItem(
                icon: _expanded
                    ? Icons.arrow_left_rounded
                    : Icons.arrow_right_rounded,
                label: '',
                onTap: () => _toggleExpanded(),
                isExpanded: _expanded,
              ),
            ],
          ),
        ));
  }

  bool get isLandscape =>
      MediaQuery.of(context).orientation == Orientation.landscape;
  void _toggleExpanded() => setState(() => _expanded = !_expanded);
}

class SidebarItem extends StatefulWidget {
  const SidebarItem(
      {super.key,
      required this.icon,
      required this.label,
      this.isExpanded = false,
      this.onTap,
      this.subMenuWidgets});

  final IconData icon;
  final String label;
  final bool isExpanded;
  final void Function()? onTap;
  final List<Widget>? subMenuWidgets;

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool _showSubmenu = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
              onPressed: () => switchSubmenu(),
              icon: Icon(widget.icon),
              label: Text(widget.label)),
          _showSubmenu ? subMenu() : Container(),
        ],
      ),
    );
  }

  void switchSubmenu() => setState(() => _showSubmenu = !_showSubmenu);

  Widget subMenu() {
    if (widget.subMenuWidgets == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.subMenuWidgets!,
    );
  }
}

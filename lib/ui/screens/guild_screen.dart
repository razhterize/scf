import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/login_bloc.dart';
import 'package:scf_new/blocs/switch_cubit.dart';
import 'package:scf_new/constants.dart';
import 'package:scf_new/enums.dart';
import 'package:scf_new/ui/common/animations/change_screen.dart';
import 'package:scf_new/ui/common/animations/scaled_widget.dart';
import 'package:scf_new/ui/common/member_list_view.dart';

class GuildScreen extends StatefulWidget {
  const GuildScreen({super.key});

  @override
  State<GuildScreen> createState() => _GuildScreenState();
}

class _GuildScreenState extends State<GuildScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  // final tabs = ["Siege", "Maze", "Members"];
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        tabBar(),
        Expanded(
          child: BlocBuilder<SwitchCubit, SwitchState>(
            builder: (context, state) {
              return ScreenChangeAnimation(
                child: MemberListView(
                  key: ValueKey<ManagementMode>(state.mode),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Container tabBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Container(
        height: kToolbarHeight * 0.65,
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: ManagementMode.values
              .map(
                (e) => Expanded(
                  child: BlocBuilder<SwitchCubit, SwitchState>(
                    builder: (context, state) {
                      return AnimatedContainer(
                        color: context.read<SwitchCubit>().state.mode == e
                            ? Theme.of(context).buttonTheme.colorScheme?.primary
                            : Theme.of(context).secondaryHeaderColor,
                        duration: const Duration(milliseconds: 200),
                        child: MaterialButton(
                          onPressed: () =>
                              context.read<SwitchCubit>().switchMode(e),
                          onLongPress: () {
                            showMenu(
                              context: context,
                              position: const RelativeRect.fromLTRB(0, 0, 0, 0),
                              items: showGuildSwitcher(context),
                            );
                          },
                          child: Text(e.name.toUpperCase(), style: Theme.of(context).textTheme.bodyMedium,),
                        ),
                      );
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  List<PopupMenuItem> showGuildSwitcher(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    final managedGuilds =
        loginBloc.state.authStore.model.data['managed_guilds'];
    return [
      for (var guild in managedGuilds)
        PopupMenuItem(
          child: Text(guildNames[guild] ?? guild),
          onTap: () => context.read<SwitchCubit>().switchGuild(guild),
        )
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:scf_new/ui/widgets/floating_buttons.dart';

import '../widgets/popup.dart';
import '../widgets/views.dart';
import '../../blocs/guild_bloc.dart';
import '../../blocs/login_bloc.dart';
import '../../blocs/switch_cubit.dart';
import '../../constants.dart';
import '../../enums.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final switchCubit = context.read<SwitchCubit>();
    final guildBloc = context.read<GuildBloc>();
    return Scaffold(
      appBar: _appBar(),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: const FloatingButton(),
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, loginState) {
          if (!loginState.authStore.isValid) {
            return Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.white, size: 50));
          }
          return BlocConsumer<SwitchCubit, SwitchState>(
            listener: (context, state) => guildBloc.add(GuildInit(state.name)),
            builder: (context, switchState) {
              if (!guildNames.keys.toList().contains(switchState.name)) {
                if (loginState.authStore.model.data['managed_guilds'].isEmpty) {
                  return emptyManaged();
                }
                switchCubit.switchGuild(
                    loginState.authStore.model.data['managed_guilds'].first);
              }
              return Row(
                children: [
                  sidebar(),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Views(),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget emptyManaged() {
    return Center(
      child: Column(
        children: [
          const Text(
              """Seems like you do not have permission to manage any guilds.\n
              Please contact those responsible for managing permission\n
              or login with different account"""),
          MaterialButton(
            child: const Text("Logout"),
            onPressed: () => context.read<LoginBloc>().add(Logout()),
          )
        ],
      ),
    );
  }

  Widget sidebar() {
    final switchCubit = context.read<SwitchCubit>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        child: Column(
          children: [
            IconButton(
              onPressed: () => switchCubit.switchMode(ManagementMode.siege),
              icon: const Icon(Icons.flag),
              tooltip: "Siege",
            ),
            IconButton(
              onPressed: () => switchCubit.switchMode(ManagementMode.maze),
              icon: const Icon(Icons.bed),
              tooltip: "Maze",
            ),
            IconButton(
              onPressed: () => switchCubit.switchMode(ManagementMode.members),
              icon: const Icon(Icons.group),
              tooltip: "Manage Members",
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: BlocBuilder<SwitchCubit, SwitchState>(
        builder: (context, state) => Text(guildNames[state.name] ?? state.name),
      ),
      centerTitle: true,
      leading: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(50, 0, 100, 100),
                items: [
                  for (var guild in context
                      .read<LoginBloc>()
                      .state
                      .authStore
                      .model
                      .data['managed_guilds'])
                    PopupMenuItem(
                      child: MaterialButton(
                        child: Row(
                          children: [
                            const Icon(Icons.group),
                            const Text('   '),
                            Text(guildNames[guild] ?? guild)
                          ],
                        ),
                        onPressed: () =>
                            context.read<SwitchCubit>().switchGuild(guild),
                      ),
                    ),
                  PopupMenuItem(
                    child: MaterialButton(
                      child: const Row(
                        children: [Icon(Icons.logout), Text("Logout")],
                      ),
                      onPressed: () => context.read<LoginBloc>().add(Logout()),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      actions: [
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => const Popup("Whoa my guy, you're about to vent 50 members. You sure?"),
          ),
          icon: const Icon(Icons.menu),
        )
      ],
    );
  }
}

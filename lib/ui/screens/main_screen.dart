import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    return BlocBuilder<LoginBloc, LoginState>(
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
}

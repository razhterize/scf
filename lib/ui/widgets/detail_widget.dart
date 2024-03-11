import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/enums.dart';

import '../../blocs/guild_bloc.dart';
import '../../constants.dart';
import '../../blocs/login_bloc.dart';
import '../../blocs/switch_cubit.dart';
import 'views.dart';

import 'package:logging/logging.dart';

class DetailWidget extends StatefulWidget {
  const DetailWidget({super.key});

  @override
  State<DetailWidget> createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  final logger = Logger("Detail");

  @override
  Widget build(BuildContext context) {
    if (!guildNames.keys.toList().contains(context.read<SwitchCubit>().state.name)) {
      if (context.read<LoginBloc>().state.authStore.model.data['managed_guilds'].isEmpty) {
        return Center(
          child: Column(
            children: [
              const Text(
                  "Seems like you do not have permission to manage any guilds.\nPlease contact those responsible for managing permission"),
              MaterialButton(
                child: const Text("Logout"),
                onPressed: () => context.read<LoginBloc>().add(Logout()),
              )
            ],
          ),
        );
      }
      context.read<SwitchCubit>().switchGuild(context.read<LoginBloc>().state.authStore.model.data['managed_guilds'].first);
    }
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () => context.read<SwitchCubit>().switchMode(ManagementMode.siege),
                      icon: const Icon(Icons.flag),
                      tooltip: "Siege",
                    ),
                    IconButton(
                      onPressed: () => context.read<SwitchCubit>().switchMode(ManagementMode.maze),
                      icon: const Icon(Icons.bed),
                      tooltip: "Maze",
                    ),
                    IconButton(
                      onPressed: () => context.read<SwitchCubit>().switchMode(ManagementMode.members),
                      icon: const Icon(Icons.group),
                      tooltip: "Manage Members",
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Scaffold(
                  appBar: _appBar(),
                  body: BlocProvider(
                    create: (context) => GuildBloc(context.read<LoginBloc>().pb, context.read<SwitchCubit>().state.name),
                    child: const Views(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: BlocBuilder<SwitchCubit, SwitchState>(builder: (context, state) => Text(guildNames[state.name] ?? state.name)),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {
          showMenu(
            context: context,
            position: const RelativeRect.fromLTRB(50, 0, 100, 100),
            items: [
              for (var guild in context.read<LoginBloc>().state.authStore.model.data['managed_guilds'])
                PopupMenuItem(
                  child: MaterialButton(
                    child: Row(
                      children: [const Icon(Icons.group), const Text('   '), Text(guildNames[guild] ?? guild)],
                    ),
                    onPressed: () => context.read<SwitchCubit>().switchGuild(guild),
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
      ),
    );
  }
}

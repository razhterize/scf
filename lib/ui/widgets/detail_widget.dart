import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      context.read<SwitchCubit>().switchGuild(context.read<LoginBloc>().state.authStore.model.data['managed_guilds'].first);
    }
    return Scaffold(
      appBar: _appBar(),
      body: const Views(),
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

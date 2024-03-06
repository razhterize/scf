import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../blocs/guild_bloc.dart';
import '../../blocs/login_bloc.dart';
import '../../blocs/switch_cubit.dart';

import 'views.dart';

class DetailWidget extends StatefulWidget {
  const DetailWidget({super.key});

  @override
  State<DetailWidget> createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  // late final Map<ManagementMode, Widget> views;

  @override
  void initState() {
    // views = {
    //   ManagementMode.maze: _mazeView(),
    //   ManagementMode.members: _memberManage(),
    //   ManagementMode.siege: const SiegeView(),
    // };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwitchCubit, SwitchState>(
      builder: (context, state) {
        return BlocProvider(
          create: (context) => GuildBloc(context.read<LoginBloc>().pb, state.name),
          child: Stack(
            children: [
              BlocBuilder<GuildBloc, GuildState>(builder: (context, state) => state.busy ? _loading() : Container()),
              const Expanded(child: Views()),
            ],
          ),
        );
      },
    );
  }

  Widget _loading() => LoadingAnimationWidget.twistingDots(size: 50, leftDotColor: Colors.green, rightDotColor: Colors.blue);
}

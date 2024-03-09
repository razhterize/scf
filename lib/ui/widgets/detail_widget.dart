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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuildBloc(
        context.read<LoginBloc>().pb,
        context.read<SwitchCubit>().state.name,
      ),
      child: Scaffold(
        appBar: _appBar(),
        body: Stack(
          children: [
            Center(
              child: BlocBuilder<GuildBloc, GuildState>(
                builder: (context, state) => state.busy ? _loading() : Container(),
              ),
            ),
            BlocBuilder<SwitchCubit, SwitchState>(
              builder: (context, state) => const Views(),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: BlocBuilder<GuildBloc, GuildState>(builder: (context, state) => Text(state.guild.fullName ?? state.guild.name)),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {},
      ),
    );
  }

  Widget _loading() => LoadingAnimationWidget.hexagonDots(color: Colors.cyanAccent, size: 40);
}

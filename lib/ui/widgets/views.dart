import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../blocs/guild_cubit.dart';
import '../../blocs/filter_cubit.dart';
import '../../ui/widgets/filter_widget.dart';
import '../../ui/widgets/member_details.dart';
import '../../models/member_model.dart';

import 'package:logging/logging.dart';

class Views extends StatefulWidget {
  const Views({super.key});

  @override
  State<Views> createState() => _ViewsState();
}

class _ViewsState extends State<Views> {
  final logger = Logger("views");

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BlocBuilder<GuildCubit, GuildState>(
          builder: (context, state) => state.busy ? _loading() : Container(),
        ),
        BlocBuilder<GuildCubit, GuildState>(
          builder: (context, state) => Column(
            children: [
              topBar(),
              Expanded(
                child: BlocBuilder<FilterCubit, List<Member>>(
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: state.length,
                      itemBuilder: (context, index) {
                        return MemberDetail(member: state[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget topBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(50, 97, 255, 215),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: const Filters(),
    );
  }

  Widget _loading() => LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 55);

  Widget pStatusSelection() {
    return Container();
  }
}

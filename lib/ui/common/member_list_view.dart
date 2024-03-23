import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/guild_cubit.dart';
import 'package:scf_new/ui/common/animations/sliding_fade_transition.dart';
import 'package:scf_new/ui/common/loading.dart';
import 'package:scf_new/ui/common/member_info.dart';

class MemberListView extends StatefulWidget {
  const MemberListView({super.key});

  @override
  State<MemberListView> createState() => _MemberListViewState();
}

class _MemberListViewState extends State<MemberListView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: BlocBuilder<GuildCubit, GuildState>(
            builder: (context, state) =>
                state.busy ? const LoadingIndicator() : const SizedBox(),
          ),
        ),
        BlocBuilder<GuildCubit, GuildState>(
          builder: (context, state) {
            return ListView(
              children: state.guild.members
                  .map((member) => MemberInfo(member))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

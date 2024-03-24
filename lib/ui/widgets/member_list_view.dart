import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/filter_cubit.dart';
import 'package:scf_new/blocs/guild_cubit.dart';
import 'package:scf_new/ui/common/animations.dart';
import 'package:scf_new/ui/widgets/loading.dart';
import 'package:scf_new/ui/widgets/member_info.dart';

import '../../models/member_model.dart';

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
        BlocBuilder<FilterCubit, List<Member>>(
          builder: (context, state) {
            return SlidingFadeTransition(
              child: !context.read<GuildCubit>().state.busy
                  ? ListView(
                      children: state
                          .map((member) => MemberInfo(member))
                          .toList())
                  : const SizedBox(),
            );
          },
        ),
      ],
    );
  }
}

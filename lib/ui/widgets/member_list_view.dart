import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/filter_cubit.dart';
import 'package:scf_new/blocs/guild_cubit.dart';
import 'package:scf_new/ui/common/animations.dart';
import 'package:scf_new/ui/widgets/loading.dart';
import 'package:scf_new/ui/widgets/member_card.dart';

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
              offsetBegin: const Offset(0.5, 0),
              child: !context.read<GuildCubit>().state.busy
                  ? ListView(
                    key: ValueKey<int>(state.length),
                      children: [
                        for (var member in state) MemberCard(member)
                      ],
                    )
                  : const SizedBox(),
            );
          },
        ),
      ],
    );
  }
}

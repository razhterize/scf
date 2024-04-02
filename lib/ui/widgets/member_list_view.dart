import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/filter_cubit.dart';
import 'package:scf_new/blocs/guild_cubit.dart';
import 'package:scf_new/blocs/login_bloc.dart';
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
            builder: (_, state) =>
                state.busy && context.read<LoginBloc>().state.authStore.isValid
                    ? const LoadingIndicator()
                    : const SizedBox(),
          ),
        ),
        BlocBuilder<GuildCubit, GuildState>(
          builder: (_, guildState) {
            return BlocBuilder<FilterCubit, List>(
              builder: (_, filterState) {
                return SlidingFadeTransition(
                  duration: const Duration(milliseconds: 400),
                  offsetBegin: const Offset(0.1, 0),
                  child: !guildState.busy
                      ? ListView(
                          key: ValueKey<int>(filterState.length),
                          children:
                              filterState.map((e) => MemberCard(e)).toList(),
                        )
                      : const SizedBox(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

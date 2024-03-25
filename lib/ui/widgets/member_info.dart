import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/guild_cubit.dart';
import 'package:scf_new/blocs/selection_cubit.dart';
import 'package:scf_new/ui/widgets/member_status_selection.dart';

import '../../models/member_model.dart';
import 'member_edit.dart';

class MemberInfo extends StatelessWidget {
  const MemberInfo(this.member, {super.key});

  final Member member;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, List>(
      builder: (context, state) {
        return ListTile(
          selected: context.read<SelectionCubit>().isSelected(member),
          title: Text(
            member.name,
            maxLines: 2,
          ),
          selectedColor: Theme.of(context).textSelectionTheme.cursorColor,
          subtitle: Text(member.pgrId.toString()),
          onTap: () => context.read<SelectionCubit>().changeSelect(member),
          onLongPress: () {
            showBottomSheet(
              context: context,
              builder: (_) {
                return BlocProvider.value(
                  value: context.read<GuildCubit>(),
                  child: MemberEdit(member: member),
                );
              },
            );
          },
          leading: BlocBuilder<SelectionCubit, List<Member>>(
            builder: (context, state) {
              return Checkbox(
                value: context.read<SelectionCubit>().isSelected(member),
                onChanged: (_) =>
                    context.read<SelectionCubit>().changeSelect(member),
              );
            },
          ),
          trailing: MemberStatusSelection(member),
        );
      },
    );
  }
}

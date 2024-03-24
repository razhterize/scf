import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/selection_cubit.dart';
import 'package:scf_new/blocs/switch_cubit.dart';
import 'package:scf_new/constants.dart';
import 'package:scf_new/enums.dart';
import 'package:scf_new/ui/widgets/member_status_selection.dart';

import '../../models/member_model.dart';
import '../common/animations.dart';

class MemberInfo extends StatelessWidget {
  const MemberInfo(this.member, {super.key});

  final Member member;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, List>(
      builder: (context, state) {
        return ListTile(
          selected: context.read<SelectionCubit>().isSelected(member),
          title: Text(member.name),
          selectedColor: Colors.orangeAccent,
          // tileColor: statusColors[member.siegeStatus],
          subtitle: Text(member.pgrId.toString()),
          onTap: () => context.read<SelectionCubit>().changeSelect(member),
          leading: BlocBuilder<SelectionCubit, List<Member>>(
            builder: (context, state) {
              return Checkbox(
                value: context.read<SelectionCubit>().isSelected(member),
                onChanged: (_) =>
                    context.read<SelectionCubit>().changeSelect(member),
              );
            },
          ),
          // TODO: think of something to change this trailing with each different SwitchState
          trailing: MemberStatusSelection(member),
        );
      },
    );
  }
}

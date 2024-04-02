import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/login_bloc.dart';
import 'package:scf_new/blocs/switch_cubit.dart';
import 'package:scf_new/constants.dart';
import 'package:scf_new/enums.dart';
import 'package:scf_new/ui/widgets/filter_bar.dart';
import 'package:scf_new/ui/widgets/member_list_view.dart';

import 'package:logging/logging.dart';

final logger = Logger("GuildScreen");

class GuildScreen extends StatefulWidget {
  const GuildScreen({super.key});

  @override
  State<GuildScreen> createState() => _GuildScreenState();
}

class _GuildScreenState extends State<GuildScreen>
    with SingleTickerProviderStateMixin {
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      // direction: constraints.maxWidth < 720 ? Axis.vertical : Axis.horizontal,
      children: [
        tabBar(),
        const FilterBar(),
        const Expanded(
          child: MemberListView(),
        ),
      ],
    );
  }

  Container tabBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Container(
        height: kToolbarHeight * 0.65,
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
        child: Row(
          children: [
            ...ManagementMode.values
                .map((e) => modeButtonContainer(e, child: modeButton(e))),
            guildSwitcher(),
          ],
        ),
      ),
    );
  }

  Widget guildSwitcher() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
        child: BlocBuilder<SwitchCubit, SwitchState>(
          builder: (_, state) {
            return DropdownButton<String>(
              alignment: Alignment.center,
              value: state.name,
              isDense: true,
              items: [
                for (var guild in context.read<LoginBloc>().state.managedGuilds)
                  DropdownMenuItem<String>(
                    value: guild,
                    child: Text(guildNames[guild] ?? guild),
                  ),
              ],
              onChanged: (value) =>
                  context.read<SwitchCubit>().switchGuild(value ?? ""),
            );
          },
        ),
      ),
    );
  }

  Widget modeButtonContainer(ManagementMode mode, {required Widget child}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
        child: BlocBuilder<SwitchCubit, SwitchState>(
          builder: (context, state) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 750),
              decoration: BoxDecoration(
                color: context.read<SwitchCubit>().state.mode == mode
                    ? Theme.of(context)
                        .buttonTheme
                        .colorScheme
                        ?.primaryContainer
                    : Theme.of(context).splashColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: child,
            );
          },
        ),
      ),
    );
  }

  Widget modeButton(ManagementMode mode) {
    return MaterialButton(
      padding: const EdgeInsets.all(2),
      onPressed: () => context.read<SwitchCubit>().switchMode(mode),
      child: Text(
        mode.name.toUpperCase(),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

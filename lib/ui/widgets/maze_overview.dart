import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_management/models/guild.dart';
import 'package:scf_management/blocs/guild_bloc.dart';
import 'package:scf_management/blocs/login_cubit.dart';
import 'package:scf_management/blocs/settings_bloc.dart';
import 'package:scf_management/ui/screens/maze_detail_screen.dart';
import 'package:scf_management/ui/widgets/maze_chart.dart';

class MazeOverview extends StatefulWidget {
  const MazeOverview({super.key, required this.guild, required this.pb});

  final Guild guild;
  final PocketBase pb;

  @override
  State<MazeOverview> createState() => _MazeOverviewState();
}

class _MazeOverviewState extends State<MazeOverview> {
  late final Guild guild;
  @override
  void initState() {
    guild = widget.guild;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              guild.fullName,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: BlocProvider.of<GuildBloc>(context)),
                        BlocProvider.value(value: BlocProvider.of<LoginCubit>(context)),
                        BlocProvider.value(value: BlocProvider.of<SettingBloc>(context)),
                      ],
                      child: const MazeDetails(),
                      // child: GuildDetails(guild: guild, pb: widget.pb),
                    ),
                  ),
                );
              },
              child: AbsorbPointer(
                child: guild.members.isNotEmpty
                    ? BlocBuilder<GuildBloc, GuildState>(
                        builder: (context, state) {
                          if (state.guild.members.isEmpty) {
                            return _emptyMembers();
                          }
                          return _membersChart();
                        },
                      )
                    : _emptyMembers(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _membersChart() {
    return Hero(
      tag: guild.name,
      child: const MazeClearChart(),
    );
  }

  Widget _emptyMembers() {
    return Icon(
      Icons.warning_amber,
      color: Colors.red,
      size: MediaQuery.of(context).size.width / 8,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_management/models/guild.dart';
import 'package:scf_management/providers/screen_bloc.dart';
import 'package:scf_management/ui/widgets/members_chart.dart';

class GuildOverview extends StatefulWidget {
  const GuildOverview({super.key, required this.guild});

  final Guild guild;

  @override
  State<GuildOverview> createState() => _GuildOverviewState();
}

class _GuildOverviewState extends State<GuildOverview> {
  late final Guild guild;
  @override
  void initState() {
    guild = widget.guild;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: BlocBuilder<ScreenBloc, ScreenState>(
          builder: (context, state) {
            return InkWell(
              onTap: () {
                BlocProvider.of<ScreenBloc>(context).add(ShowGuildDetails(guild: guild));
              },
              child: guild.members.isNotEmpty ? _membersChart() : _emptyMembers(),
            );
          },
        ),
      ),
    );
  }

  Widget _membersChart() {
    return Expanded(
      child: MembersChart(members: guild.members, name: guild.fullName),
    );
  }

  Widget _emptyMembers() {
    return Expanded(
      child: Icon(
        Icons.warning_amber,
        color: Colors.red,
        size: MediaQuery.of(context).size.width / 8,
      ),
    );
  }
}

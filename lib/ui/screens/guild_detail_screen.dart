import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_management/models/guild.dart';
import 'package:scf_management/providers/screen_bloc.dart';
import 'package:scf_management/ui/widgets/members_chart.dart';

class GuildDetails extends StatefulWidget {
  const GuildDetails({super.key, required this.guild});

  final Guild guild;

  @override
  State<GuildDetails> createState() => _GuildDetailsState();
}

class _GuildDetailsState extends State<GuildDetails> {
  late Guild guild;

  @override
  void initState() {
    guild = widget.guild;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        guild.members.isNotEmpty ? memberChart() : emptyMember(),
        BlocBuilder<ScreenBloc, ScreenState>(
          builder: (context, state) {
            return MaterialButton(
              onPressed: () => BlocProvider.of<ScreenBloc>(context).add(ShowOverview()),
              child: const Text("Back"),
            );
          },
        ),
      ],
    );
  }

  Hero memberChart() => Hero(tag: guild.name, child: MembersChart(members: guild.members, name: guild.fullName));
  Widget emptyMember() {
    return Center(
      child: Icon(Icons.warning_amber, color: Colors.red, size: MediaQuery.of(context).size.width / 8),
    );
  }
}

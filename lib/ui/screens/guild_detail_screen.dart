import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scf_management/constants/abbreviations.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:scf_management/models/guild.dart';
import 'package:scf_management/models/member.dart';
import 'package:scf_management/ui/widgets/members_chart.dart';
import 'package:toggle_switch/toggle_switch.dart';

class GuildDetails extends StatefulWidget {
  const GuildDetails({super.key, required this.guild});

  final Guild guild;

  @override
  State<GuildDetails> createState() => _GuildDetailsState();
}

class _GuildDetailsState extends State<GuildDetails> {
  late Guild guild;
  List<Member> selectedMembers = [];

  @override
  void initState() {
    guild = widget.guild;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: guild.members.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return memberChart();
        return memberInfo(guild.members[index - 1]);
      },
    );
  }

  Widget memberInfo(Member member) {
    return ListTile(
      leading: Checkbox(
        value: member.selected,
        onChanged: (value) {
          setState(() {
            member.selected = value!;
          });
        },
      ),
      // selected: true,
      onTap: () => editMemberDialog(member),
      title: Text(member.name!),
      subtitle: Text("${member.pgrId}"),
      trailing: ToggleSwitch(
        animate: true,
        animationDuration: 200,
        initialLabelIndex: Random().nextInt(4),
        changeOnTap: true,
        labels: [for (var status in SiegeStatus.values) siegeStatus[status] ?? ""],
        activeFgColor: Colors.blue,
      ),
    );
  }

  Widget memberChart() => MembersChart(members: guild.members, name: guild.fullName);
  Widget emptyMember() => Center(
        child: Icon(
          Icons.warning_amber,
          color: Colors.red,
          size: MediaQuery.of(context).size.width / 8,
        ),
      );

  void editMemberDialog(Member member) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            Form(
              child: TextFormField(),
            )
          ],
        );
      },
    );
  }
}

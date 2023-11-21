// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_management/constants/abbreviations.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:scf_management/constants/theme.dart';
import 'package:scf_management/models/guild.dart';
import 'package:scf_management/models/member.dart';
import 'package:scf_management/providers/guild_bloc.dart';
import 'package:scf_management/providers/settings_bloc.dart';
import 'package:scf_management/ui/widgets/member_detail.dart';
import 'package:scf_management/ui/widgets/guild_chart.dart';

class GuildDetails extends StatefulWidget {
  const GuildDetails({super.key, required this.guild, required this.pb});

  final Guild guild;
  final PocketBase pb;

  @override
  State<GuildDetails> createState() => _GuildDetailsState();
}

class _GuildDetailsState extends State<GuildDetails> {
  late Guild guild;
  List<Member> selectedMembers = [];

  final statusKey = GlobalKey();

  final TextEditingController searchController = TextEditingController();
  SiegeStatus? statusFilter;

  @override
  void initState() {
    guild = widget.guild;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO Update new member state everytime member info changed, or new member updated
    return BlocBuilder<GuildBloc, GuildState>(
      builder: (context, state) {
        if (state.status == GuildStatus.ready) {
          return Scaffold(
            appBar: appBar(),
            floatingActionButton: floatingActionButton(),
            body: Flex(
              direction: MediaQuery.of(context).orientation == Orientation.portrait ? Axis.vertical : Axis.horizontal,
              children: [
                Center(child: memberChart()),
                const Divider(),
                Expanded(
                  child: Column(
                    children: [
                      memberFilter(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.filteredMembers.length,
                          itemBuilder: (context, index) {
                            return memberInfo(state.filteredMembers[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return LoadingAnimationWidget.dotsTriangle(color: Colors.white, size: 50);
      },
    );
  }

  Widget memberFilter() {
    return ListTile(
      leading: searchController.text.isEmpty
          ? const Icon(Icons.search)
          : IconButton(
              onPressed: () {
                setState(() {
                  searchController.clear();
                });
                BlocProvider.of<GuildBloc>(context)
                    .add(FilterMember(searchValue: searchController.text, siegeStatus: statusFilter));
              },
              icon: const Icon(Icons.close_rounded)),
      title: TextField(
        decoration: const InputDecoration(label: Text("Member Name or ID"), border: InputBorder.none),
        controller: searchController,
        onChanged: (value) {
          BlocProvider.of<GuildBloc>(context)
              .add(FilterMember(searchValue: searchController.text, siegeStatus: statusFilter));
        },
      ),
      trailing: DropdownButton(
        hint: const Text("Clear Status"),
        value: statusFilter,
        items: [
          const DropdownMenuItem(
            value: null,
            child: Text("Show all"),
          ),
          for (var status in SiegeStatus.values) DropdownMenuItem(value: status, child: Text(siegeStatus[status]!)),
        ],
        onChanged: (value) {
          statusFilter = value;
          BlocProvider.of<GuildBloc>(context)
              .add(FilterMember(searchValue: searchController.text, siegeStatus: statusFilter));
        },
      ),
    );
  }

  Widget? floatingActionButton() {
    var _members = BlocProvider.of<GuildBloc>(context).state.guild?.members;
    if (_members!.where((member) => member.selected).toList().isEmpty) {
      return null;
    }
    return FloatingActionButton.extended(
      onPressed: () {
        String mentionText = "";
        for (var member in _members.where((member) => member.selected == true)) {
          if (member.discordId != "" && member.discordId != "-" && member.discordId != null) {
            mentionText += "<@${member.discordId}>\n";
          } else if (member.discordUsername != "" && member.discordUsername != null) {
            mentionText += "@${member.discordUsername}\n";
          } else {
            mentionText += "@${member.name}\n";
          }
        }
        Clipboard.setData(ClipboardData(text: mentionText));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Selected members mention copied")));
      },
      icon: const Icon(Icons.alternate_email),
      label: const Text("Mention"),
    );
  }

  AppBar appBar() => AppBar(
        title: Text(guild.fullName),
        actions: [
          IconButton(
            // add new member
            tooltip: "Add New Member",
            onPressed: () {
              newMemberDialog();
            },
            icon: const Icon(Icons.add),
          ),
          BlocBuilder<GuildBloc, GuildState>(
            builder: (context, state) {
              return IconButton(
                tooltip: "Delete Selected Members",
                // delete member on press
                onPressed: () async {
                  // do something fancy to delete selected member
                  // var _selectedMembers = state.guild!.members.where((member) => member.selected == true);
                  for (var member in state.guild!.members.where((member) => member.selected == true).toList()) {
                    await widget.pb.collection("members").delete(member.id);
                    setState(() {
                      state.guild?.members.remove(member);
                    });
                    BlocProvider.of<GuildBloc>(context)
                        .add(FilterMember(searchValue: searchController.text, siegeStatus: statusFilter));
                  }
                },
                icon: const Icon(Icons.delete),
              );
            },
          ),
          IconButton(
            tooltip: "Select All",
            onPressed: () {
              // select all filtered members
              setState(() {
                for (var member in BlocProvider.of<GuildBloc>(context).state.filteredMembers) {
                  member.selected = true;
                }
              });
            },
            icon: const Icon(Icons.check_box),
          ),
          IconButton(
            tooltip: "Unselect All",
            onPressed: () {
              // deselect all filtered members
              setState(() {
                for (var member in BlocProvider.of<GuildBloc>(context).state.filteredMembers) {
                  member.selected = false;
                }
              });
              BlocProvider.of<GuildBloc>(context)
                  .add(FilterMember(searchValue: searchController.text, siegeStatus: statusFilter));
            },
            icon: const Icon(Icons.check_box_outline_blank),
          )
        ],
      );

  Widget guildInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Row(children: [
            const Text("Minimum Score"),
            Text("${guild.minScore}"),
          ]),
        ),
        Expanded(
          child: Row(children: [
            const Text("Member Count"),
            Text("${guild.members.length}"),
          ]),
        )
      ],
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
      selected: member.selected,
      onTap: () => editMemberDialog(member),
      title: Text(member.name!),
      subtitle: Text("${member.pgrId}"),
      trailing: statusSelection(member),
    );
  }

  Widget statusSelection(Member member) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return DropdownMenu(
        initialSelection: member.siege?.status,
        controller: TextEditingController(text: siegeStatus[member.siege?.status]),
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            return darkChartColor[member.siege?.status];
          }),
        ),
        dropdownMenuEntries: [
          for (var status in SiegeStatus.values)
            DropdownMenuEntry(
              value: status,
              label: siegeStatus[status]!,
            )
        ],
        onSelected: (value) {
          setState(() {
            member.siege?.status = value;
            member.update(widget.pb);
          });
          BlocProvider.of<GuildBloc>(context)
              .add(FilterMember(searchValue: searchController.text, siegeStatus: statusFilter));
        },
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 5,
        children: [
          for (var status in SiegeStatus.values)
            ChoiceChip(
              visualDensity: VisualDensity.compact,
              label: Text(
                siegeStatus[status]!,
                style: TextStyle(
                  color: BlocProvider.of<SettingBloc>(context).state.lightMode
                      ? member.siege?.status == status
                          ? Colors.white
                          : Colors.black
                      : member.siege?.status == status
                          ? Colors.black
                          : Colors.white,
                ),
              ),
              selected: (member.siege?.status == status),
              selectedColor: darkChartColor[status],
              onSelected: (value) {
                BlocProvider.of<GuildBloc>(context)
                    .add(FilterMember(searchValue: searchController.text, siegeStatus: statusFilter));
                setState(() {
                  member.siege?.status = status;
                  member.update(widget.pb);
                });
              },
            )
        ],
      ),
    );
  }

  Widget memberChart() => Hero(
        tag: guild.name,
        child: GuildClearChart(members: guild.members, name: guild.fullName),
      );
  Widget emptyMember() => Center(
        child: Icon(
          Icons.warning_amber,
          color: Colors.red,
          size: MediaQuery.of(context).size.width / 8,
        ),
      );

  void editMemberDialog(Member member) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return MemberDetails(member: member);
      },
    );
  }

  void newMemberDialog() {
    // TODO Known Issue: Member does not automatically updated after adding new one
    final nameController = TextEditingController();
    final pgrIdController = TextEditingController();
    final discIdController = TextEditingController();
    final discUsernameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    validate() async {
      if (formKey.currentState!.validate()) {
        var data = {
          "name": nameController.text,
          "pgr_id": int.tryParse(pgrIdController.text),
          "discord_username": discUsernameController.text,
          "discord_id": discIdController.text,
          "guild": guild.name,
          "siege": {"status": "noScore", "current_score": 0, "past_scores": []},
          "maze": {
            "energy_overcap": [
              [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            ],
            "energy_used": [0, 0, 0],
            "energy_wrong_node": [
              [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            ],
            "total_points": [0, 0, 0]
          }
        };
        await widget.pb.collection("members").create(body: data).then((newMember) async {
          var _guild = await widget.pb.collection("guilds").getList(filter: "name = '${guild.name}'");
          if (_guild.items.isNotEmpty) {
            await widget.pb.collection("guilds").update(_guild.items.first.id, body: {"members+": newMember.id});
          }
        }).then((value) {
          BlocProvider.of<GuildBloc>(context).add(FetchGuild());
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New member ${nameController.text} has been added")));
        });
        Navigator.pop(context);
        BlocProvider.of<GuildBloc>(context).add(FilterMember(searchValue: searchController.text, siegeStatus: statusFilter));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Something went wrong, or you entered invalid data, either way, it didn't success")));
      }
    }

    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(label: Text("Name")),
                      controller: nameController,
                      onFieldSubmitted: (value) {
                        validate();
                      },
                      validator: (value) {
                        if (value == null || value == "") return "Name cannot be empty";
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(label: Text("PGR ID")),
                      controller: pgrIdController,
                      onFieldSubmitted: (value) {
                        validate();
                      },
                      validator: (value) {
                        if (value!.length != 8) return "PGR ID must be 8 digits long";
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(label: Text("Discord Username")),
                      controller: discUsernameController,
                      onFieldSubmitted: (value) {
                        validate();
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(label: Text("Discord ID")),
                      controller: discIdController,
                      onFieldSubmitted: (value) {
                        validate();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () async {
                        await validate();
                        Navigator.pop(context);
                      },
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

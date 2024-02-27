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
import 'package:scf_management/blocs/guild_bloc.dart';
import 'package:scf_management/blocs/selected_bloc.dart';
import 'package:scf_management/blocs/settings_bloc.dart';
import 'package:scf_management/ui/widgets/chart.dart';
import 'package:scf_management/ui/widgets/member_detail.dart';
import 'package:scf_management/ui/widgets/new_member_dialog.dart';

class GuildDetails extends StatefulWidget {
  const GuildDetails({super.key, required this.guild, required this.pb});

  final Guild guild;
  final PocketBase pb;

  @override
  State<GuildDetails> createState() => _GuildDetailsState();
}

class _GuildDetailsState extends State<GuildDetails> {
  late Guild guild;
  // List<Member> selectedMembers = [];

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
    return BlocBuilder<GuildBloc, GuildState>(
      builder: (context, state) {
        if (state.status == GuildStatus.ready) {
          return BlocProvider(
            create: (context) => SelectBloc(guild: state.guild),
            child: Scaffold(
              appBar: appBar(),
              floatingActionButton: BlocBuilder<SelectBloc, SelectState>(
                builder: (context, state) {
                  if (state.selectedMembers.isNotEmpty) {
                    return FloatingActionButton.extended(
                      onPressed: () {
                        // Selected Bloc here, mentioned text copied on cliek
                        if (state.selectedMembers.isNotEmpty) {
                          String mentionText = "";
                          for (var member in state.selectedMembers) {
                            if (member.discordId != "" && member.discordId != "-" && member.discordId != null) {
                              mentionText += "<@${member.discordId}>\n";
                            } else if (member.discordUsername != "" && member.discordUsername != null) {
                              mentionText += "@${member.discordUsername}\n";
                            } else {
                              mentionText += "@${member.name}\n";
                            }
                          }
                          Clipboard.setData(ClipboardData(text: mentionText));
                          if (mentionText != "") {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Mention text has been copied to clipboard"),
                              duration: Duration(seconds: 2),
                            ));
                          }
                        }
                      },
                      icon: const Icon(Icons.alternate_email),
                      label: const Text("Mention"),
                    );
                  }
                  return Container();
                },
              ),
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
                BlocProvider.of<GuildBloc>(context).add(FilterMember(searchValue: searchController.text, siegeStatus: statusFilter));
              },
              icon: const Icon(Icons.close_rounded)),
      title: TextField(
        decoration: const InputDecoration(label: Text("Member Name or ID"), border: InputBorder.none),
        controller: searchController,
        onChanged: (value) {
          BlocProvider.of<GuildBloc>(context).add(FilterMember(searchValue: searchController.text, siegeStatus: statusFilter));
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
          BlocProvider.of<GuildBloc>(context).add(FilterMember(searchValue: searchController.text, siegeStatus: statusFilter));
        },
      ),
    );
  }

  AppBar appBar() => AppBar(
        title: Text(guild.fullName),
        actions: [
          IconButton(
            // add new member
            tooltip: "Add New Member",
            onPressed: () => showModalBottomSheet(isScrollControlled: true, useSafeArea: true, context: context, builder: (_) => const NewMemberDialog()),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            tooltip: "Delete Selected Members",
            // delete member on press
            onPressed: () async {
              // [Done] Replace all these shit with `Selected Bloc`
              var selectedMembers = BlocProvider.of<SelectBloc>(context).state.selectedMembers.toList();
              for (var member in selectedMembers) {
                BlocProvider.of<GuildBloc>(context).add(DeleteMember(member));
              }
            },
            icon: const Icon(Icons.delete),
          ),
          BlocBuilder<SelectBloc, SelectState>(
            builder: (context, state) {
              if (!state.selectAll) {
                return IconButton(
                  tooltip: "Select All",
                  onPressed: () => BlocProvider.of<SelectBloc>(context).add(SelectAll()),
                  icon: const Icon(Icons.check_box),
                );
              }
              return IconButton(
                tooltip: "Unselect All",
                // SelectedBloc DeselectAll event
                onPressed: () => BlocProvider.of<SelectBloc>(context).add(DeselectAll()),
                icon: const Icon(Icons.check_box_outline_blank),
              );
            },
          ),
          BlocBuilder<SelectBloc, SelectState>(
            builder: (context, state) {
              if (state.selectedMembers.isNotEmpty) {
                return IconButton(
                  onPressed: () => state.selectedMembers.length >= 2
                      ? BlocProvider.of<SelectBloc>(context).add(SelectRange(state.selectedMembers.first, state.selectedMembers.last))
                      : BlocProvider.of<SelectBloc>(context).add(SelectRange(BlocProvider.of<GuildBloc>(context).state.guild.members.last, state.selectedMembers.last)),
                  icon: const Icon(Icons.unfold_less),
                  tooltip: "Select in-between",
                );
              }
              return Container();
            },
          ),
          BlocBuilder<SelectBloc, SelectState>(
            builder: (context, state) {
              if (state.selectedMembers.isNotEmpty) {
                return IconButton(
                  onPressed: () => BlocProvider.of<SelectBloc>(context).add(InvertSelection()),
                  icon: state.inverted ? const Icon(Icons.library_add_check) : const Icon(Icons.library_add_check_outlined),
                  tooltip: "Invert Selection",
                );
              }
              return Container();
            },
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
    return BlocBuilder<SelectBloc, SelectState>(
      builder: (context, state) {
        return ListTile(
          leading: Checkbox(
            value: state.selectedMembers.contains(member),
            onChanged: (value) {
              if (state.selectedMembers.contains(member)) {
                BlocProvider.of<SelectBloc>(context).add(RemoveSelected(member));
              } else {
                BlocProvider.of<SelectBloc>(context).add(AddSelected(member));
              }
            },
          ),
          selected: state.selectedMembers.contains(member),
          onTap: () => editMemberDialog(member),
          title: Text(member.name!),
          subtitle: Text("${member.pgrId}"),
          trailing: statusSelection(member),
        );
      },
    );
  }

  Widget statusSelection(Member member) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: siegeChartColor[member.siege!.status],
            // border: Border.all()
          ),
          // color: darkChartColor[member.siege!.status],
          child: DropdownButton(
            value: member.siege!.status,
            // initialSelection: member.siege?.status,
            // controller: TextEditingController(text: siegeStatus[member.siege?.status]),
            items: [
              for (var status in SiegeStatus.values)
                DropdownMenuItem(
                  value: status,
                  child: Text(
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
                )
            ],
            onChanged: (value) async {
              var selectedMembers = BlocProvider.of<SelectBloc>(context).state.selectedMembers.toList();
              if (selectedMembers.isNotEmpty && selectedMembers.length >= 2) {
                BlocProvider.of<GuildBloc>(context).add(BatchSiegeStatus(selectedMembers, value!));
                BlocProvider.of<GuildBloc>(context).add(FilterMember(siegeStatus: statusFilter));
                return;
              }
              member.siege?.status = value!;
              BlocProvider.of<GuildBloc>(context).add(UpdateMember(member));
            },
          ),
        ),
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: BlocBuilder<SelectBloc, SelectState>(
        builder: (context, state) {
          return Wrap(
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
                  selectedColor: siegeChartColor[status],
                  onSelected: (value) async {
                    var selectedMembers = BlocProvider.of<SelectBloc>(context).state.selectedMembers.toList();
                    if (selectedMembers.isNotEmpty && selectedMembers.length >= 2) {
                      BlocProvider.of<GuildBloc>(context).add(BatchSiegeStatus(selectedMembers, status));
                      BlocProvider.of<GuildBloc>(context).add(FilterMember(siegeStatus: statusFilter));
                      return;
                    }
                    member.siege?.status = status;
                    BlocProvider.of<GuildBloc>(context).add(UpdateMember(member));
                  },
                )
            ],
          );
        },
      ),
    );
  }

  Widget memberChart() => const Chart(type: ChartType.siege);
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
      builder: (_) {
        // return MemberDetails(member: member);
        return BlocProvider.value(
          value: BlocProvider.of<GuildBloc>(context),
          child: MemberDetails(member: member),
        );
      },
    ).whenComplete(() {
      BlocProvider.of<GuildBloc>(context).add(FilterMember(searchValue: searchController.text, siegeStatus: statusFilter));
    });
  }
}

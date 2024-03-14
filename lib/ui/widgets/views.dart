import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../enums.dart';
import '../../ui/widgets/filter_widget.dart';
import '../../ui/widgets/floating_buttons.dart';
import '../../ui/widgets/member_details.dart';
import '../../blocs/switch_cubit.dart';
import '../../blocs/guild_bloc.dart';
import '../../models/member_model.dart';

import 'package:logging/logging.dart';

class Views extends StatefulWidget {
  const Views({super.key});

  @override
  State<Views> createState() => _ViewsState();
}

class _ViewsState extends State<Views> {
  final logger = Logger("views");
  dynamic selectedFilter;
  List<Member> selectedMembers = [];
  List<Member> filteredMembers = [];
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SwitchCubit, SwitchState>(
      listener: (context, state) => context.read<GuildBloc>().add(GuildInit(state.name)),
      child: Stack(
        children: [
          Center(
            child: BlocBuilder<GuildBloc, GuildState>(
              builder: (context, state) => state.busy ? _loading() : Container(),
            ),
          ),
          BlocBuilder<GuildBloc, GuildState>(
            builder: (context, state) {
              if (searchController.text.isEmpty && selectedFilter == null) {
                filteredMembers = state.guild.members;
              }
              return Scaffold(
                floatingActionButtonLocation: ExpandableFab.location,
                floatingActionButton: FloatingButton(
                  onSelectAllTap: () => setState(() => selectedMembers = filteredMembers),
                  onSelectNoneTap: () => setState(() => selectedMembers = []),
                  onSelectRangeTap: () => setState(() => selectRange()),
                  onMentionTap: () {
                    Clipboard.setData(ClipboardData(text: mentionText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Members mention has been copied to clipboard")),
                    );
                  },
                ),
                body: Column(
                  children: [
                    state.busy && !state.ready ? Container() : topBar(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredMembers.length,
                        itemBuilder: (context, index) => MemberDetail(
                          member: filteredMembers[index],
                          selectedMembers: selectedMembers,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void selectRange() {
    int _first = filteredMembers.indexWhere((element) => element == selectedMembers.first);
    int _last = filteredMembers.indexWhere((element) => element == selectedMembers.last);
    selectedMembers = filteredMembers.getRange(_first, _last + 1).toList();
  }

  void filter() {
    if (searchController.text.isNotEmpty) {
      setState(() {
        var members = context.read<GuildBloc>().state.guild.members;
        filteredMembers = members.where((member) => containStringFilter(member)).toList();
      });
    }
    if (selectedFilter != null) {
      setState(() {
        var members = context.read<GuildBloc>().state.guild.members;
        filteredMembers = members.where((member) => hasStatusFilter(member)).toList();
      });
    }
  }

  Widget topBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(50, 97, 255, 215),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Filters(
        stringFilter: (value) => setState(() {
          searchController.text = value;
          filter();
        }),
        statusFilter: (value) => setState(() {
          selectedFilter = value;
          logger.fine("Status Filter is $value");
          filter();
        }),
      ),
    );
  }

  Widget _loading() => LoadingAnimationWidget.hexagonDots(color: Colors.cyanAccent, size: 40);

  Widget pStatusSelection() {
    return Container();
  }

  bool containStringFilter(Member member) =>
      member.name.contains(searchController.text) || member.pgrId.toString().contains(searchController.text);
  bool hasStatusFilter(Member member) => member.siegeStatus == selectedFilter || member.mazeStatus == selectedFilter;

  String get mentionText => selectedMembers.map((e) => e.discordId != "" ? "<@${e.discordId}>" : null).join('\n');
}

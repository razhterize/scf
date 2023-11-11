import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:scf_management/models/guild.dart';
import 'package:scf_management/models/member.dart';

enum GuildStatus { ready, notReady, error }

class GuildBloc extends Bloc<GuildEvent, GuildState> {
  GuildBloc({required this.pb, required this.name}) : super(const GuildState()) {
    on<FetchGuild>(_fetchGuild);
    on<FilterMember>(_filterMembers);
  }

  Future<void> _fetchGuild(FetchGuild event, Emitter<GuildState> emit) async {
    if (state.status == GuildStatus.ready) return;
    try {
      var guilds = await pb.collection('guilds').getList(filter: "name = '$name'", expand: "members");
      // TODO only subsribe to members in a guild, otherwise index error
      if (guilds.items.isNotEmpty) {
        var guild = guilds.items.first;
        final members = guilds.items.first.expand['members']?.map((e) => Member.fromRecord(e)).toList();
        membersSubcscription = pb.collection('members').subscribe("*", (e) {
          // TODO realtime sync event
          if (e.record?.data['guild'] != state.guild?.name) return;
          switch (e.action) {
            case "create":
              debugPrint("Realtime update: Create. Record id: ${e.record?.id}");
              state.guild?.members.add(Member.fromRecord(e.record!));
              break;
            case "update":
              // update existing member
              debugPrint("Realtime update: Update. Record id: ${e.record?.id}");
              int? oldIndex = state.guild?.members.indexWhere((member) => member.id == e.record?.id);
              state.guild?.members[oldIndex!] = Member.fromRecord(e.record!);
              emit(state.copyWith(status: GuildStatus.ready, guild: state.guild));
              break;
            case "delete":
              // remove member from guild
              break;
          }
        });
        return emit(state.copyWith(
            status: GuildStatus.ready,
            guild: Guild(name: guild.data['name'], members: members),
            filteredMembers: members));
      }
    } catch (e) {
      return emit(state.copyWith(status: GuildStatus.error));
    }
  }

  // event, state, and function to return filtered members
  void _filterMembers(FilterMember event, Emitter<GuildState> emit) {
    List<Member> filteredMembers = [];
    debugPrint("Search: ${event.searchValue} | Status: ${event.siegeStatus}");
    if (event.siegeStatus != null) {
      if (event.searchValue != null || event.searchValue == "") {
        filteredMembers = state.guild!.members
            .where((member) =>
                (member.name!.toLowerCase().contains(event.searchValue!) || member.pgrId.toString().contains(event.searchValue!)) &&
                member.siege?.status == event.siegeStatus)
            .toList();
        return emit(state.copyWith(filteredMembers: filteredMembers));
      }
      filteredMembers = state.guild!.members.where((member) => member.siege?.status == event.siegeStatus).toList();
      return emit(state.copyWith(filteredMembers: filteredMembers));
    }
    if (event.siegeStatus == null && event.searchValue != "" && event.searchValue != null ) {
      filteredMembers = state.guild!.members
          .where((member) =>
              member.name!.toLowerCase().contains(event.searchValue!) || member.pgrId.toString().contains(event.searchValue!))
          .toList();
      return emit(state.copyWith(filteredMembers: filteredMembers));
    }
    return emit(state.copyWith(filteredMembers: state.guild!.members));
  }

  final PocketBase pb;
  late final membersSubcscription;
  final String name;
}

final class GuildState extends Equatable {
  const GuildState({this.status = GuildStatus.notReady, this.guild, this.filteredMembers = const []});
  final GuildStatus status;
  final Guild? guild;
  final List<Member> filteredMembers;

  GuildState copyWith({GuildStatus? status, Guild? guild, List<Member>? filteredMembers}) {
    return GuildState(
        status: status ?? this.status,
        guild: guild ?? this.guild,
        filteredMembers: filteredMembers ?? this.filteredMembers);
  }

  @override
  List<Object?> get props => [status, guild?.name, filteredMembers];
}

sealed class GuildEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class FetchGuild extends GuildEvent {}

final class FilterMember extends GuildEvent {
  FilterMember({this.siegeStatus, this.searchValue});

  final SiegeStatus? siegeStatus;
  final String? searchValue;
}

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:scf_management/logger.dart';
import 'package:scf_management/models/guild.dart';
import 'package:scf_management/models/member.dart';

enum GuildStatus { ready, notReady, error }

class GuildBloc extends Bloc<GuildEvent, GuildState> {
  GuildBloc({required this.pb, required this.name}) : super(GuildState(guild: Guild())) {
    logger.i("Guild Bloc init: $name");
    on<FetchGuild>(_fetchGuild);
    on<FilterMember>(_filterMembers);
    on<AddMember>(_newMember);
    on<UpdateMember>(_updateMember);
    on<DeleteMember>(_deleteMember);
    on<Busy>(_setBusyStatus);
  }

  Future<void> _fetchGuild(FetchGuild event, Emitter<GuildState> emit) async {
    try {
      var guilds = await pb.collection('guilds').getList(filter: "name = '$name'", expand: "members");
      if (guilds.items.isNotEmpty) {
        var guild = guilds.items.first;
        final members = guilds.items.first.expand['members']?.map((e) => Member.fromRecord(e)).toList();
        return emit(state.copyWith(status: GuildStatus.ready, guild: Guild(id: guild.id, name: guild.data['name'], members: members!), filteredMembers: members));
      }
    } catch (e) {
      logger.i(e.toString());
      return emit(state.copyWith(status: GuildStatus.error));
    }
  }

  // event, state, and function to return filtered members
  void _filterMembers(FilterMember event, Emitter<GuildState> emit) {
    List<Member> filteredMembers = [];
    if (event.siegeStatus != null) {
      if (event.searchValue != null || event.searchValue == "") {
        filteredMembers =
            state.guild.members.where((member) => (member.name!.toLowerCase().contains(event.searchValue!.toLowerCase()) || member.pgrId.toString().contains(event.searchValue!.toLowerCase())) && member.siege?.status == event.siegeStatus).toList();
        return emit(state.copyWith(filteredMembers: filteredMembers));
      }
      filteredMembers = state.guild.members.where((member) => member.siege?.status == event.siegeStatus).toList();
      return emit(state.copyWith(filteredMembers: filteredMembers));
    }
    if (event.siegeStatus == null && event.searchValue != "" && event.searchValue != null) {
      filteredMembers = state.guild.members.where((member) => member.name!.toLowerCase().contains(event.searchValue!.toLowerCase()) || member.pgrId.toString().contains(event.searchValue!.toLowerCase())).toList();
      return emit(state.copyWith(filteredMembers: filteredMembers));
    }
    return emit(state.copyWith(filteredMembers: state.guild.members));
  }

  Future<void> _newMember(AddMember event, Emitter<GuildState> emit) async {
    var newRecord = await pb.collection("members").create(body: event.member);
    var members = state.guild.members.toList()..add(Member.fromRecord(newRecord));
    await pb.collection("guilds").update(state.guild.id, body: {"members+": newRecord.id});
    return emit(state.copyWith(guild: Guild(name: state.guild.name, members: members), filteredMembers: members));
  }

  Future<void> _deleteMember(DeleteMember event, Emitter<GuildState> emit) async {
    logger.d("Delete Event for ${event.member.name} start");
    await pb.collection(event.member.collectionId).delete(event.member.id);
    var newMembers = state.filteredMembers.toList()..removeWhere((element) => element.id == event.member.id);
    emit(state.copyWith(guild: state.guild.copy(members: newMembers)));
    logger.d("Delete Event for ${event.member.name} ends");
  }

  void _updateMember(UpdateMember event, Emitter<GuildState> emit) async {
    logger.d("Update Event for ${event.member.name} start");
    var newMembers = state.guild.members.toList();
    var newMember = await pb.collection(event.member.collectionId).update(event.member.id, body: event.member.toMap());
    newMembers[newMembers.indexWhere((element) => element.id == event.member.id)] = Member.fromRecord(newMember);
    logger.d("Update Event for ${event.member.name} ends");
    emit(state.copyWith(guild: state.guild.copy(members: newMembers), filteredMembers: newMembers));
  }

  void _setBusyStatus(Busy event, Emitter<GuildState> emit) {
    emit(state.copyWith(operation: event.value));
  }

  final PocketBase pb;
  final String name;
}

final class GuildState extends Equatable {
  const GuildState({this.status = GuildStatus.notReady, required this.guild, this.filteredMembers = const [], this.operation = false});
  final bool operation;
  final GuildStatus status;
  final Guild guild;
  final List<Member> filteredMembers;

  GuildState copyWith({GuildStatus? status, Guild? guild, List<Member>? filteredMembers, bool? operation}) {
    return GuildState(
      status: status ?? this.status,
      guild: guild ?? this.guild,
      operation: operation ?? this.operation,
      filteredMembers: filteredMembers ?? this.filteredMembers,
    );
  }

  @override
  List<Object?> get props => [status, operation, guild.name, filteredMembers];
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

final class AddMember extends GuildEvent {
  final Map<String, dynamic> member;
  AddMember(this.member);
}

final class UpdateMember extends GuildEvent {
  final Member member;
  UpdateMember(this.member);
}

final class DeleteMember extends GuildEvent {
  final Member member;
  DeleteMember(this.member);
}

final class Busy extends GuildEvent {
  final bool value;
  Busy(this.value);
}
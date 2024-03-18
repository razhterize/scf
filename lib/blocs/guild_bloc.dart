import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketbase/pocketbase.dart';

import '../enums.dart';
import '../models/guild_model.dart';
import '../models/member_model.dart';

import 'package:logging/logging.dart';

Logger logger = Logger("Guild Bloc");

class GuildBloc extends Bloc<GuildEvent, GuildState> {
  GuildBloc(this.pb, String name) : super(GuildState(ready: false, guild: GuildModel('', '', []), busy: true)) {
    on<GuildInit>(_init);
    on<UpdateMember>(_updateMember);
    on<AddMember>(_addMember);
    on<DeleteMember>(_deleteMember);
    add(GuildInit(name));
  }

  Future<void> _init(GuildInit event, Emitter<GuildState> emit) async {
    emit(state.copy(ready: false, busy: true));
    logger.fine("Guild Init for ${event.name}");
    var guilds = await pb.collection('guilds').getList(filter: 'name = "${event.name}"', expand: 'members');
    if (guilds.items.isNotEmpty) {
      var guild = guilds.items.first;
      emit(state.copy(ready: true, guild: GuildModel.fromRecord(guild), busy: false));
      return;
    }
  }

  Future<void> _updateMember(UpdateMember event, Emitter<GuildState> emit) async {
    emit(state.copy(busy: true));
    var newMember = await pb
        .collection('members')
        .update(event.member.id, body: event.member.toMap())
        .then((value) => Member.fromRecord(value));
    var members = state.guild.members.toList();
    members[members.indexWhere((element) => element.id == newMember.id)] = newMember;
    emit(state.copy(guild: state.guild.copy(members: members), busy: false));
  }

  Future<void> _addMember(AddMember event, Emitter<GuildState> emit) async {
    emit(state.copy(busy: true));
    var newMember = await pb.collection('members').create(body: event.member).then((value) => Member.fromRecord(value));
    await pb.collection('guilds').update(state.guild.id, body: {'members+': newMember.id});
    var members = state.guild.members.toList()..add(newMember);
    emit(state.copy(guild: state.guild.copy(members: members), busy: false));
  }

  Future<void> _deleteMember(DeleteMember event, Emitter<GuildState> emit) async {
    emit(state.copy(busy: true));
    await pb.collection('members').delete(event.member.id);
    var members = state.guild.members.toList();
    members.removeWhere((element) => element.id == event.member.id);
    emit(state.copy(guild: state.guild.copy(members: members), busy: false));
  }

  final PocketBase pb;
}

final class GuildState extends Equatable {
  final bool ready;
  final GuildModel guild;
  final bool busy;

  const GuildState({required this.ready, required this.guild, required this.busy});

  GuildState copy({bool? ready, GuildModel? guild, bool? busy, ManagementMode? mode}) =>
      GuildState(ready: ready ?? this.ready, guild: guild ?? this.guild, busy: busy ?? this.busy);

  @override
  List<Object?> get props => [guild.members, busy, ready];
}

final class GuildEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class GuildInit extends GuildEvent {
  final String name;
  GuildInit(this.name);
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

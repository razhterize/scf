import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_new/models/guild_model.dart';

import 'package:logging/logging.dart';

import '../models/member_model.dart';

final logger = Logger("Guild Cubit");

class GuildCubit extends Cubit<GuildState> {
  GuildCubit(this.pb, String name)
      : super(GuildState(busy: false, guild: GuildModel('', '', []))) {
    init(name);
  }

  final PocketBase pb;

  void init(String name) async {
    emit(state.copy(busy: true, guild: GuildModel('', '', [])));
    logger.fine("Guild Init for $name");
    var guilds = await pb
        .collection('guilds')
        .getList(filter: 'name = "$name"', expand: 'members');
    if (guilds.items.isNotEmpty) {
      var guild = guilds.items.first;
      return emit(state.copy(busy: false, guild: GuildModel.fromRecord(guild)));
    }
  }

  void updateMember(Member member) async {
    emit(state.copy(busy: true));
    var newMember = await pb
        .collection('members')
        .update(member.id, body: member.toMap())
        .then((value) => Member.fromRecord(value));
    var members = state.guild.members.toList();
    members[members.indexWhere((element) => element.id == newMember.id)] =
        newMember;
    return emit(
        state.copy(guild: state.guild.copy(members: members), busy: false));
  }

  void addMember(Member member) async {
    emit(state.copy(busy: true));
    var newMember = await pb
        .collection('members')
        .create(body: member.toMap())
        .then((value) => Member.fromRecord(value));
    await pb.collection('guilds').update(
      state.guild.id,
      body: {'members+': newMember.id},
    );
    var members = state.guild.members.toList()..add(newMember);
    emit(state.copy(guild: state.guild.copy(members: members), busy: false));
  }

  void deleteMember(Member member) async {
    emit(state.copy(busy: true));
    await pb.collection('members').delete(member.id);
    await pb.collection('guilds').update(
      state.guild.id,
      body: {'members-': member.id},
    );
    var members = state.guild.members.toList();
    members.removeWhere((element) => element.id == member.id);
    emit(state.copy(guild: state.guild.copy(members: members), busy: false));
  }
}

class GuildState extends Equatable {
  final bool busy;
  final GuildModel guild;

  const GuildState({required this.busy, required this.guild});

  GuildState copy({bool? busy, GuildModel? guild}) {
    return GuildState(busy: busy ?? this.busy, guild: guild ?? this.guild);
  }

  @override
  List<Object?> get props => [busy, guild.members];
}

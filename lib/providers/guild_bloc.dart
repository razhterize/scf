import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_management/models/guild.dart';
import 'package:scf_management/models/member.dart';

enum GuildStatus { ready, notReady, error }

class GuildBloc extends Bloc<GuildEvent, GuildState> {
  GuildBloc({required this.pb, required this.name}) : super(const GuildState()) {
    on<FetchGuild>(_fetchGuild);
  }

  Future<void> _fetchGuild(FetchGuild event, Emitter<GuildState> emit) async {
    if (state.status == GuildStatus.ready) return;
    try {
      var guilds = await pb.collection('guilds').getList(filter: "name = '$name'", expand: "members");
      if (guilds.items.isNotEmpty) {
        final members = guilds.items.first.expand['members']?.map((e) => Member.fromRecord(e)).toList();
        final guild = Guild(name: guilds.items.first.data['name'], members: members);
        return emit(state.copyWith(status: GuildStatus.ready, guild: guild));
      }
    } catch (e) {
      return emit(state.copyWith(status: GuildStatus.error));
    }
  }

  final PocketBase pb;
  final String name;
}

final class GuildState extends Equatable {
  const GuildState({this.status = GuildStatus.notReady, this.guild});
  final GuildStatus status;
  final Guild? guild;

  GuildState copyWith({GuildStatus? status, Guild? guild}) {
    return GuildState(
      status: status ?? this.status,
      guild: guild ?? this.guild,
    );
  }

  @override
  List<Object?> get props => [status, guild?.name];
}

sealed class GuildEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class FetchGuild extends GuildEvent {}

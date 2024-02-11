import 'package:scf_management/constants/abbreviations.dart';
import 'package:scf_management/models/member.dart';
import 'package:equatable/equatable.dart';

class Guild extends Equatable {
  final String id;
  final String name;
  final int minScore;
  late final String fullName;
  final List<Member> members;

  Guild({this.id = "", this.name = "", this.members = const [], this.minScore = 0}) {
    fullName = guildNames[name] ?? "";
  }

  Guild copy({String? id, String? name, List<Member>? members, int? minScore}) {
    return Guild(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      minScore: minScore ?? this.minScore,
    );
  }

  @override
  List<Object?> get props => [id, name, members];
}

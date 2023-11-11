import 'package:scf_management/constants/abbreviations.dart';
import 'package:scf_management/models/member.dart';
import 'package:equatable/equatable.dart';

class Guild extends Equatable {
  final String name;
  final int minScore;
  late final String fullName;
  late final List<Member>? _members;

  Guild({this.name = "", List<Member>? members, this.minScore = 0}) {
    fullName = guildNames[name] ?? "";
    _members = members;
  }

  List<Member> get members => _members ?? [];

  @override
  List<Object?> get props => [name, members];
}

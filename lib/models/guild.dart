import 'package:scf_management/constants/abbreviations.dart';
import 'package:scf_management/models/member.dart';

class Guild {
  final String name;
  late final minScore;
  late String fullName;
  List<Member>? _members;

  Guild({this.name = "", List<Member>? members}) {
    fullName = GuildNames[name] ?? "";
    _members = members;
  }

  List<Member> get members => _members ?? [];
}

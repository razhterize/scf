import 'package:scf_management/constants/abbreviations.dart';
import 'package:scf_management/models/member.dart';

class Guild {
  final String name;
  late int minScore;
  late String fullName;
  List<Member>? _members;

  Guild({this.name = "", List<Member>? members}) {
    fullName = guildNames[name] ?? "";
    _members = members;
  }

  List<Member> get members => _members ?? [];
}

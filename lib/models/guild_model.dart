import 'package:pocketbase/pocketbase.dart';

import 'member_model.dart';
import '../constants.dart';

class GuildModel {
  String id;
  String name;
  String? fullName;
  List<Member> members;

  GuildModel(this.id, this.name, this.members) {
    fullName = guildNames[name] ?? "";
  }

  factory GuildModel.fromRecord(RecordModel guildRecord) {
    return GuildModel(
      guildRecord.id,
      guildRecord.data['name'],
      guildRecord.expand['members']!.map((e) => Member.fromRecord(e)).toList(),
    );
  }

  GuildModel copy({String? name, List<Member>? members}) {
    return GuildModel(
      id,
      name ?? this.name,
      members ?? this.members,
    );
  }
}

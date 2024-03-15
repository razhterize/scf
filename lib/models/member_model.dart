import 'package:pocketbase/pocketbase.dart';
import '../enums.dart';

class Member {
  String id;
  String name;
  int pgrId;
  String? discordId;
  String? discordUsername;
  SiegeStatus siegeStatus;
  MazeStatus mazeStatus;

  Member(this.id, this.name, this.pgrId, this.siegeStatus, this.mazeStatus, {this.discordId, this.discordUsername});

  factory Member.fromRecord(RecordModel record) {
    return Member(
      record.id,
      record.getStringValue('name'),
      record.getIntValue('pgr_id'),
      SiegeStatus.values.byName(record.data['siege']['status']),
      MazeStatus.values.byName(record.data['maze']['status']),
      discordId: record.getStringValue('discord_id'),
      discordUsername: record.getStringValue('discord_username'),
    );
  }

  Map<String, dynamic> toMap({String? name, int? pgrId, String? discordId, String? discordUsername}) => {
        'name': name ?? this.name,
        'pgr_id': pgrId ?? this.pgrId,
        'siege': {'status': siegeStatus.name},
        'maze': {'status': mazeStatus.name},
        'discord_id': discordId??this.discordId,
        'discord_username': discordUsername??this.discordUsername
      };
}

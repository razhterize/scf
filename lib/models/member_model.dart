import 'package:pocketbase/pocketbase.dart';
import '../enums.dart';

class Member {
  String id;
  String name;
  int pgrId;
  String? discordId;
  String? discordUsername;
  SiegeStatus siegeStatus;
  MazeData mazeData;

  Member(this.id, this.name, this.pgrId, this.siegeStatus, this.mazeData,
      {this.discordId, this.discordUsername});

  factory Member.fromRecord(RecordModel record) {
    return Member(
      record.id,
      record.getStringValue('name'),
      record.getIntValue('pgr_id'),
      SiegeStatus.values.byName(record.data['siege']['status']),
      MazeData.fromMap(record.data['maze']),
      discordId: record.getStringValue('discord_id'),
      discordUsername: record.getStringValue('discord_username'),
    );
  }

  Map<String, dynamic> toMap(
          {String? name,
          int? pgrId,
          String? discordId,
          String? discordUsername}) =>
      {
        'name': name ?? this.name,
        'pgr_id': pgrId ?? this.pgrId,
        'siege': {'status': siegeStatus.name},
        'maze': mazeData.toMap(),
        'discord_id': discordId ?? this.discordId,
        'discord_username': discordUsername ?? this.discordUsername
      };
}

class MazeData {
  MazeStatus status;
  bool hidden;
  int energyDamage;
  MazeData({
    this.status = MazeStatus.unknown,
    this.hidden = false,
    this.energyDamage = 0,
  });

  factory MazeData.fromMap(Map<String, dynamic> data) {
    return MazeData(
      status: MazeStatus.values.byName(data['status']),
      hidden: data['hidden'] ?? false,
      energyDamage: data['energy_damage'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() =>
      {'status': status.name, 'hidden': hidden, 'energy_damage': energyDamage};
}

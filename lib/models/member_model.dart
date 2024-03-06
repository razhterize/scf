import 'package:pocketbase/pocketbase.dart';
import '../enums.dart';

class Member {
  String id;
  String name;
  int pgrId;
  String? discordId;
  String? discordUsername;
  // MemberSiege siege;
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
      discordId: record.getStringValue('discord_id', ""),
      discordUsername: record.getStringValue('discord_username'),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'pgr_id': pgrId,
        'siege': {'status': siegeStatus.name},
        'maze': {'status': mazeStatus.name},
        'discord_id': discordId,
        'discord_username': discordUsername,
      };
}

// class MemberSiege {
//   double currentScore;
//   List<double> pastScores;
//   SiegeStatus status;

//   MemberSiege({this.status = SiegeStatus.zero, this.pastScores = const [], this.currentScore = 0});

//   MemberSiege fromMap(Map<String, dynamic> map) => MemberSiege(status: map['status'], pastScores: map['past_scores'], currentScore: map['current_score']);

//   Map<String, dynamic> toMap() => {'status': status.name, 'past_scores': pastScores, 'current_score': currentScore};
// }

// ignore_for_file: overridden_fields

import 'package:pocketbase/pocketbase.dart';
import 'package:scf_management/constants/enums.dart';

class Member extends RecordModel {
  @override
  String id;

  @override
  String collectionName;

  @override
  String collectionId;

  String? name;
  int? pgrId;
  String? discordId;
  String? discordUsername;
  List? guild;
  MemberSiege? siege;
  MemberMaze? maze;

  Member({
    required this.id,
    required this.collectionName,
    required this.collectionId,
    this.name,
    this.pgrId,
    this.discordId,
    this.discordUsername,
    this.guild,
    this.siege,
    this.maze,
  });

  factory Member.fromRecord(RecordModel record) {
    return Member(
        id: record.id,
        collectionName: record.collectionName,
        collectionId: record.collectionId,
        name: record.data['name'],
        pgrId: record.data['pgr_id'],
        discordId: record.data['discord_id'],
        discordUsername: record.data['discord_username'],
        guild: record.data['guild'],
        siege: MemberSiege.fromJson(record.data['siege']),
        maze: MemberMaze.fromJson(record.data['maze']));
  }

  Member copy({String? name, int? pgrId, String? discordId, String? discordUsername, List? guild, MemberSiege? siege, MemberMaze? maze}) {
    return Member(
      id: id,
      collectionId: collectionId,
      collectionName: collectionName,
      name: name ?? this.name,
      pgrId: pgrId ?? this.pgrId,
      discordId: discordId ?? this.discordId,
      discordUsername: discordUsername ?? this.discordUsername,
      guild: guild ?? this.guild,
      siege: siege ?? this.siege,
      maze: maze ?? this.maze,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'pgr_id': pgrId,
      'discord_id': discordId,
      'discord_username': discordUsername,
      'maze': maze?.toJson() ?? {},
      'siege': siege?.toJson(),
      'guild': guild,
    };
  }
}

class MemberSiege {
  int currentScore;
  List<dynamic> pastScores;
  SiegeStatus status;

  MemberSiege({this.currentScore = 0, this.pastScores = const [], this.status = SiegeStatus.noScore});

  factory MemberSiege.empty() {
    return MemberSiege(currentScore: 0, pastScores: [], status: SiegeStatus.noScore);
  }

  factory MemberSiege.fromJson(Map<String, dynamic> json) {
    return MemberSiege(
      currentScore: json['current_score'] ?? 0,
      pastScores: json['past_scores'] ?? [],
      status: SiegeStatus.values.byName(json['status'] ?? "noScore"),
    );
  }

  void addSiegeScore(double score) => pastScores.add(score);
  void removeSiegeScore(int index) => pastScores.removeAt(index);

  Map<String, dynamic> toJson() {
    return {
      "current_score": currentScore,
      "past_scores": pastScores,
      "status": status.name,
    };
  }
}

class MemberMaze {
  List<dynamic>? energyUsed;
  List<dynamic>? totalPoints;
  List<dynamic>? energyOvercap;
  List<dynamic>? energyWrongNode;

  MemberMaze({
    this.energyUsed = const [],
    this.totalPoints = const [],
    this.energyOvercap = const [[]],
    this.energyWrongNode = const [[]],
  });

  factory MemberMaze.fromJson(Map<String, dynamic> json) {
    if (json == {}) return MemberMaze();
    return MemberMaze(energyUsed: json['energy_used'], totalPoints: json['total_points'], energyOvercap: json['energy_overcap'], energyWrongNode: json['energy_wrong_node']);
  }

  Map<String, dynamic> toJson() {
    return {
      "energy_used": energyUsed,
      "total_points": totalPoints,
      "energy_overcap": energyOvercap,
      "energy_wrong_node": energyWrongNode,
    };
  }
}

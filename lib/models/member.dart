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
  MemberSiege? siege;
  MemberMaze? maze;
  bool selected = false;

  Member({
    required this.id,
    required this.collectionName,
    required this.collectionId,
    this.name,
    this.pgrId,
    this.discordId,
    this.discordUsername,
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
        siege: MemberSiege.fromJson(record.data['siege']),
        maze: MemberMaze.fromJson(record.data['maze']));
  }

  void update(PocketBase pb) {
    pb.collection(collectionId).update(id, body: {
      "name": name,
      "discord_username": discordUsername,
      "discord_id": discordId,
      "pgr_id": pgrId,
      "maze": maze?.toJson() ?? {},
      "siege": siege?.toJson() ?? {}
    });
  }
}

class MemberSiege {
  int? currentScore;
  List<dynamic>? pastScores = [];
  SiegeStatus? status;

  MemberSiege({this.currentScore, this.pastScores, this.status});

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

  void addSiegeScore(double score) => pastScores!.add(score);
  void removeSiegeScore(int index) => pastScores!.removeAt(index);

  Map<String, dynamic> toJson() {
    return {
      "current_score": currentScore ?? 0,
      "past_scores": pastScores ?? [],
      "status": status?.name ?? SiegeStatus.noScore.name,
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
    return MemberMaze(
        energyUsed: json['energy_used'],
        totalPoints: json['total_points'],
        energyOvercap: json['energy_overcap'],
        energyWrongNode: json['energy_wrong_node']);
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

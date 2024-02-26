import 'package:flutter/material.dart';
import 'package:scf_management/constants/enums.dart';

final Map<SiegeStatus, dynamic> darkChartColor = {
  SiegeStatus.above: Colors.blue[800],
  SiegeStatus.below: Colors.yellow,
  SiegeStatus.noScore: Colors.red[900],
  SiegeStatus.notClear: Colors.orange,
  SiegeStatus.pardoned: Colors.deepPurple,
  SiegeStatus.newMember: Colors.green
};

final Map<MazeStatus, dynamic> mazeChartColor = {
  MazeStatus.unknown: Colors.grey,
  MazeStatus.overcap: Colors.red,
  MazeStatus.safe: Colors.green,
};

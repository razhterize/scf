import 'package:flutter/material.dart';
import 'package:scf_management/constants/enums.dart';

final Map<SiegeStatus, dynamic> darkChartColor = {
  SiegeStatus.above: Colors.blue[800],
  SiegeStatus.below: Colors.yellow,
  SiegeStatus.noScore: Colors.red[900],
  SiegeStatus.notClear: Colors.orange,
  SiegeStatus.pardoned: Colors.deepPurple,
};

final Map<SiegeStatus, dynamic> lightChartColor = {
  SiegeStatus.above: Colors.lightBlue,
  SiegeStatus.below: const Color.fromARGB(255, 231, 194, 31),
  SiegeStatus.noScore: Colors.red[900],
  SiegeStatus.notClear: Colors.orange,
  SiegeStatus.pardoned: const Color.fromARGB(255, 67, 0, 184),
};

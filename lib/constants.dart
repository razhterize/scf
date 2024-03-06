import 'enums.dart';

const Map<String, String> guildNames = {
  'turu': 'Imperium of Turu',
  'kuru': 'Cult of Kuru',
  'tensura': 'TENSURA 【懸】',
  'crepe': 'Crepe of Turu',
  'ancient_weapon': 'AncientWeapon',
  'avarice_echo': 'Avarice Echo',
  'arcadian': 'Arcadian',
  "turu_na": "Cult of Turu (NA)",
  "turu_eu": "Cult of Turu (EU)"
};

const Map<SiegeStatus, String> siegeStatus = {
  SiegeStatus.above: "Above",
  SiegeStatus.below: "Below",
  SiegeStatus.noScore: "No Score",
  SiegeStatus.notClear: "Not Clear",
  SiegeStatus.pardoned: "Pardoned",
  SiegeStatus.newMember: "New",
};

const Map<MazeStatus, String> mazeStatus = {
  MazeStatus.unknown: "Unknown",
  MazeStatus.safe: "Safe",
  MazeStatus.overcap: "Overcap",
};

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'app.dart';

void main(List<String> args) async {
  await dotenv.load(fileName: ".env");
  var prefs = await SharedPreferences.getInstance();
  runApp(SCFManagement(sharedPreferences: prefs));
  // runApp(const Example());
}
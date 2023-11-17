import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'app.dart';

void main(List<String> args) async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitle("PGR Guild Management");
    });
  }
  await dotenv.load(fileName: "env");
  var prefs = await SharedPreferences.getInstance();
  runApp(SCFManagement(sharedPreferences: prefs));
  // runApp(const Example());
}

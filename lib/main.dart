import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:pocketbase/pocketbase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart';

import 'blocs/login_bloc.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/main_screen.dart';

import 'configs.dart';

void main(List<String> args) async {
  Logger.root
    ..level = Level.ALL
    ..onRecord.listen((record) {
      log('${record.level.name}: ${record.time}: ${record.message}');
    });
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());
  // PocketBase pb = PocketBase(databaseUrl);
  // if (!pb.authStore.isValid) await pb.admins.authWithPassword(adminLogin['username']!, adminLogin['password']!);
  // runApp(App(pb: pb));
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: BlocProvider(
          create: (context) => LoginBloc(),
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (!state.authStore.isValid) return const LoginScreen();
              return const MainScreen();
            },
          ),
        ),
      ),
    );
  }
}

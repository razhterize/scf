import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:logging/logging.dart';

import 'configs.dart';
import 'blocs/filter_cubit.dart';
import 'blocs/selection_cubit.dart';
import 'blocs/switch_cubit.dart';
import 'blocs/guild_bloc.dart';
import 'blocs/login_bloc.dart';
import 'ui/screens/main_screen.dart';

void main(List<String> args) async {
  Logger.root
    ..level = Level.ALL
    ..onRecord.listen((record) {
      log('${record.level.name}: ${record.message}');
    });

  const String dbUrl = String.fromEnvironment("DATABASE_URL");
  databaseUrl = dbUrl;
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
      );

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => SwitchCubit()),
      ],
      child: BlocProvider(
        create: (context) => GuildBloc(
          context.read<LoginBloc>().pb,
          context.read<SwitchCubit>().state.name,
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  SelectionCubit(context.read<GuildBloc>().state.guild.members),
            ),
            BlocProvider(
              create: (context) =>
                  FilterCubit(context.read<GuildBloc>().state.guild.members),
            ),
          ],
          child: BlocListener<GuildBloc, GuildState>(
            listener: (context, state) {
              context.read<SelectionCubit>().members = state.guild.members;
              context.read<FilterCubit>().members = state.guild.members;
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: kIsWeb ? "SCF Management" : "",
              theme: ThemeData.dark(),
              home: const MainScreen(),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:logging/logging.dart';
import 'package:scf_new/ui/widgets/action_bar.dart';
import 'package:scf_new/ui/screens/guild_screen.dart';
import 'package:scf_new/ui/themes.dart';

import 'blocs/guild_cubit.dart';
import 'configs.dart';
import 'blocs/filter_cubit.dart';
import 'blocs/selection_cubit.dart';
import 'blocs/switch_cubit.dart';
import 'blocs/login_bloc.dart';

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
      storageDirectory: await getApplicationCacheDirectory()
      // storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
      );

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool first = false;
  late final bool themeBrighness;
  late final Color themeSeed;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => SwitchCubit()),
      ],
      child: BlocProvider(
        create: (context) => GuildCubit(
          context.read<LoginBloc>().pb,
          context.read<SwitchCubit>().state.name,
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SelectionCubit(
                  context.read<GuildCubit>().state.guild.members),
            ),
            BlocProvider(
              create: (context) =>
                  FilterCubit(context.read<GuildCubit>().state.guild.members),
            ),
          ],
          child: BlocListener<GuildCubit, GuildState>(
            listener: (context, state) {
              context.read<SelectionCubit>().members = state.guild.members;
              context.read<FilterCubit>().members = state.guild.members;
            },
            child: BlocListener<SwitchCubit, SwitchState>(
              listener: (context, state) =>
                  state.name != context.read<GuildCubit>().state.guild.name
                      ? context.read<GuildCubit>().init(state.name)
                      : null,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                // title: kIsWeb ? "SCF Management" : "",
                theme: ThemeData.from(colorScheme: darkColorScheme),
                // theme: customTheme(brightness: Brightness.dark),
                home: Scaffold(
                  body: LayoutBuilder(
                    builder: (_, constrain) {
                      return Flex(
                        direction: constrain.maxWidth < 720
                            ? Axis.vertical
                            : Axis.horizontal,
                        children: [
                          const Expanded(child: GuildScreen()),
                          ActionBar(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

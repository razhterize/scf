import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_management/providers/login_cubit.dart';
import 'package:scf_management/providers/settings_bloc.dart';
import 'package:scf_management/ui/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fetch_client/fetch_client.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

class SCFManagement extends StatefulWidget {
  const SCFManagement({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  State<SCFManagement> createState() => _SCFManagementState();
}

class _SCFManagementState extends State<SCFManagement> {
  late final SharedPreferences sharedPreferences;
  late final PocketBase pb;

  @override
  void initState() {
    sharedPreferences = widget.sharedPreferences;
    String? dbUrl = sharedPreferences.getString("databaseUrl");
    if (dbUrl == "" || dbUrl == null) {
      dbUrl = dotenv.get("PB_URL");
    }
    pb = PocketBase(
      dbUrl,
      authStore: AsyncAuthStore(
        save: (String data) => sharedPreferences.setString('pb_auth', data),
        initial: sharedPreferences.getString('pb_auth'),
        clear: () => sharedPreferences.setString("pb_auth", ""),
      ),
      // httpClientFactory: kIsWeb ? () => FetchClient(mode: RequestMode.cors) : null,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(pb: pb),
        ),
        BlocProvider(
          create: (context) => SettingBloc(sharedPreferences: sharedPreferences),
        ),
      ],
      child: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          BlocProvider.of<SettingBloc>(context).add(GetSettings());
          return MaterialApp(
            // title: kIsWeb ? "SCF Management" : "",
            debugShowCheckedModeBanner: false,
            theme: state.lightMode ? ThemeData.light() : ThemeData.dark(),
            home: HomeScreen(pb: pb),
          );
        },
      ),
    );
  }
}

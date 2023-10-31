import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:scf_management/providers/login_cubit.dart';
import 'package:scf_management/providers/settings_bloc.dart';
import 'package:scf_management/ui/screens/login_screen.dart';
import 'package:scf_management/ui/screens/home_screen.dart';
import 'package:scf_management/ui/widgets/settings_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SCFManagement extends StatefulWidget {
  const SCFManagement({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  State<SCFManagement> createState() => _SCFManagementState();
}

class _SCFManagementState extends State<SCFManagement> {
  int navBarIndex = 0;
  late final SharedPreferences sharedPreferences;
  late final PocketBase pb;

  @override
  void initState() {
    sharedPreferences = widget.sharedPreferences;
    pb = PocketBase(
      sharedPreferences.getString("database_url") ?? dotenv.get("LOCAL_PB_URL"),
      authStore: AsyncAuthStore(
        save: (String data) => sharedPreferences.setString('pb_auth', data),
        initial: sharedPreferences.getString('pb_auth'),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(pb),
        ),
        BlocProvider(
          create: (context) => SettingBloc(sharedPreferences: sharedPreferences),
        ),
      ],
      child: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          return MaterialApp(
            theme: state.lightMode ? ThemeData.light() : ThemeData.dark(),
            home: HomeScreen(pb: pb),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:scf_management/providers/guild_bloc.dart';
import 'package:scf_management/providers/login_cubit.dart';
import 'package:scf_management/ui/screens/login_screen.dart';
import 'package:scf_management/ui/widgets/guild_overview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:scf_management/ui/widgets/settings_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.pb});

  final PocketBase pb;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final PocketBase pb;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    pb = widget.pb;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, loginState) {
        if (loginState.loginStatus == LoginStatus.failed || loginState.loginStatus == LoginStatus.unknown) {
          return const LoginScreen();
        } else if (loginState.loginStatus == LoginStatus.processing) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.twoRotatingArc(color: Colors.blue, size: 50),
                const Text(
                  "Waiting for Discord OAuth2...",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )
              ],
            ),
          );
        }
        return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: const Text("Siege"),
              centerTitle: true,
            ),
            drawer: _drawer(),
            body: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state.loginStatus == LoginStatus.success) {
                  return _body(state);
                } else if (state.loginStatus == LoginStatus.processing) {
                  return LoadingAnimationWidget.threeArchedCircle(color: Colors.white, size: 50);
                }
                return const LoginScreen();
              },
            ));
      },
    );
  }

  GridView _body(LoginState state) {
    var managedGuilds = state.pb.authStore.model.data['managed_guilds'];
    return GridView.builder(
      itemCount: managedGuilds.length ?? 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: maxWidget()),
      itemBuilder: (context, index) {
        return BlocProvider(
          create: (context) => GuildBloc(pb: pb, name: managedGuilds[index]),
          child: BlocBuilder<GuildBloc, GuildState>(
            builder: (context, guildState) {
              BlocProvider.of<GuildBloc>(context).add(FetchGuild());
              if (guildState.status == GuildStatus.notReady) {
                return LoadingAnimationWidget.threeArchedCircle(color: Colors.blue, size: 50);
              } else if (guildState.status == GuildStatus.error) {
                return Center(child: Text("Error fetching guild ${guildState.guild?.fullName}"));
              } else {
                return GuildOverview(pb: state.pb, guild: guildState.guild!);
              }
            },
          ),
        );
      },
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(flex: 3, child: _loggedInProfile()),
          const Expanded(flex: 5, child: Placeholder()),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: MaterialButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const SettingsPopup(),
                );
              },
              child: const Icon(Icons.settings),
            ),
          )
        ],
      ),
    );
  }

  Widget _loggedInProfile() {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        if (!state.pb.authStore.isValid) {
          return Column(
            children: [
              Icon(Icons.login, color: Colors.green, size: MediaQuery.of(context).size.width / 20),
              const Text("Login")
            ],
          );
        }
        if (state.authModel?.record?.data['avatar'] != "") {
          var url = pb.getFileUrl(state.authModel!.record!, state.authModel!.record!.getDataValue('avatar'));
          return Column(
            children: [
              CircleAvatar(radius: MediaQuery.of(context).size.width / 20, child: Image.network(url.toString())),
              Text(state.authModel!.record!.getStringValue('username'), style: const TextStyle(fontSize: 25)),
              IconButton(
                  onPressed: () {
                    BlocProvider.of<LoginCubit>(context).logout();
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ))
            ],
          );
        }
        return Column(
          children: [
            CircleAvatar(
                radius: MediaQuery.of(context).size.width / 20,
                child: Icon(Icons.people, size: MediaQuery.of(context).size.width / 20)),
            Text(state.authModel!.record!.getStringValue('username'), style: const TextStyle(fontSize: 25)),
            IconButton(
                onPressed: () {
                  BlocProvider.of<LoginCubit>(context).logout();
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ))
          ],
        );
      },
    );
  }

  int maxWidget() {
    var orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      return 4;
    }
    return 1;
  }
}

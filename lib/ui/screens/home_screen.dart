import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:scf_management/providers/guild_bloc.dart';
import 'package:scf_management/providers/login_cubit.dart';
import 'package:scf_management/providers/screen_bloc.dart';
import 'package:scf_management/ui/screens/guild_detail_screen.dart';
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
                Text(
                  "Waiting for Discord OAuth2...",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )
              ],
            ),
          );
        }
        return BlocProvider(
            create: (context) => ScreenBloc(),
            child: BlocBuilder<ScreenBloc, ScreenState>(
              builder: (context, state) {
                return Scaffold(
                  key: _scaffoldKey,
                  appBar: _appBar(state),
                  drawer: _drawer(),
                  floatingActionButton: _floatingActionButton(state),
                  body: state.showOverview ? _body(loginState) : GuildDetails(guild: state.guild!),
                );
              },
            ));
      },
    );
  }

  GridView _body(LoginState state) {
    var managedGuilds = state.authStore?.model.data['managed_guilds'];
    return GridView.builder(
      itemCount: managedGuilds.length ?? 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: maxWidget()),
      itemBuilder: (context, index) {
        return BlocProvider(
          create: (context) => GuildBloc(pb: pb, name: managedGuilds[index]),
          child: BlocBuilder<GuildBloc, GuildState>(
            builder: (context, state) {
              BlocProvider.of<GuildBloc>(context).add(FetchGuild());
              if (state.status == GuildStatus.notReady) {
                return LoadingAnimationWidget.threeArchedCircle(color: Colors.blue, size: 50);
              } else if (state.status == GuildStatus.error) {
                return Center(child: Text("Error fetching guild ${state.guild?.fullName}"));
              } else {
                return GuildOverview(guild: state.guild!);
              }
            },
          ),
        );
      },
    );
  }

  Widget? _floatingActionButton(ScreenState state) {
    if (!state.showOverview) {
      return FloatingActionButton(
        onPressed: () async {
          var selectedMembers = state.guild?.members.where((element) => element.selected == true).toList();
          String pingText = "";
          for (var member in selectedMembers!) {
            if (member.discordId == null || member.discordId == "-" || member.discordId == "<@>") {
              pingText += member.discordUsername ?? "-\n";
            } else {
              pingText += "<@${member.discordId}>\n";
            }
          }
          await Clipboard.setData(ClipboardData(text: pingText));
        },
        child: const Icon(
          Icons.alternate_email,
        ),
      );
    }
    return null;
  }

  PreferredSizeWidget _appBar(ScreenState state) {
    return AppBar(
      title: const Text("Siege"),
      centerTitle: true,
      automaticallyImplyLeading: false,
      toolbarHeight: 40,
      leading: state.showOverview
          ? IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu),
            )
          : BlocBuilder<ScreenBloc, ScreenState>(
              builder: (context, state) {
                return IconButton(
                    onPressed: () {
                      BlocProvider.of<ScreenBloc>(context).add(ShowOverview());
                    },
                    icon: const Icon(Icons.arrow_back));
              },
            ),
      actions: [
        MaterialButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const SettingsPopup(),
            );
          },
          child: const Icon(Icons.settings),
        ),
      ],
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(flex: 3, child: _loggedInProfile()),
          const Expanded(flex: 5, child: Placeholder()),
          // TODO add logout button
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
        if (!state.authStore!.isValid) {
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

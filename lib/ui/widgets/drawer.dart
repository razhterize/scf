import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_management/blocs/login_bloc.dart';
import 'package:scf_management/blocs/screen_bloc.dart';
import 'package:scf_management/ui/screens/maze_screen.dart';
import 'package:scf_management/ui/screens/siege_screen.dart';
import 'package:scf_management/ui/widgets/settings_popup.dart';

Widget drawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        const SizedBox(height: 20),
        Expanded(flex: 3, child: loggedInProfile()),
        Expanded(
            flex: 5,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text("Siege"),
                  onTap: () {
                    // Navigator.pop(context);
                    BlocProvider.of<ScreenBloc>(context).add(ChangeScreen(const SiegeScreen()));
                    // Open Siege page?
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_box),
                  title: const Text("Maze"),
                  onTap: () {
                    // Open maze page here
                    BlocProvider.of<ScreenBloc>(context).add(ChangeScreen(const MazeScreen()));
                  },
                ),
              ],
            )),
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

Widget loggedInProfile() {
  return BlocBuilder<LoginBloc, LoginState>(
    builder: (context, state) {
      if (!state.pb.authStore.isValid) {
        return Column(
          children: [Icon(Icons.login, color: Colors.green, size: MediaQuery.of(context).size.width / 20), const Text("Login")],
        );
      }
      if (state.authModel?.record?.data['avatar'] != "") {
        var url = state.pb.getFileUrl(state.authModel!.record!, state.authModel!.record!.getDataValue('avatar'));
        return Column(
          children: [
            CircleAvatar(radius: MediaQuery.of(context).size.width / 20, child: Image.network(url.toString())),
            Text(state.authModel!.record!.getStringValue('username'), style: const TextStyle(fontSize: 25)),
            IconButton(
                onPressed: () {
                  BlocProvider.of<LoginBloc>(context).add(Logout());
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
          CircleAvatar(radius: MediaQuery.of(context).size.width / 20, child: Icon(Icons.people, size: MediaQuery.of(context).size.width / 20)),
          Text(state.authModel!.record!.getStringValue('username'), style: const TextStyle(fontSize: 25)),
          IconButton(
              onPressed: () {
                BlocProvider.of<LoginBloc>(context).add(Logout());
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

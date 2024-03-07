import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../blocs/login_bloc.dart';
import '../../blocs/switch_cubit.dart';
import '../widgets/detail_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int guildIndex = 0;
  int modeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        if (!loginState.authStore.isValid) return Center(child: LoadingAnimationWidget.threeRotatingDots(color: Colors.white, size: 50));
        return BlocProvider(
          create: (context) => SwitchCubit(),
          child: Builder(builder: (context) {
            return const Scaffold(
              body: DetailWidget(),
            );
          }),
        );
      },
    );
  }
}

// var data =Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     MaterialButton(
//       onPressed: () {
//         int guildCount = loginState.authStore.model.data['managed_guilds'].length;
//         setState(() {
//           if (guildIndex >= guildCount - 1) guildIndex = 0;
//           guildIndex += 1;
//         });
//         context.read<SwitchCubit>().switchGuild(loginState.authStore.model.data['managed_guilds'][guildIndex]);
//       },
//       child: const Text("Change Guild"),
//     ),
//     MaterialButton(
//       onPressed: () {
//         setState(() {
//           modeIndex += 1;
//           if (modeIndex > 2) modeIndex = 0;
//           context.read<SwitchCubit>().switchMode(ManagementMode.values[modeIndex]);
//         });
//       },
//       child: const Text("Change Mode"),
//     ),
//   ],
// )
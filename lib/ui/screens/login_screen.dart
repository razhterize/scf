import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:scf_management/blocs/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.people,
                  size: 50,
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    BlocProvider.of<LoginCubit>(context).loginWithDiscord();
                  },
                  icon: state.loginStatus != LoginStatus.processing
                      ? SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset("assets/discord.png"),
                        )
                      : LoadingAnimationWidget.newtonCradle(color: Colors.black, size: 50),
                  label: const Text("Discord Login"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void loginAsAdmin() {
    // fancy stuff to login as admin
    var pb = BlocProvider.of<LoginCubit>(context).state.pb;
    pb.admins.authWithPassword("", "");
  }
}

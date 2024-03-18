import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../blocs/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.people,
                size: 50,
              ),
              FloatingActionButton.extended(
                onPressed: () => loginBloc.add(DiscordLogin()),
                icon: state.loginStatus != LoginStatus.processing
                    ? SizedBox(
                        width: 25,
                        height: 25,
                        child: Image.asset("assets/discord.png"),
                      )
                    : LoadingAnimationWidget.newtonCradle(
                        color: Colors.black, size: 50),
                label: const Text("Discord Login"),
              )
            ],
          ),
        );
      },
    );
  }
}

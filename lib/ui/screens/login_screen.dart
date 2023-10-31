import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:scf_management/providers/login_cubit.dart';

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
        return Center(
          child: MaterialButton(
              onPressed: () {
                if (state.loginStatus != LoginStatus.success) {
                  BlocProvider.of<LoginCubit>(context).loginWithDiscord();
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.login,
                    color: Colors.green,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Login with Discord"),
                  )
                ],
              )),
        );
      },
    );
  }
}

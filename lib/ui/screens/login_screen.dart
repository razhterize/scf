import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/login_bloc.dart';
import 'package:scf_new/ui/widgets/loading.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child: isSmallScreen
            ? const _Logo()
            : Expanded(
              child: Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: _Logo(),
              ),
            ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const LoadingIndicator(),
        // Image.asset("assets/discord.png"),
        ImageIcon(const AssetImage("assets/discord.png"),
            size: isSmallScreen ? 100 : 200),
        // FlutterLogo(size: isSmallScreen ? 100 : 200),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MaterialButton(
            onPressed: () => context.read<LoginBloc>().add(DiscordLogin()),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).buttonTheme.colorScheme?.inversePrimary,
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Login with Discord",
                textAlign: TextAlign.center,
                style: isSmallScreen
                    ? Theme.of(context).textTheme.headlineSmall
                    : Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

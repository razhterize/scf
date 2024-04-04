import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_new/blocs/login_bloc.dart';
import 'package:scf_new/ui/widgets/loading.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => context.read<LoginBloc>().add(DiscordLogin()),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: context.watch<LoginBloc>().state.loginStatus ==
                      LoginStatus.processing
                  ? const LoadingIndicator(
                      size: 25,
                    )
                  : const ImageIcon(AssetImage('assets/discord.png')),
            ),
            Text(
              "  Discord Login",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

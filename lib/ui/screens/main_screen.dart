import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:scf_new/ui/widgets/error_popup.dart';

import '../../blocs/login_bloc.dart';
import '../../blocs/switch_cubit.dart';
import '../widgets/detail_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        if (!loginState.authStore.isValid) {
          return Center(child: LoadingAnimationWidget.threeRotatingDots(color: Colors.white, size: 50));
        }

        return BlocProvider(
          create: (context) => SwitchCubit(),
          child: const DetailWidget(),
        );
      },
    );
  }
}
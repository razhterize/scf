import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scf_management/ui/screens/login_screen.dart';

class ScreenBloc extends Bloc<ScreenEvent, ScreenState> {
  ScreenBloc() : super(const ScreenState(screen: LoginScreen())) {
    on<ChangeScreen>(_changeScreen);
  }

  void _changeScreen(ChangeScreen event, Emitter<ScreenState> emit) => emit(state.copyWith(screen: event.screen));
}

final class ScreenState extends Equatable {
  final StatefulWidget screen;
  const ScreenState({required this.screen});

  ScreenState copyWith({StatefulWidget? screen}) {
    return ScreenState(screen: screen ?? this.screen);
  }

  @override
  List<Object?> get props => [screen];
}

final class ScreenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ChangeScreen extends ScreenEvent {
  final StatefulWidget screen;
  ChangeScreen(this.screen);
}

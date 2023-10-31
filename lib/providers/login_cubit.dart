// ignore_for_file: unused_local_variable

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginState extends Equatable {
  const LoginState({required this.loginStatus, this.authStore, this.authModel});

  final LoginStatus loginStatus;
  final AuthStore? authStore;
  final RecordAuth? authModel;

  LoginState copyWith({LoginStatus? loginStatus, AuthStore? authStore, RecordAuth? authModel}) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      authStore: authStore ?? this.authStore,
      authModel: authModel ?? this.authModel,
    );
  }

  @override
  List<Object?> get props => [loginStatus, authStore];
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(PocketBase pb) : super(const LoginState(loginStatus: LoginStatus.unknown)) {
    _pb = pb;
    if (_pb.authStore.isValid) {
      authRefresh(pb);
      return;
    } else {
      emit(state.copyWith(loginStatus: LoginStatus.failed));
    }
  }

  Future<void> authRefresh(PocketBase pb) async {
    var model = await pb.collection("discord_auth").authRefresh();
    emit(state.copyWith(authModel: model, loginStatus: LoginStatus.success, authStore: pb.authStore));
  }

  void logout() {
    _pb.authStore.clear();
    emit(state.copyWith(loginStatus: LoginStatus.failed));
  }

  void loginWithDiscord() {
    if (_pb.authStore.isValid) {
      emit(state.copyWith(loginStatus: LoginStatus.success, authStore: _pb.authStore));
      return;
    }
    final authData = _pb.collection("discord_auth").authWithOAuth2(
      "discord",
      (url) async {
        await launchUrl(url);
        _pb.authStore.onChange.listen((event) {
          if (_pb.authStore.isValid) {
            emit(state.copyWith(loginStatus: LoginStatus.success, authStore: _pb.authStore));
            return;
          }
        });
      },
      scopes: ['identify', 'guilds'],
    );
    emit(state.copyWith(loginStatus: LoginStatus.failed));
  }

  late final PocketBase _pb;
}

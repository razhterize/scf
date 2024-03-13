import 'dart:convert';

import 'package:equatable/equatable.dart';
// import 'package:fetch_client/fetch_client.dart';
// import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_new/configs.dart';
import 'package:url_launcher/url_launcher.dart';

enum LoginStatus { success, failed, unknown, processing }

class LoginBloc extends HydratedBloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(
          LoginState(
            loginStatus: LoginStatus.unknown,
            authStore: AsyncAuthStore(
              save: (data) => HydratedBloc.storage.write('hydrate_login_auth_store', data),
              initial: HydratedBloc.storage.read('hydrate_login_auth_store'),
            ),
          ),
        ) {
    pb = PocketBase(
      databaseUrl,
      authStore: state.authStore,
      // httpClientFactory: kIsWeb ? () => FetchClient(mode: RequestMode.cors) : null
    );
    on<DiscordLogin>(loginWithDiscord);
    on<AuthRefresh>(authRefresh);
    on<Logout>(logout);
    if (pb.authStore.isValid) add(AuthRefresh());
  }
  late final PocketBase pb;

  Future<void> authRefresh(AuthRefresh event, Emitter<LoginState> emit) async {
    await pb.collection("discord_auth").authRefresh();
    state.copy(loginStatus: LoginStatus.success);
  }

  void logout(Logout event, Emitter<LoginState> emit) {
    pb.authStore.clear();
    emit(state.copy(loginStatus: LoginStatus.failed));
  }

  void loginWithDiscord(DiscordLogin event, Emitter<LoginState> emit) async {
    emit(state.copy(loginStatus: LoginStatus.processing));
    if (pb.authStore.isValid) {
      add(AuthRefresh());
      return;
    }
    try {
      await pb.collection("discord_auth").authWithOAuth2(
        "discord",
        (url) async {
          await launchUrl(url);
        },
        scopes: ['identify', 'guilds'],
      ).then((value) {
        if (pb.authStore.isValid) {
          add(AuthRefresh());
        }
      });
    } catch (e) {
      emit(state.copy(loginStatus: LoginStatus.failed));
    }
  }

  @override
  LoginState? fromJson(Map<String, dynamic> json) {
    return LoginState(
      loginStatus: LoginStatus.values.byName(json['hydrate_login_status']),
      authStore: pb.authStore,
    );
  }

  @override
  Map<String, dynamic>? toJson(LoginState state) => {
        'hydrate_login_status': state.loginStatus.name,
        'hydrate_login_auth': json.encode({
          'token': state.authStore.token,
          'model': json.encode(state.authStore.model),
        })
      };
}

class LoginState extends Equatable {
  const LoginState({required this.loginStatus, required this.authStore});

  final LoginStatus loginStatus;
  final AuthStore authStore;

  LoginState copy({LoginStatus? loginStatus, AuthStore? authStore}) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      authStore: authStore ?? this.authStore,
    );
  }

  @override
  List<Object?> get props => [loginStatus, authStore.token];
}

final class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class DiscordLogin extends LoginEvent {}

final class AuthRefresh extends LoginEvent {}

final class Logout extends LoginEvent {}

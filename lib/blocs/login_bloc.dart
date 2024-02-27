import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_management/constants/enums.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http;

class LoginState extends Equatable {
  const LoginState({required this.loginStatus, required this.pb, this.authModel});

  final LoginStatus loginStatus;
  final PocketBase pb;
  final RecordAuth? authModel;

  LoginState copyWith({LoginStatus? loginStatus, PocketBase? pb, RecordAuth? authModel}) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      pb: pb ?? this.pb,
      authModel: authModel ?? this.authModel,
    );
  }

  @override
  List<Object?> get props => [loginStatus, pb];
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.pb}) : super(LoginState(loginStatus: LoginStatus.unknown, pb: pb)) {
    on<DiscordLogin>(loginWithDiscord);
    on<AuthRefresh>(authRefresh);
    on<Logout>(logout);
  }

  Future<void> authRefresh(AuthRefresh event, Emitter<LoginState> emit) async {
    var model = await pb.collection("discord_auth").authRefresh();
    emit(state.copyWith(authModel: model, loginStatus: LoginStatus.success));
  }

  void logout(Logout event, Emitter<LoginState> emit) {
    pb.authStore.clear();
    emit(state.copyWith(loginStatus: LoginStatus.failed));
  }

  void loginWithDiscord(DiscordLogin event, Emitter<LoginState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.processing));
    if (pb.authStore.isValid) {
      var model = await pb.collection("discord_auth").authRefresh();
      emit(state.copyWith(loginStatus: LoginStatus.success, pb: pb, authModel: model));
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
      emit(state.copyWith(loginStatus: LoginStatus.failed));
    }
  }

  final PocketBase pb;
}

final class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class DiscordLogin extends LoginEvent {}

final class AuthRefresh extends LoginEvent {}

final class Logout extends LoginEvent {}

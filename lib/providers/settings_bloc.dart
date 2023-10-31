import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc({required this.sharedPreferences}) : super(SettingState()) {
    on<GetSettings>(fetchSettings);
    on<SetSettings>(setSettings);
  }

  void fetchSettings(GetSettings event, Emitter<SettingState> emit) {
    bool lightMode =  sharedPreferences.getBool('lightMode') ?? false;
    String databaseUrl = sharedPreferences.getString('databaseUrl') ?? dotenv.get("LOCAL_PB_URL");
    return emit(state.copyWith(lightMode: lightMode, databaseUrl: databaseUrl));
  }

  void setSettings(SetSettings event, Emitter<SettingState> emit) {
    sharedPreferences.setBool("lightMode", event.lightMode);
    sharedPreferences.setString("databaseUrl", event.databaseUrl);
    return emit(state.copyWith(lightMode: event.lightMode, databaseUrl: event.databaseUrl));
  }

  final SharedPreferences sharedPreferences;
}

final class SettingState extends Equatable {
  const SettingState({this.lightMode = false, this.databaseUrl = ""});

  final bool lightMode;
  final String databaseUrl;

  SettingState copyWith({bool? lightMode, String? databaseUrl}) {
    return SettingState(
      lightMode: lightMode ?? this.lightMode,
      databaseUrl: databaseUrl ?? this.databaseUrl,
    );
  }

  @override
  List<Object> get props => [lightMode, databaseUrl];
}

sealed class SettingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class GetSettings extends SettingEvent {}

final class SetSettings extends SettingEvent {
  SetSettings({this.lightMode = false, this.databaseUrl = ""});
  bool lightMode;
  String databaseUrl;
}

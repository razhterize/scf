import 'package:hydrated_bloc/hydrated_bloc.dart';

class GuildSwitchCubit extends HydratedCubit<int> {
  GuildSwitchCubit() : super(0);

  void switchGuild(int index) => emit(index);

  @override
  int? fromJson(Map<String, dynamic> json) => json['hydrate_switch_value'] as int;

  @override
  Map<String, dynamic>? toJson(int state) => {'hydrate_switch_value': state};
}

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:scf_new/enums.dart';

class SwitchCubit extends HydratedCubit<SwitchState> {
  SwitchCubit() : super(const SwitchState(name: '', mode: ManagementMode.siege));

  void switchMode(ManagementMode mode) => emit(state.copy(mode: mode));
  void switchGuild(String name) => emit(state.copy(name: name));

  @override
  SwitchState? fromJson(Map<String, dynamic> json) => SwitchState(
        name: json['hydrate_switch_name'],
        mode: ManagementMode.values.byName(json['hydrate_switch_mode']),
      );

  @override
  Map<String, dynamic>? toJson(SwitchState state) => {'hydrate_switch_name': state.name, 'hydrate_switch_mode': state.mode.name};
}

class SwitchState extends Equatable {
  final String name;
  final ManagementMode mode;
  const SwitchState({required this.name, required this.mode});

  SwitchState copy({String? name, ManagementMode? mode}) => SwitchState(name: name ?? this.name, mode: mode ?? this.mode);

  @override
  List<Object?> get props => [name, mode];
}

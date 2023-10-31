import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scf_management/models/guild.dart';

class ScreenBloc extends Bloc<ScreenEvent, ScreenState>{
  ScreenBloc() : super(ScreenState()){
    on<ShowOverview>(_showOverview);
    on<ShowGuildDetails>(_showDetails);
  }

  void _showOverview(ShowOverview event, Emitter<ScreenState> emit){
    emit(state.copyWith(showOverview: true, guild: null));
  }
  void _showDetails(ShowGuildDetails event, Emitter<ScreenState> emit){
    emit(state.copyWith(showOverview: false, guild: event.guild));
  }
}

final class ScreenState extends Equatable{
  const ScreenState({this.showOverview = true, this.guild});

  final Guild? guild;
  final bool showOverview;

  ScreenState copyWith({bool? showOverview, Guild? guild}){
    return ScreenState(
      showOverview: showOverview ?? this.showOverview,
      guild: guild ?? null
    );
  }
  
  @override
  List<Object?> get props => [showOverview, guild?.name];

}

sealed class ScreenEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class ShowGuildDetails extends ScreenEvent {
  ShowGuildDetails({required this.guild});
  final Guild guild;
}

final class ShowOverview extends ScreenEvent {}

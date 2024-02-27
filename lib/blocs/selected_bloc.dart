import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scf_management/logger.dart';
import 'package:scf_management/models/member.dart';
import 'package:scf_management/models/guild.dart';

class SelectBloc extends Bloc<SelectEvent, SelectState> {
  final Guild guild;
  SelectBloc({required this.guild}) : super(const SelectState()) {
    logger.i("Select Bloc init for ${guild.name}");
    on<AddSelected>(_addSelected);
    on<RemoveSelected>(_removeSelected);
    on<SelectAll>(_selectAll);
    on<SelectRange>(_selectRange);
    on<DeselectAll>(_deselectAll);
    on<InvertSelection>(_invertSelction);
  }

  void _addSelected(AddSelected event, Emitter<SelectState> emit) {
    var currentSelected = state.selectedMembers.toList();
    currentSelected.add(event.member);
    return emit(state.copyWith(selectedMembers: currentSelected));
  }

  void _removeSelected(RemoveSelected event, Emitter<SelectState> emit) {
    var currentSelected = state.selectedMembers.toList();
    currentSelected.removeWhere((element) => element.id == event.member.id);
    return emit(state.copyWith(selectedMembers: currentSelected));
  }

  void _selectAll(SelectAll event, Emitter<SelectState> emit) {
    var members = guild.members.toList();
    return emit(state.copyWith(selectAll: true, selectedMembers: members));
  }

  void _selectRange(SelectRange event, Emitter<SelectState> emit) {
    int index1 = guild.members.indexWhere((element) => element.id == state.selectedMembers.first.id);
    int index2 = guild.members.indexWhere((element) => element.id == state.selectedMembers.last.id);
    var membersRange = guild.members.sublist(index1, index2 += 1);
    logger.d('Members selected ${membersRange.length}');
    if (membersRange.length == guild.members.length) {
      return emit(state.copyWith(selectAll: true, selectedMembers: membersRange));
    }
    return emit(state.copyWith(selectedMembers: membersRange));
  }

  void _invertSelction(InvertSelection event, Emitter<SelectState> emit) {
    var newList = guild.members.where((element) => !state.selectedMembers.contains(element)).toList();
    return emit(state.copyWith(selectedMembers: newList, inverted: !state.inverted));
  }

  void _deselectAll(DeselectAll event, Emitter<SelectState> emit) {
    emit(state.copyWith(selectAll: false, selectedMembers: []));
  }
}

final class SelectState extends Equatable {
  final List<Member> selectedMembers;
  final bool selectAll;
  final String mentionText;
  final bool inverted;

  const SelectState({this.selectAll = false, this.selectedMembers = const [], this.mentionText = "", this.inverted = false});

  SelectState copyWith({bool? selectAll, List<Member>? selectedMembers, bool? inverted, String? mentionText}) {
    return SelectState(
      selectAll: selectAll ?? this.selectAll,
      selectedMembers: selectedMembers ?? this.selectedMembers,
      inverted: inverted ?? this.inverted,
      mentionText: mentionText ?? this.mentionText,
    );
  }

  @override
  List<Object?> get props => [selectedMembers];
}

sealed class SelectEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class AddSelected extends SelectEvent {
  AddSelected(this.member);
  final Member member;
}

final class RemoveSelected extends SelectEvent {
  RemoveSelected(this.member);
  final Member member;
}

final class SelectAll extends SelectEvent {}

final class SelectRange extends SelectEvent {
  final Member memberStart;
  final Member memberEnds;
  SelectRange(this.memberStart, this.memberEnds);
}

final class DeselectAll extends SelectEvent {}

final class InvertSelection extends SelectEvent {}

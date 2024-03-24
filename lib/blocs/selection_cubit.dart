import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/member_model.dart';
import 'package:logging/logging.dart';

final logger = Logger("Selection Cubit");

class SelectionCubit extends Cubit<List<Member>> {
  SelectionCubit(List<Member> members) : super([]) {
    _allMembers = members;
  }

  List<Member> _allMembers = [];



  set members(List<Member> members) {
    _allMembers = members;
    emit([]);
  }

  void changeSelect(Member member) => isSelected(member) ? removeFromList(member) : addToList(member);
  void addToList(Member member) => emit(state.toList()..add(member));
  void removeFromList(Member member) => emit(state.toList()..remove(member));
  void selectRange() => emit(_allMembers.getRange(index(state.first), index(state.last) + 1).toList());
  void selectAll() => emit(_allMembers);
  void clearSelections() => emit([]);

  void doSomethingAboutSelectedMembers(void Function(Member member) function) {
    for (var element in state) {
      function(element);
    }
  }

  bool isSelected(Member member) => state.contains(member);
  bool get allSelected => state.length == _allMembers.length;
  int index(Member member) => _allMembers.indexWhere((element) => element.id == member.id);
}

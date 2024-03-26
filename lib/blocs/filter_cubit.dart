import 'package:flutter_bloc/flutter_bloc.dart';
import '.././models/member_model.dart';
import 'package:logging/logging.dart';

final logger = Logger("Filter Cubit");

class FilterCubit extends Cubit<List<Member>> {
  FilterCubit(List<Member> members) : super(members) {
    _allMembers = members;
  }
  List<Member> _allMembers = [];

  dynamic _status;
  String _string = '';

  String get string => _string;
  dynamic get status => _status;

  set members(List<Member> members) {
    _allMembers = members;
    emit(_allMembers);
  }

  void statusFilter(dynamic status) {
    _status == status ? _status = null : _status = status;
    if (_status == null) return emit(_allMembers);
    emit(_allMembers
        .where((element) =>
            element.siegeStatus == _status ||
            element.mazeData.status == _status)
        .toList());
  }

  void stringFilter(String value) {
    _string = value;
    emit(_allMembers
        .where((e) => _nameContains(e) || _pgrIdContains(e))
        .toList());
    // logger.fine("String Filter: $value | Members : ${state.map((e) => e.name).join(',')}");
  }

  bool _nameContains(Member member) =>
      member.name.toLowerCase().contains(_string);
  bool _pgrIdContains(Member member) =>
      member.pgrId.toString().contains(_string);

  void clearFilter() => emit(_allMembers);
}

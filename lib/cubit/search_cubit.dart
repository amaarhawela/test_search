import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<List<String>> {
  SearchCubit() : super([]);

  String? currentSearch;

  void addSearch(String value) {
    currentSearch = value;
    if (!state.contains(value)) {
      emit([value, ...state]);
    } else {
      final newList = [value, ...state.where((e) => e != value)];
      emit(newList);
    }
  }

  void removeSearch(String value) {
    final newList = List<String>.from(state)..remove(value);
    emit(newList);
    if (currentSearch == value) currentSearch = null;
  }

  void clearAll() {
    emit([]);
    currentSearch = null;
  }

  void clearCurrent() {
    currentSearch = null;
  }
}

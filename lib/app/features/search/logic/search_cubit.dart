// lib/app/features/search/logic/search_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_grad_proj/app/core/errors/app_exception.dart';
import '../data/search_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository repository;

  SearchCubit({required this.repository}) : super(const SearchInitial());

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());
    try {
      final persons = await repository.searchPersons(trimmed);
      if (persons.isEmpty) {
        emit(const SearchEmpty());
      } else {
        emit(SearchLoaded(persons));
      }
    } on AppException catch (e) {
      emit(SearchError(e.message));
    } catch (e) {
      emit(SearchError(AppExceptionHandler.from(e).message));
    }
  }

  void clear() => emit(const SearchInitial());
}

// lib/app/features/persons/logic/persons_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_grad_proj/app/core/errors/app_exception.dart';
import '../data/persons_repository.dart';
import 'persons_state.dart';

class PersonsCubit extends Cubit<PersonsState> {
  final PersonsRepository repository;

  PersonsCubit({required this.repository})
      : super(PersonsInitial());

  Future<void> loadPersons() async {
    emit(PersonsLoading());
    try {
      final persons = await repository.getPopularPersons();
      emit(PersonsLoaded(persons));
    } on AppException catch (e) {
      emit(PersonsError(e.message));
    } catch (e) {
      emit(PersonsError(AppExceptionHandler.from(e).message));
    }
  }
}

// lib/app/features/persons/logic/persons_state.dart
import '../data/models/person_model.dart';

abstract class PersonsState {}

class PersonsInitial extends PersonsState {}

class PersonsLoading extends PersonsState {}

class PersonsLoaded extends PersonsState {
  final List<PersonModel> persons;
  PersonsLoaded(this.persons);
}

class PersonsError extends PersonsState {
  final String message;
  PersonsError(this.message);
}

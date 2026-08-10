// lib/app/features/person_details/logic/person_details_state.dart
import '../data/models/person_details_model.dart';
import '../data/models/person_image_model.dart';

abstract class PersonDetailsState {}

class PersonDetailsInitial extends PersonDetailsState {}

class PersonDetailsLoading extends PersonDetailsState {}

class PersonDetailsLoaded extends PersonDetailsState {
  final PersonDetailsModel details;
  final List<PersonImageModel> images;

  PersonDetailsLoaded({required this.details, required this.images});
}

class PersonDetailsError extends PersonDetailsState {
  final String message;
  PersonDetailsError(this.message);
}

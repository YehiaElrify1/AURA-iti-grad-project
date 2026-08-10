// lib/app/features/person_details/logic/person_details_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_grad_proj/app/core/errors/app_exception.dart';
import '../data/models/person_details_model.dart';
import '../data/models/person_image_model.dart';
import '../data/person_details_repository.dart';
import 'person_details_state.dart';

class PersonDetailsCubit extends Cubit<PersonDetailsState> {
  final PersonDetailsRepository repository;

  PersonDetailsCubit({required this.repository})
      : super(PersonDetailsInitial());

  Future<void> loadDetails(int personId) async {
    emit(PersonDetailsLoading());
    try {
      // Fetch both in parallel for speed
      final results = await Future.wait([
        repository.getPersonDetails(personId),
        repository.getPersonImages(personId),
      ]);

      emit(PersonDetailsLoaded(
        details: results[0] as PersonDetailsModel,
        images: results[1] as List<PersonImageModel>,
      ));
    } on AppException catch (e) {
      emit(PersonDetailsError(e.message));
    } catch (e) {
      emit(PersonDetailsError(AppExceptionHandler.from(e).message));
    }
  }
}

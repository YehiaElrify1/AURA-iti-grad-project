// lib/app/features/person_details/data/person_details_repository.dart
import 'models/person_details_model.dart';
import 'models/person_image_model.dart';

abstract class PersonDetailsRepository {
  Future<PersonDetailsModel> getPersonDetails(int id);
  Future<List<PersonImageModel>> getPersonImages(int id);
}

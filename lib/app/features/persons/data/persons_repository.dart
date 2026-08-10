// lib/app/features/persons/data/persons_repository.dart
import 'models/person_model.dart';

abstract class PersonsRepository {
  Future<List<PersonModel>> getPopularPersons();
}

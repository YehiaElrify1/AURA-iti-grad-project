// lib/app/features/search/data/search_repository.dart
import 'package:iti_grad_proj/app/features/persons/data/models/person_model.dart';

abstract class SearchRepository {
  Future<List<PersonModel>> searchPersons(String query);
}

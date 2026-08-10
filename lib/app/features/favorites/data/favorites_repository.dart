// lib/app/features/favorites/data/favorites_repository.dart
import 'package:iti_grad_proj/app/features/persons/data/models/person_model.dart';

abstract class FavoritesRepository {
  Future<List<PersonModel>> loadFavorites();
  Future<void> saveFavorites(List<PersonModel> persons);
}

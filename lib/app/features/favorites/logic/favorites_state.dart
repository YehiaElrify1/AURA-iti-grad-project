// lib/app/features/favorites/logic/favorites_state.dart
import 'package:iti_grad_proj/app/features/persons/data/models/person_model.dart';

class FavoritesState {
  final Set<int> favoriteIds;
  final List<PersonModel> favoritePersons;

  const FavoritesState({
    this.favoriteIds = const {},
    this.favoritePersons = const [],
  });

  bool isFavorite(int personId) => favoriteIds.contains(personId);

  FavoritesState copyWith({
    Set<int>? favoriteIds,
    List<PersonModel>? favoritePersons,
  }) {
    return FavoritesState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      favoritePersons: favoritePersons ?? this.favoritePersons,
    );
  }
}

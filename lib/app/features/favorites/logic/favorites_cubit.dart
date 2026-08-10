// lib/app/features/favorites/logic/favorites_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_grad_proj/app/features/persons/data/models/person_model.dart';
import '../data/favorites_repository.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repository;

  FavoritesCubit({required this.repository})
      : super(const FavoritesState());

  /// Restores both the full PersonModel list AND the derived ID set on startup.
  Future<void> loadFavorites() async {
    final persons = await repository.loadFavorites();
    final ids = persons.map((p) => p.id).toSet();
    emit(state.copyWith(favoriteIds: ids, favoritePersons: persons));
  }

  /// Optimistic toggle: flips state immediately, then persists full objects.
  Future<void> toggleFavorite(PersonModel person) async {
    final currentIds = Set<int>.from(state.favoriteIds);
    final currentPersons = List<PersonModel>.from(state.favoritePersons);

    if (currentIds.contains(person.id)) {
      currentIds.remove(person.id);
      currentPersons.removeWhere((p) => p.id == person.id);
    } else {
      currentIds.add(person.id);
      currentPersons.add(person);
    }

    emit(state.copyWith(
      favoriteIds: currentIds,
      favoritePersons: currentPersons,
    ));

    // Persist full model list so the next restart can reconstruct everything.
    await repository.saveFavorites(currentPersons);
  }

  bool isFavorite(int personId) => state.isFavorite(personId);
}

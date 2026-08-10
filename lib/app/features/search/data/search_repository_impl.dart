// lib/app/features/search/data/search_repository_impl.dart
import 'package:iti_grad_proj/app/core/errors/app_exception.dart';
import 'package:iti_grad_proj/app/core/services/tmdb_api_service.dart';
import 'package:iti_grad_proj/app/features/persons/data/models/person_model.dart';
import 'search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final TmdbApiService api;

  SearchRepositoryImpl({required this.api});

  @override
  Future<List<PersonModel>> searchPersons(String query) async {
    try {
      final data = await api.get(
        '/search/person',
        extra: {'query': query, 'include_adult': false},
      );
      final results = (data['results'] as List<dynamic>? ?? []);
      return results
          .map((json) => PersonModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppExceptionHandler.from(e);
    }
  }
}

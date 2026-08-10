// lib/app/features/persons/data/persons_repository_impl.dart
import 'package:iti_grad_proj/app/core/errors/app_exception.dart';
import 'package:iti_grad_proj/app/core/services/tmdb_api_service.dart';
import 'models/person_model.dart';
import 'persons_repository.dart';

class PersonsRepositoryImpl implements PersonsRepository {
  final TmdbApiService api;

  PersonsRepositoryImpl({required this.api});

  @override
  Future<List<PersonModel>> getPopularPersons() async {
    try {
      final data = await api.get('/person/popular');
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

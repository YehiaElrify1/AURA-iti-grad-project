// lib/app/features/person_details/data/person_details_repository_impl.dart
import 'package:iti_grad_proj/app/core/errors/app_exception.dart';
import 'package:iti_grad_proj/app/core/services/tmdb_api_service.dart';
import 'models/person_details_model.dart';
import 'models/person_image_model.dart';
import 'person_details_repository.dart';

class PersonDetailsRepositoryImpl implements PersonDetailsRepository {
  final TmdbApiService api;

  PersonDetailsRepositoryImpl({required this.api});

  @override
  Future<PersonDetailsModel> getPersonDetails(int id) async {
    try {
      final data = await api.get('/person/$id');
      return PersonDetailsModel.fromJson(data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppExceptionHandler.from(e);
    }
  }

  @override
  Future<List<PersonImageModel>> getPersonImages(int id) async {
    try {
      final data = await api.get('/person/$id/images');
      final profiles = (data['profiles'] as List<dynamic>? ?? []);
      return profiles
          .map((json) =>
              PersonImageModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppExceptionHandler.from(e);
    }
  }
}

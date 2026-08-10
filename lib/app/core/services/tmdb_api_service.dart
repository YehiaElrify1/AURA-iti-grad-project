// lib/app/core/services/tmdb_api_service.dart
import 'package:dio/dio.dart';
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';
import '../errors/app_exception.dart';

class TmdbApiService {
  late final Dio _dio;

  TmdbApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppStrings.tmdbBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        queryParameters: {'api_key': AppStrings.tmdbApiKey},
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false),
    );
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? extra}) async {
    try {
      final response = await _dio.get(path, queryParameters: extra);
      return response.data;
    } on DioException catch (e) {
      throw AppExceptionHandler.from(e);
    } catch (e) {
      throw AppExceptionHandler.from(e);
    }
  }
}

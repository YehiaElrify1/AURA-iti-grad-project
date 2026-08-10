// lib/app/features/person_details/data/models/person_image_model.dart
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';

class PersonImageModel {
  final String filePath;
  final int width;
  final int height;
  final double voteAverage;

  const PersonImageModel({
    required this.filePath,
    required this.width,
    required this.height,
    required this.voteAverage,
  });

  String get thumbnailUrl => '${AppStrings.tmdbImageBaseUrl}$filePath';
  String get originalUrl => '${AppStrings.tmdbImageOriginalBaseUrl}$filePath';

  factory PersonImageModel.fromJson(Map<String, dynamic> json) {
    return PersonImageModel(
      filePath: (json['file_path'] as String?) ?? '',
      width: (json['width'] as num?)?.toInt() ?? 0,
      height: (json['height'] as num?)?.toInt() ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

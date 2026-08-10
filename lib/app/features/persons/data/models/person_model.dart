// lib/app/features/persons/data/models/person_model.dart
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';

class PersonModel {
  final int id;
  final String name;
  final String? profilePath;
  final double popularity;
  final String knownForDepartment;
  final List<String> knownFor;

  const PersonModel({
    required this.id,
    required this.name,
    this.profilePath,
    required this.popularity,
    required this.knownForDepartment,
    required this.knownFor,
  });

  String? get profileUrl => profilePath != null
      ? '${AppStrings.tmdbImageBaseUrl}$profilePath'
      : null;

  /// Deserialises from both:
  /// 1. Raw TMDB API response — `known_for` is a List of nested objects.
  /// 2. Our persisted format — `known_for` is already a List<String>.
  factory PersonModel.fromJson(Map<String, dynamic> json) {
    final rawKnownFor = json['known_for'] as List<dynamic>? ?? [];

    final knownForList = rawKnownFor.map((item) {
      if (item is String) return item; // persisted flat format
      if (item is Map) return ((item['title'] ?? item['name'] ?? '') as String);
      return '';
    }).where((t) => t.isNotEmpty).toList();

    return PersonModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? 'Unknown',
      profilePath: json['profile_path'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      knownForDepartment:
          (json['known_for_department'] as String?) ?? 'Unknown',
      knownFor: knownForList,
    );
  }

  /// Serialises to our own storage format (flat String list for known_for).
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'profile_path': profilePath,
        'popularity': popularity,
        'known_for_department': knownForDepartment,
        'known_for': knownFor, // List<String> — safe for jsonEncode
      };
}

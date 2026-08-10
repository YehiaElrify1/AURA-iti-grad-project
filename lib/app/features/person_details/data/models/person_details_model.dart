// lib/app/features/person_details/data/models/person_details_model.dart
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';

class PersonDetailsModel {
  final int id;
  final String name;
  final String? biography;
  final String? birthday;
  final String? deathday;
  final String? placeOfBirth;
  final String? profilePath;
  final String? homepage;
  final double popularity;
  final String knownForDepartment;
  final List<String> alsoKnownAs;

  const PersonDetailsModel({
    required this.id,
    required this.name,
    this.biography,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    this.profilePath,
    this.homepage,
    required this.popularity,
    required this.knownForDepartment,
    required this.alsoKnownAs,
  });

  String? get profileUrl => profilePath != null
      ? '${AppStrings.tmdbImageOriginalBaseUrl}$profilePath'
      : null;

  bool get hasUsableBiography =>
      biography != null && biography!.trim().isNotEmpty;

  factory PersonDetailsModel.fromJson(Map<String, dynamic> json) {
    final alsoKnownAs = (json['also_known_as'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    return PersonDetailsModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? 'Unknown',
      biography: json['biography'] as String?,
      birthday: json['birthday'] as String?,
      deathday: json['deathday'] as String?,
      placeOfBirth: json['place_of_birth'] as String?,
      profilePath: json['profile_path'] as String?,
      homepage: json['homepage'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      knownForDepartment:
          (json['known_for_department'] as String?) ?? 'Unknown',
      alsoKnownAs: alsoKnownAs,
    );
  }
}

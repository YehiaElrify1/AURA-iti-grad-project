// lib/app/features/person_details/view/screens/person_details_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iti_grad_proj/app/core/constants/app_colors.dart';
import 'package:iti_grad_proj/app/core/constants/app_spacing.dart';
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';
import 'package:iti_grad_proj/app/core/shared/error_view.dart';
import 'package:iti_grad_proj/app/core/shared/loading_indicator.dart';
import 'package:iti_grad_proj/app/features/person_details/data/models/person_details_model.dart';
import 'package:iti_grad_proj/app/features/person_details/logic/person_details_cubit.dart';
import 'package:iti_grad_proj/app/features/person_details/logic/person_details_state.dart';
import 'package:go_router/go_router.dart';
import 'package:iti_grad_proj/app/features/favorites/logic/favorites_cubit.dart';
import 'package:iti_grad_proj/app/features/favorites/logic/favorites_state.dart';
import 'package:iti_grad_proj/app/features/persons/data/models/person_model.dart';
import '../widgets/person_image_grid.dart';

class PersonDetailsScreen extends StatefulWidget {
  final int personId;
  final String? personName;

  const PersonDetailsScreen({
    super.key,
    required this.personId,
    this.personName,
  });

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PersonDetailsCubit>().loadDetails(widget.personId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonDetailsCubit, PersonDetailsState>(
      builder: (context, state) {
        return Scaffold(
          body: switch (state) {
            PersonDetailsLoading() || PersonDetailsInitial() =>
              _loadingScaffold(),
            PersonDetailsError(:final message) => _errorScaffold(message),
            PersonDetailsLoaded(:final details, :final images) =>
              _buildContent(context, details, images),
            _ => _loadingScaffold(),
          },
        );
      },
    );
  }

  Widget _loadingScaffold() => Scaffold(
        appBar: AppBar(title: Text(widget.personName ?? '')),
        body: const LoadingIndicator(),
      );

  Widget _errorScaffold(String message) => Scaffold(
        appBar: AppBar(title: Text(widget.personName ?? '')),
        body: ErrorView(
          message: message,
          onRetry: () =>
              context.read<PersonDetailsCubit>().loadDetails(widget.personId),
        ),
      );

  Widget _buildContent(
    BuildContext context,
    PersonDetailsModel details,
    images,
  ) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        // ── Expandable header image ───────────────────────────────────────
        SliverAppBar(
          expandedHeight: 340.h,
          pinned: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          // White icons look good against the photo when expanded;
          iconTheme: const IconThemeData(color: Colors.white),
          
          leading: Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          
          actions: [
            Container(
              margin: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  final isFavorite = state.favoriteIds.contains(details.id);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 22.sp,
                      color: isFavorite ? AppColors.favoriteRed : Colors.white,
                    ),
                    onPressed: () {
                      final personModel = PersonModel(
                        id: details.id,
                        name: details.name,
                        profilePath: details.profilePath,
                        popularity: details.popularity,
                        knownForDepartment: details.knownForDepartment,
                        knownFor: details.alsoKnownAs.take(3).toList(),
                      );
                      context.read<FavoritesCubit>().toggleFavorite(personModel);
                    },
                  );
                },
              ),
            ),
            SizedBox(width: AppSpacing.h8),
          ],

          // No SliverAppBar.title here — FlexibleSpaceBar.title handles
          // both the expanded (bottom-left) and collapsed (top-center) states.
          flexibleSpace: FlexibleSpaceBar(
            // start: 72.w clears the back-button in both expanded and
            // collapsed states; FlexibleSpaceBar animates between them.
            titlePadding: EdgeInsetsDirectional.only(
              start: 72.w,
              bottom: 16.h,
              end: 16.w,
            ),
            title: Text(
              details.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Profile photo
                details.profileUrl != null
                    ? CachedNetworkImage(
                        imageUrl: details.profileUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        errorWidget: (_, _, _) => _placeholderAvatar(theme),
                      )
                    : _placeholderAvatar(theme),
                // Gradient scrim — transparent at top, dark at bottom
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.45, 0.75, 1.0],
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.45),
                        Colors.black.withValues(alpha: 0.80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Details body ─────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.h20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Known For badge
                _DepartmentBadge(department: details.knownForDepartment),
                SizedBox(height: AppSpacing.v16),

                // Quick info row
                _InfoRow(details: details),
                SizedBox(height: AppSpacing.v24),

                // Biography
                _SectionTitle(AppStrings.biography),
                SizedBox(height: AppSpacing.v8),
                Text(
                  details.hasUsableBiography
                      ? details.biography!
                      : AppStrings.noBiography,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                    color: details.hasUsableBiography
                        ? null
                        : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                SizedBox(height: AppSpacing.v24),

                // Also Known As
                if (details.alsoKnownAs.isNotEmpty) ...[
                  _SectionTitle(AppStrings.alsoKnownAs),
                  SizedBox(height: AppSpacing.v8),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: details.alsoKnownAs
                        .take(6)
                        .map((name) => _Chip(name))
                        .toList(),
                  ),
                  SizedBox(height: AppSpacing.v24),
                ],

                // Photos section header
                _SectionTitle(AppStrings.photos),
                SizedBox(height: AppSpacing.v12),
                if (images.isEmpty)
                  Text(
                    AppStrings.noImages,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  )
                else
                  PersonImageGrid(images: images),

                SizedBox(height: AppSpacing.v40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholderAvatar(ThemeData theme) => Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.person_rounded,
          size: 80.sp,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      );
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _DepartmentBadge extends StatelessWidget {
  final String department;
  const _DepartmentBadge({required this.department});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.lightPrimary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.circle),
        border: Border.all(color: AppColors.lightPrimary.withValues(alpha: 0.3)),
      ),
      child: Text(
        department,
        style: TextStyle(
          color: AppColors.lightPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final PersonDetailsModel details;
  const _InfoRow({required this.details});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = <({IconData icon, String label, String? value})>[
      (icon: Icons.cake_rounded, label: AppStrings.birthday, value: details.birthday),
      (icon: Icons.location_on_rounded, label: AppStrings.placeOfBirth, value: details.placeOfBirth),
      if (details.deathday != null)
        (icon: Icons.sentiment_very_dissatisfied_rounded, label: AppStrings.deathday, value: details.deathday),
      (icon: Icons.star_rounded, label: AppStrings.popularity, value: details.popularity.toStringAsFixed(1)),
    ].where((item) => item.value != null).toList();

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.v8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.icon,
                      size: 16.sp,
                      color: theme.colorScheme.primary.withValues(alpha: 0.8)),
                  SizedBox(width: AppSpacing.h8),
                  Text(
                    '${item.label}:  ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.value!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.circle),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.sp),
      ),
    );
  }
}

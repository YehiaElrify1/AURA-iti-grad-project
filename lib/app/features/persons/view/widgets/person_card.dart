// lib/app/features/persons/view/widgets/person_card.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iti_grad_proj/app/core/constants/app_colors.dart';
import 'package:iti_grad_proj/app/core/constants/app_spacing.dart';
import 'package:iti_grad_proj/app/features/favorites/logic/favorites_cubit.dart';
import 'package:iti_grad_proj/app/features/favorites/logic/favorites_state.dart';
import 'package:iti_grad_proj/app/features/persons/data/models/person_model.dart';
import 'package:shimmer/shimmer.dart';

class PersonCard extends StatelessWidget {
  final PersonModel person;
  final VoidCallback onTap;

  const PersonCard({super.key, required this.person, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile image
              Expanded(
                flex: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(person.profileUrl),
                    // Favorite button — top right
                    Positioned(
                      top: 6.h,
                      right: 6.w,
                      child: _FavoriteButton(person: person),
                    ),
                    // Department badge — bottom left
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.h8, vertical: AppSpacing.v4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.75),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Text(
                          person.knownForDepartment,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                            fontSize: 10.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Name
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.h8, vertical: AppSpacing.v8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        person.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (person.knownFor.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          person.knownFor.take(2).join(', '),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10.sp,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.55),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? url) {
    if (url == null) {
      return Container(
        color: Colors.grey.shade300,
        child: Icon(Icons.person_rounded,
            size: 60.sp, color: Colors.grey.shade500),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(color: Colors.grey.shade300),
      ),
      errorWidget: (_, _, _) => Container(
        color: Colors.grey.shade300,
        child: Icon(Icons.broken_image_rounded,
            size: 40.sp, color: Colors.grey.shade500),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final PersonModel person;
  const _FavoriteButton({required this.person});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final isFav = state.isFavorite(person.id);
        return GestureDetector(
          onTap: () =>
              context.read<FavoritesCubit>().toggleFavorite(person),
          child: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? AppColors.favoriteRed : Colors.white,
              size: 18.sp,
            ),
          ),
        );
      },
    );
  }
}

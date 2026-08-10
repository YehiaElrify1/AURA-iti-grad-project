// lib/app/features/favorites/view/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iti_grad_proj/app/core/constants/app_colors.dart';
import 'package:iti_grad_proj/app/core/constants/app_spacing.dart';
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';
import 'package:iti_grad_proj/app/features/favorites/logic/favorites_cubit.dart';
import 'package:iti_grad_proj/app/features/favorites/logic/favorites_state.dart';
import 'package:iti_grad_proj/app/features/persons/view/widgets/person_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.favoritesTitle,
            style: theme.appBarTheme.titleTextStyle),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.favoritePersons.isEmpty) {
            return _EmptyFavorites();
          }

          return GridView.builder(
            padding: EdgeInsets.all(AppSpacing.h16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.h12,
              mainAxisSpacing: AppSpacing.v12,
              childAspectRatio: 0.62,
            ),
            itemCount: state.favoritePersons.length,
            itemBuilder: (_, index) {
              final person = state.favoritePersons[index];
              return PersonCard(
                person: person,
                onTap: () => context.push(
                  '/person/${person.id}',
                  extra: person.name,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 72.sp,
            color: AppColors.favoriteRed.withValues(alpha: 0.3),
          ),
          SizedBox(height: AppSpacing.v16),
          Text(
            AppStrings.noFavorites,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

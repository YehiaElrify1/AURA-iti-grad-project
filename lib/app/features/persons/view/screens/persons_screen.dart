import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iti_grad_proj/app/core/constants/app_colors.dart';
import 'package:iti_grad_proj/app/core/constants/app_spacing.dart';
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';
import 'package:iti_grad_proj/app/core/routing/app_router.dart';
import 'package:iti_grad_proj/app/core/shared/error_view.dart';
import 'package:iti_grad_proj/app/features/favorites/logic/favorites_cubit.dart';
import 'package:iti_grad_proj/app/features/favorites/logic/favorites_state.dart';
import 'package:iti_grad_proj/app/features/persons/logic/persons_cubit.dart';
import 'package:iti_grad_proj/app/features/persons/logic/persons_state.dart';
import '../widgets/person_card.dart';

class PersonsScreen extends StatefulWidget {
  const PersonsScreen({super.key});

  @override
  State<PersonsScreen> createState() => _PersonsScreenState();
}

class _PersonsScreenState extends State<PersonsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PersonsCubit>().loadPersons();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppStrings.appName,
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.search_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8)),
          onPressed: () => context.push(AppRouter.search),
        ),
        actions: [
          _FavoritesBadge(
            onTap: () => context.push(AppRouter.favorites),
          ),
          SizedBox(width: AppSpacing.h12),
        ],
      ),
      body: BlocBuilder<PersonsCubit, PersonsState>(
        builder: (context, state) {
          if (state is PersonsLoading || state is PersonsInitial) {
            return _buildShimmerGrid();
          }
          if (state is PersonsError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<PersonsCubit>().loadPersons(),
            );
          }
          if (state is PersonsLoaded) {
            return GridView.builder(
              padding: EdgeInsets.all(AppSpacing.h16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.h12,
                mainAxisSpacing: AppSpacing.v12,
                childAspectRatio: 0.62,
              ),
              itemCount: state.persons.length,
              itemBuilder: (context, index) {
                final person = state.persons[index];
                return PersonCard(
                  person: person,
                  onTap: () => context.push(
                    '/person/${person.id}',
                    extra: person.name,
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(AppSpacing.h16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.h12,
        mainAxisSpacing: AppSpacing.v12,
        childAspectRatio: 0.62,
      ),
      itemCount: 10,
      itemBuilder: (_, _) => const _ShimmerCard(),
    );
  }
}

class _FavoritesBadge extends StatelessWidget {
  final VoidCallback onTap;
  const _FavoritesBadge({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final count = state.favoriteIds.length;
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.favorite_rounded),
              color: count > 0
                  ? AppColors.favoriteRed
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
              onPressed: onTap,
            ),
            if (count > 0)
              Positioned(
                top: 8.h,
                right: 6.w,
                child: Container(
                  padding: EdgeInsets.all(3.r),
                  decoration: const BoxDecoration(
                    color: AppColors.favoriteRed,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    count > 9 ? '9+' : count.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg)),
              child: _ShimmerBox(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.h8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ShimmerBox(height: 12.h, width: 100.w),
                  SizedBox(height: 6.h),
                  _ShimmerBox(height: 10.h, width: 70.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double? height;
  final double? width;
  const _ShimmerBox({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}

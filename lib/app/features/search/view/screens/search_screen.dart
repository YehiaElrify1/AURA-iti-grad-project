// lib/app/features/search/view/screens/search_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iti_grad_proj/app/core/constants/app_colors.dart';
import 'package:iti_grad_proj/app/core/constants/app_spacing.dart';
import 'package:iti_grad_proj/app/core/constants/app_strings.dart';
import 'package:iti_grad_proj/app/core/routing/app_router.dart';
import 'package:iti_grad_proj/app/features/persons/view/widgets/person_card.dart';
import 'package:iti_grad_proj/app/features/search/logic/search_cubit.dart';
import 'package:iti_grad_proj/app/features/search/logic/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      context.read<SearchCubit>().search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68.h,
        leadingWidth: 48.w,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(right: AppSpacing.h16),
          child: TextField(
            controller: _controller,
            autofocus: true,
            onChanged: _onChanged,
            style: theme.textTheme.bodyMedium,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: AppStrings.searchHint,
              isDense: true,
              filled: true,
              fillColor: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 12.h,
              ),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (_, value, _) {
                  if (value.text.isEmpty) return const SizedBox.shrink();
                  return IconButton(
                    icon: Icon(Icons.close_rounded, size: 18.sp),
                    onPressed: () {
                      _controller.clear();
                      context.read<SearchCubit>().clear();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return switch (state) {
            SearchInitial() => _buildInitialHint(theme),
            SearchLoading() => _buildShimmerGrid(isDark),
            SearchLoaded(:final persons) => GridView.builder(
                padding: EdgeInsets.all(AppSpacing.h16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.h12,
                  mainAxisSpacing: AppSpacing.v12,
                  childAspectRatio: 0.62,
                ),
                itemCount: persons.length,
                itemBuilder: (context, index) {
                  final person = persons[index];
                  return PersonCard(
                    person: person,
                    onTap: () => context.push(
                      '/person/${person.id}',
                      extra: person.name,
                    ),
                  );
                },
              ),
            SearchEmpty() => _buildEmptyState(theme),
            SearchError(:final message) => _buildErrorState(theme, message),
          };
        },
      ),
    );
  }

  Widget _buildInitialHint(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.manage_search_rounded,
            size: 72.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
          ),
          SizedBox(height: AppSpacing.v16),
          Text(
            AppStrings.searchInitialHint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 72.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
          ),
          SizedBox(height: AppSpacing.v16),
          Text(
            AppStrings.searchNoResults,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.h32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded,
                size: 60.sp,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
            SizedBox(height: AppSpacing.v16),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid(bool isDark) {
    return GridView.builder(
      padding: EdgeInsets.all(AppSpacing.h16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.h12,
        mainAxisSpacing: AppSpacing.v12,
        childAspectRatio: 0.62,
      ),
      itemCount: 8,
      itemBuilder: (_, _) => _ShimmerCard(isDark: isDark),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final bool isDark;
  const _ShimmerCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
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
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
              child: Container(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              ),
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
                  Container(
                    height: 12.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    height: 10.h,
                    width: 70.w,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

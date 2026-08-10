// lib/my_app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iti_grad_proj/app/core/routing/app_router.dart';
import 'package:iti_grad_proj/app/core/services/gemini_service.dart';
import 'package:iti_grad_proj/app/core/services/tmdb_api_service.dart';
import 'package:iti_grad_proj/app/core/theme/app_theme.dart';
import 'package:iti_grad_proj/app/core/theme/theme_cubit.dart';
import 'package:iti_grad_proj/app/features/chatbot/logic/chatbot_cubit.dart';
import 'package:iti_grad_proj/app/features/favorites/data/favorites_repository.dart';
import 'package:iti_grad_proj/app/features/favorites/data/favorites_repository_impl.dart';
import 'package:iti_grad_proj/app/features/favorites/logic/favorites_cubit.dart';
import 'package:iti_grad_proj/app/features/person_details/data/person_details_repository.dart';
import 'package:iti_grad_proj/app/features/person_details/data/person_details_repository_impl.dart';
import 'package:iti_grad_proj/app/features/person_details/logic/person_details_cubit.dart';
import 'package:iti_grad_proj/app/features/persons/data/persons_repository.dart';
import 'package:iti_grad_proj/app/features/persons/data/persons_repository_impl.dart';
import 'package:iti_grad_proj/app/features/persons/logic/persons_cubit.dart';
import 'package:iti_grad_proj/app/features/search/data/search_repository.dart';
import 'package:iti_grad_proj/app/features/search/data/search_repository_impl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/core/constants/app_strings.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) {
        return MultiProvider(
          providers: [
            // ── Singleton services ────────────────────────────────────
            Provider<TmdbApiService>(create: (_) => TmdbApiService()),
            Provider<GeminiService>(create: (_) => GeminiService()),

            // ── Repositories ──────────────────────────────────────────
            Provider<PersonsRepository>(
              create: (ctx) => PersonsRepositoryImpl(
                api: ctx.read<TmdbApiService>(),
              ),
            ),
            Provider<PersonDetailsRepository>(
              create: (ctx) => PersonDetailsRepositoryImpl(
                api: ctx.read<TmdbApiService>(),
              ),
            ),
            Provider<FavoritesRepository>(
              create: (_) => FavoritesRepositoryImpl(prefs: prefs),
            ),
            // SearchRepository available globally so AppRouter can read it
            Provider<SearchRepository>(
              create: (ctx) => SearchRepositoryImpl(
                api: ctx.read<TmdbApiService>(),
              ),
            ),

            // ── Cubits ────────────────────────────────────────────────
            BlocProvider<ThemeCubit>(
              create: (_) => ThemeCubit(prefs),
            ),
            BlocProvider<PersonsCubit>(
              create: (ctx) => PersonsCubit(
                repository: ctx.read<PersonsRepository>(),
              ),
            ),
            BlocProvider<PersonDetailsCubit>(
              create: (ctx) => PersonDetailsCubit(
                repository: ctx.read<PersonDetailsRepository>(),
              ),
            ),
            BlocProvider<FavoritesCubit>(
              create: (ctx) =>
                  FavoritesCubit(repository: ctx.read<FavoritesRepository>())
                    ..loadFavorites(),
            ),
            BlocProvider<ChatbotCubit>(
              create: (ctx) => ChatbotCubit(
                gemini: ctx.read<GeminiService>(),
              ),
            ),
          ],
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (_, themeMode) {
              return MaterialApp.router(
                title: AppStrings.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                routerConfig: AppRouter.router,
              );
            },
          ),
        );
      },
    );
  }
}

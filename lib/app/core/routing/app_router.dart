// lib/app/core/routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iti_grad_proj/app/features/chatbot/view/screens/chatbot_screen.dart';
import 'package:iti_grad_proj/app/features/favorites/view/screens/favorites_screen.dart';
import 'package:iti_grad_proj/app/features/image_viewer/view/screens/image_viewer_screen.dart';
import 'package:iti_grad_proj/app/features/layout/view/screens/main_layout_screen.dart';
import 'package:iti_grad_proj/app/features/onboarding/view/screens/onboarding_screen.dart';
import 'package:iti_grad_proj/app/features/person_details/view/screens/person_details_screen.dart';
import 'package:iti_grad_proj/app/features/persons/view/screens/persons_screen.dart';
import 'package:iti_grad_proj/app/features/search/data/search_repository.dart';
import 'package:iti_grad_proj/app/features/search/data/search_repository_impl.dart';
import 'package:iti_grad_proj/app/features/search/logic/search_cubit.dart';
import 'package:iti_grad_proj/app/features/search/view/screens/search_screen.dart';
import 'package:iti_grad_proj/app/features/splash/view/screens/splash_screen.dart';
import 'package:provider/provider.dart';

class AppRouter {
  AppRouter._();

  // Route paths
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String personDetails = '/person/:id';
  static const String imageViewer = '/image-viewer';
  static const String favorites = '/favorites';
  static const String search = '/search';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (_, _) => const MainLayoutScreen(),
      ),
      GoRoute(
        path: '/person/:id',
        name: 'person-details',
        builder: (_, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final name = state.extra as String?;
          return PersonDetailsScreen(personId: id, personName: name);
        },
      ),
      GoRoute(
        path: imageViewer,
        name: 'image-viewer',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ImageViewerScreen(
            imageUrl: extra['imageUrl'] as String,
            heroTag: extra['heroTag'] as String? ?? 'image',
          );
        },
      ),
      GoRoute(
        path: favorites,
        name: 'favorites',
        builder: (_, _) => const FavoritesScreen(),
      ),
      GoRoute(
        path: search,
        name: 'search',
        // SearchCubit is route-scoped — created fresh on each navigation
        builder: (context, _) => BlocProvider(
          create: (_) => SearchCubit(
            repository: SearchRepositoryImpl(
              api: context.read(),
            ),
          ),
          child: const SearchScreen(),
        ),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  );
}

#!/usr/bin/env bash
# scaffold.sh — Creates the full AURA folder & file skeleton
# Run from project root: bash scaffold.sh

set -e

echo "🚀  Scaffolding AURA folder structure..."

# ── Core / Constants ────────────────────────────────────────────────
mkdir -p lib/app/core/constants
touch lib/app/core/constants/app_colors.dart
touch lib/app/core/constants/app_spacing.dart
touch lib/app/core/constants/app_strings.dart

# ── Core / Errors ────────────────────────────────────────────────────
mkdir -p lib/app/core/errors
touch lib/app/core/errors/app_exception.dart

# ── Core / Theme ─────────────────────────────────────────────────────
mkdir -p lib/app/core/theme
touch lib/app/core/theme/app_theme.dart

# ── Core / Services ──────────────────────────────────────────────────
mkdir -p lib/app/core/services
touch lib/app/core/services/tmdb_api_service.dart
touch lib/app/core/services/gemini_service.dart

# ── Core / Shared ────────────────────────────────────────────────────
mkdir -p lib/app/core/shared
touch lib/app/core/shared/loading_indicator.dart
touch lib/app/core/shared/error_view.dart
touch lib/app/core/shared/main_button.dart

# ── Core / Routing ───────────────────────────────────────────────────
mkdir -p lib/app/core/routing
touch lib/app/core/routing/app_router.dart

# ── Feature: persons (Home) ──────────────────────────────────────────
mkdir -p lib/app/features/persons/data/models
touch lib/app/features/persons/data/models/person_model.dart
touch lib/app/features/persons/data/persons_repository.dart
touch lib/app/features/persons/data/persons_repository_impl.dart

mkdir -p lib/app/features/persons/logic
touch lib/app/features/persons/logic/persons_cubit.dart
touch lib/app/features/persons/logic/persons_state.dart

mkdir -p lib/app/features/persons/view/screens
mkdir -p lib/app/features/persons/view/widgets
touch lib/app/features/persons/view/screens/persons_screen.dart
touch lib/app/features/persons/view/widgets/person_card.dart

# ── Feature: person_details ──────────────────────────────────────────
mkdir -p lib/app/features/person_details/data/models
touch lib/app/features/person_details/data/models/person_details_model.dart
touch lib/app/features/person_details/data/models/person_image_model.dart
touch lib/app/features/person_details/data/person_details_repository.dart
touch lib/app/features/person_details/data/person_details_repository_impl.dart

mkdir -p lib/app/features/person_details/logic
touch lib/app/features/person_details/logic/person_details_cubit.dart
touch lib/app/features/person_details/logic/person_details_state.dart

mkdir -p lib/app/features/person_details/view/screens
mkdir -p lib/app/features/person_details/view/widgets
touch lib/app/features/person_details/view/screens/person_details_screen.dart
touch lib/app/features/person_details/view/widgets/person_image_grid.dart

# ── Feature: image_viewer ────────────────────────────────────────────
mkdir -p lib/app/features/image_viewer/view/screens
touch lib/app/features/image_viewer/view/screens/image_viewer_screen.dart

# ── Feature: chatbot ─────────────────────────────────────────────────
mkdir -p lib/app/features/chatbot/data
touch lib/app/features/chatbot/data/chat_message.dart

mkdir -p lib/app/features/chatbot/logic
touch lib/app/features/chatbot/logic/chatbot_cubit.dart
touch lib/app/features/chatbot/logic/chatbot_state.dart

mkdir -p lib/app/features/chatbot/view/screens
mkdir -p lib/app/features/chatbot/view/widgets
touch lib/app/features/chatbot/view/screens/chatbot_screen.dart
touch lib/app/features/chatbot/view/widgets/chat_bubble.dart
touch lib/app/features/chatbot/view/widgets/chat_input.dart

# ── Feature: favorites ───────────────────────────────────────────────
mkdir -p lib/app/features/favorites/data
touch lib/app/features/favorites/data/favorites_repository.dart
touch lib/app/features/favorites/data/favorites_repository_impl.dart

mkdir -p lib/app/features/favorites/logic
touch lib/app/features/favorites/logic/favorites_cubit.dart
touch lib/app/features/favorites/logic/favorites_state.dart

mkdir -p lib/app/features/favorites/view/screens
touch lib/app/features/favorites/view/screens/favorites_screen.dart

# ── Root app files ───────────────────────────────────────────────────
touch lib/my_app.dart

# ── Environment files ────────────────────────────────────────────────
touch .env
touch .env.example

echo ""
echo "✅  Done! Folder structure created."
echo ""
echo "📁  lib/"
find lib/app -type f -name "*.dart" | sort | sed 's/^/   /'
echo ""
echo "📄  Root: .env  |  .env.example"
echo ""
echo "⚠️   Next step: run 'flutter pub get' after pubspec.yaml is updated."

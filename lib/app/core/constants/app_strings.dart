// lib/app/core/constants/app_strings.dart

class AppStrings {
  AppStrings._();

  // App identity
  static const String appName = 'AURA';
  static const String appTagline = 'Discover the World\'s Most Popular People';

  // TMDB
  static const String tmdbApiKey = '2dfe23358236069710a379edd4c65a6b';
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String tmdbImageOriginalBaseUrl = 'https://image.tmdb.org/t/p/original';

  // SharedPreferences keys
  static const String prefIsFirstTime = 'is_first_time';
  static const String prefThemeMode = 'theme_mode';

  // Screens
  static const String homeTitle = 'Popular People';
  static const String favoritesTitle = 'My Favorites';
  static const String chatbotTitle = 'AURA AI';
  static const String chatbotSubtitle = 'Online';
  static const String imageViewerTitle = 'Photo';
  static const String searchTitle = 'Search People';
  static const String settingsTitle = 'Settings';

  // Chatbot
  static const String chatbotWelcome =
      "Hello! I'm AURA AI, your smart assistant.\nAsk me anything — I'm here to help 🌟";
  static const String chatbotHint = 'Ask me anything...';
  static const String chatbotSend = 'Send';

  // Errors & feedback
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'No internet connection. Please check your network.';
  static const String retry = 'Retry';
  static const String noFavorites = 'No favorites yet.\nTap ♡ on a person to add them here.';
  static const String noBiography = 'No biography available.';
  static const String noImages = 'No images available.';
  static const String downloading = 'Downloading...';
  static const String downloadSuccess = 'Image saved to gallery!';
  static const String downloadError = 'Could not save image.';
  static const String permissionDenied = 'Storage permission is required to save images.';

  // Person details labels
  static const String biography = 'Biography';
  static const String knownFor = 'Known For';
  static const String birthday = 'Birthday';
  static const String deathday = 'Deathday';
  static const String placeOfBirth = 'Place of Birth';
  static const String popularity = 'Popularity';
  static const String photos = 'Photos';
  static const String alsoKnownAs = 'Also Known As';

  // Search
  static const String searchHint = 'Search for a person...';
  static const String searchInitialHint = 'Type a name to discover someone.';
  static const String searchNoResults = 'No results found.\nTry a different name.';

  // Theme / Settings
  static const String darkMode = 'Dark Mode';
  static const String lightMode = 'Light Mode';
  static const String appearance = 'Appearance';
}

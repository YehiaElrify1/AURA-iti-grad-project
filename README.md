<div align="center">
  <img src="https://raw.githubusercontent.com/YehiaElrify1/AURA-iti-grad-project/main/web/icons/Icon-192.png" width="120" alt="AURA Logo">
  <h1>AURA</h1>
  <p><strong>Discover the world's most popular people, powered by TMDB and Google Gemini AI.</strong></p>

  <p>
    <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter" />
    <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
    <img src="https://img.shields.io/badge/TMDB-01B4E4.svg?style=for-the-badge&logo=TheMovieDatabase&logoColor=white" alt="TMDB" />
    <img src="https://img.shields.io/badge/Gemini_AI-1A73E8.svg?style=for-the-badge&logo=google&logoColor=white" alt="Gemini" />
  </p>
</div>

<br/>

## 🎥 App Demo
<div align="center">
  <a href="https://youtu.be/oOrGkUUvg4I">
    <img src="https://img.youtube.com/vi/oOrGkUUvg4I/0.jpg" alt="Watch AURA App Demo on YouTube" width="350" style="border-radius: 10px;">
  </a>
  <p><em>Click on photo to see video on youtube</em></p>
</div>

---

## About AURA

**AURA** is a premium Flutter application designed as a graduation project for ITI. It provides a gorgeous, modern interface to browse, search, and discover the most popular people in the entertainment industry using the **TMDB (The Movie Database) API**. 

Going beyond a standard directory, AURA integrates a smart **AI Chatbot powered by Google Gemini**, allowing users to ask deep contextual questions about actors, movies, and pop culture directly within the app.

---

## Key Features

*   **Popular People Feed**: Browse trending and popular individuals seamlessly.
*   **Smart Search**: Find actors and directors instantly with a debounced, premium search UI.
*   **Deep Profiles**: View comprehensive biographies, birthdates, popularity metrics, and their known works.
*   **High-Res Photo Gallery**: Browse high-quality images and directly save them to your device's native Gallery.
*   **Favorites System**: Save your favorite people locally for quick access anytime (persisted via SharedPreferences).
*   **AURA AI Chat**: An intelligent, context-aware chatbot powered by the **Google Gemini API**.
*   **Dynamic Theming**: Flawless Dark and Light mode support with glassmorphism and modern micro-animations.
*   **Responsive Design**: Built using `flutter_screenutil` to ensure perfect rendering across all device sizes.

---

## Architecture & Tech Stack

AURA is built with scale and maintainability in mind, strictly adhering to **Feature-First Architecture** and **Clean Code** principles.

*   **Framework**: Flutter (Dart)
*   **State Management**: `flutter_bloc` (Cubit)
*   **Networking**: `dio`
*   **Routing**: `go_router`
*   **Local Storage**: `shared_preferences`
*   **Image Caching**: `cached_network_image` & `photo_view`
*   **Native Integrations**: `gal` (Gallery Saving) & `permission_handler`
*   **AI Integration**: `google_generative_ai`

---

## Getting Started

### Prerequisites
*   Flutter SDK (v3.12.2 or higher)
*   A valid [TMDB API Key](https://developer.themoviedb.org/docs)
*   A valid [Google Gemini API Key](https://aistudio.google.com/)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/YehiaElrify1/AURA-iti-grad-project.git
    cd AURA-iti-grad-project
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Environment Setup:**
    Create a `.env` file in the root directory based on the provided `.env.example`:
    ```env
    GEMINI_API_KEY=your_gemini_api_key_here
    ```

4.  **Run the app:**
    ```bash
    flutter run
    ```

---

## Project Structure

```text
lib/
├── main.dart
├── my_app.dart
└── app/
    ├── core/                # Core configurations, constants, theme, routing, error handling
    └── features/            # Feature-driven modules
        ├── chatbot/         # Gemini AI Chatbot UI & Logic
        ├── favorites/       # Local Favorites persistence
        ├── image_viewer/    # Photo gallery and native download
        ├── layout/          # Main Bottom Navigation scaffold
        ├── onboarding/      # App introductory screens
        ├── person_details/  # Deep dive profile screens
        ├── persons/         # Main popular feed
        ├── search/          # Search functionality
        ├── settings/        # Theme toggles & App Info
        └── splash/          # Splash Screen animations
```

---

## Acknowledgments
*   Developed as a graduation project for the **Information Technology Institute (ITI)**.
*   Data provided by [TMDB](https://www.themoviedb.org/).
*   AI capabilities powered by Google DeepMind's Gemini.

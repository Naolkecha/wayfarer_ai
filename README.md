# Wayfarer AI 🌍✈️

**Intelligent Cross-Platform Trip Planner & Itinerary Architect**

A Flutter-based mobile application that leverages Large Language Models (LLMs) to generate hyper-personalized, day-by-day travel itineraries with interactive mapping, real-time budget tracking, and offline PDF exports.

## 🎯 Features

### Core Features
- ✅ **AI-Powered Itinerary Generation** - Gemini 2.5 Flash API with live streaming
- ✅ **Firebase Authentication** - Secure email/password sign-in
- ✅ **Local Trip Storage** - Save and manage trips offline with Hive
- ✅ **Budget Tracking** - Real-time expense management
- ✅ **Offline PDF Export** - Beautiful, professional itineraries
- ✅ **Modern UI/UX** - Glassmorphism, gradients, and smooth animations
- ✅ **Clean Architecture** - Maintainable, testable codebase

### Technical Highlights
- **State Management**: Riverpod for reactive state
- **Navigation**: GoRouter for declarative routing
- **Local Storage**: Hive for fast offline access
- **API Integration**: Retrofit + Dio for networking
- **Code Generation**: Freezed for immutable models

## 📁 Project Structure

```
wayfarer_ai/
├── lib/
│   ├── core/
│   │   ├── constants/       # App-wide constants
│   │   ├── theme/           # Theme configuration
│   │   ├── utils/           # Utility functions
│   │   └── widgets/         # Reusable widgets
│   │
│   ├── domain/              # Business Logic Layer
│   │   ├── entities/        # Domain models
│   │   └── repositories/    # Repository interfaces
│   │
│   ├── data/                # Data Layer
│   │   ├── models/          # Data models (JSON serializable)
│   │   ├── datasources/     # API & local data sources
│   │   └── repositories/    # Repository implementations
│   │
│   ├── presentation/        # UI Layer
│   │   ├── screens/         # App screens
│   │   └── widgets/         # Screen-specific widgets
│   │
│   ├── providers/           # Riverpod providers
│   └── main.dart            # App entry point
│
├── pubspec.yaml             # Dependencies
└── README.md                # This file
```

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.16.0 or higher
- **Dart SDK**: 3.2.0 or higher
- **Android Studio** / **VS Code** with Flutter extensions
- **Firebase Account** (for authentication and database)
- **Google Cloud Account** (for Maps and Gemini API)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd wayfarer_ai
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Set up Firebase**
   - Create a new Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Add Android and iOS apps to your project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the respective platform folders

4. **Configure API Keys**

Create a file `lib/core/constants/api_keys.dart`:
```dart
class ApiKeys {
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String openWeatherApiKey = 'YOUR_OPENWEATHER_API_KEY';
}
```

**Get your API keys:**
- **Gemini API**: [ai.google.dev](https://ai.google.dev/)
- **Google Maps**: [console.cloud.google.com](https://console.cloud.google.com/)
- **OpenWeather**: [openweathermap.org/api](https://openweathermap.org/api)

5. **Run code generation**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

6. **Run the app**
```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Chrome (web)
flutter run -d chrome
```

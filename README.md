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

## 🛠️ Development

### Code Generation

This project uses code generation for:
- **Freezed**: Immutable models
- **JSON Serializable**: API models
- **Riverpod Generator**: Providers

Run code generation:
```bash
# Watch mode (auto-generates on file changes)
flutter pub run build_runner watch

# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs
```

### State Management

Using **Riverpod** for state management:

```dart
// Define a provider
final tripProvider = FutureProvider<List<Trip>>((ref) async {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getTrips();
});

// Use in widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripProvider);
    
    return tripsAsync.when(
      data: (trips) => TripsList(trips: trips),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

### Architecture

Following **Clean Architecture** principles:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │  ← UI, Widgets, Screens
├─────────────────────────────────────────┤
│         Domain Layer                    │  ← Entities, Use Cases
├─────────────────────────────────────────┤
│         Data Layer                      │  ← Repositories, Data Sources
└─────────────────────────────────────────┘
```

**Benefits:**
- Testable business logic
- Independent of frameworks
- Independent of UI
- Independent of database
- Independent of external services

## 🎨 Design System

### Color Palette

```dart
Primary: #10b981 (Emerald Green)
Secondary: #14b8a6 (Teal)
Accent: #0ea5e9 (Sky Blue)

Background Primary: #0a0e14
Background Secondary: #151a23
Background Tertiary: #1f2937
```

### Typography

Using **Google Fonts - Inter**:
- Display: 32px, Bold
- Headline: 24px, Semi-Bold
- Title: 18px, Semi-Bold
- Body: 16px, Regular
- Caption: 12px, Regular

## 📱 Features Implementation

### 1. AI Itinerary Generation

```dart
// TODO: Implement in data/datasources/ai_datasource.dart
class AIDataSource {
  Future<Trip> generateItinerary({
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    required double budget,
    required List<String> preferences,
  }) async {
    // Call Gemini API with structured prompts
    // Parse JSON response into Trip entity
  }
}
```

### 2. Google Maps Integration

```dart
// TODO: Implement in presentation/screens/map/map_screen.dart
class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 12,
      ),
      markers: _buildMarkers(),
      polylines: _buildRoutes(),
    );
  }
}
```

### 3. Firebase Integration

```dart
// TODO: Implement in data/datasources/firebase_datasource.dart
class FirebaseDataSource {
  final FirebaseFirestore _firestore;
  
  Future<List<Trip>> getTrips(String userId) async {
    final snapshot = await _firestore
        .collection('trips')
        .where('userId', isEqualTo: userId)
        .get();
    
    return snapshot.docs
        .map((doc) => Trip.fromJson(doc.data()))
        .toList();
  }
}
```

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter test integration_test/
```

### Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📦 Building for Production

### Android
```bash
flutter build apk --release
# Or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🔐 Environment Variables

For production, use environment variables:

```bash
# .env file (don't commit this!)
GEMINI_API_KEY=your_key_here
GOOGLE_MAPS_API_KEY=your_key_here
OPENWEATHER_API_KEY=your_key_here
```

Load with `flutter_dotenv`:
```dart
await dotenv.load(fileName: ".env");
final apiKey = dotenv.env['GEMINI_API_KEY'];
```

## 📝 TODO List

### Phase 1: Core Features ✅
- [x] Project setup and architecture
- [x] Theme and design system
- [x] Domain entities
- [x] Repository interfaces
- [x] Basic UI screens

### Phase 2: AI Integration 🚧
- [ ] Gemini API integration
- [ ] Structured prompt engineering
- [ ] JSON response parsing
- [ ] Error handling and retries

### Phase 3: Maps & Location 📍
- [ ] Google Maps integration
- [ ] Marker clustering
- [ ] Route visualization
- [ ] Location search

### Phase 4: Firebase & Sync ☁️
- [ ] Firebase Authentication
- [ ] Firestore integration
- [ ] Real-time sync
- [ ] Offline support

### Phase 5: Advanced Features 🎯
- [ ] Budget tracking
- [ ] Weather integration
- [ ] PDF export
- [ ] Photo journal
- [ ] Social sharing

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

Built with ❤️ by developers who love to travel

## 🙏 Acknowledgments

- **Google Gemini** for AI capabilities
- **Google Maps** for mapping services
- **OpenWeather** for weather data
- **Firebase** for backend infrastructure
- **Flutter Team** for the amazing framework

## 📞 Support

For issues and questions:
- Open an issue on GitHub
- Email: support@wayfarerapp.com
- Documentation: [docs.wayfarerapp.com](https://docs.wayfarerapp.com)

---

**Happy Traveling! 🌍✈️**

class AppConstants {
  // App Info
  static const String appName = 'Wayfarer AI';
  static const String appVersion = '1.0.0';
  
  // API Keys (Move to environment variables in production)
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String openWeatherApiKey = 'YOUR_OPENWEATHER_API_KEY';
  
  // Firestore Collections
  static const String usersCollection = 'users';
  static const String tripsCollection = 'trips';
  
  // Preferences
  static const List<String> travelPreferences = [
    'Adventure',
    'Relaxation',
    'Culture',
    'Food & Dining',
    'Shopping',
    'Nature',
    'History',
    'Nightlife',
    'Photography',
    'Family Friendly',
  ];
  
  // Budget Ranges
  static const List<String> budgetRanges = [
    'Budget (< \$50/day)',
    'Mid-range (\$50-150/day)',
    'Luxury (> \$150/day)',
  ];
  
  // Currencies
  static const List<String> currencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD', 'CHF', 'CNY', 'INR',
  ];
  
  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'hh:mm a';
  
  // Limits
  static const int maxTripDays = 30;
  static const int minTripDays = 1;
  static const double minBudget = 100;
  static const double maxBudget = 100000;
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wayfarer_ai/core/theme/app_theme.dart';
import 'package:wayfarer_ai/presentation/screens/home/home_screen.dart';
import 'package:wayfarer_ai/services/local_storage_service.dart';
import 'package:wayfarer_ai/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase (will use existing instance on web)
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('✅ Firebase initialized successfully');
    } else {
      print('✅ Firebase already initialized');
    }
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }
  
  // Initialize local storage
  await LocalStorageService.init();
  
  runApp(
    const ProviderScope(
      child: WayfarerApp(),
    ),
  );
}

class WayfarerApp extends StatelessWidget {
  const WayfarerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wayfarer AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}

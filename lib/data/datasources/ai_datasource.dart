import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:wayfarer_ai/core/constants/api_keys.dart';
import 'package:wayfarer_ai/domain/entities/trip.dart';
import 'package:wayfarer_ai/domain/entities/day_itinerary.dart';
import 'package:wayfarer_ai/domain/entities/activity.dart';
import 'package:wayfarer_ai/domain/entities/location.dart';

class AIDataSource {
  late final GenerativeModel _model;

  AIDataSource() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash', // Fast and reliable
      apiKey: ApiKeys.geminiApiKey,
    );
  }

  // Streaming version with live text generation
  Stream<String> generateItineraryStream({
    required String startLocation,
    required String destination,
    required String country,
    required DateTime startDate,
    required DateTime endDate,
    required double budget,
    required List<String> preferences,
  }) async* {
    try {
      final numberOfDays = endDate.difference(startDate).inDays + 1;
      final prompt = _buildPrompt(
        startLocation: startLocation,
        destination: destination,
        country: country,
        numberOfDays: numberOfDays,
        budget: budget,
        preferences: preferences,
        startDate: startDate,
      );

      final content = [Content.text(prompt)];
      final responseStream = _model.generateContentStream(content);

      await for (final chunk in responseStream) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      print('Error generating itinerary stream: $e');
      rethrow;
    }
  }

  // Non-streaming version (kept for backward compatibility)
  Future<Trip> generateItinerary({
    required String startLocation,
    required String destination,
    required String country,
    required DateTime startDate,
    required DateTime endDate,
    required double budget,
    required List<String> preferences,
  }) async {
    try {
      final numberOfDays = endDate.difference(startDate).inDays + 1;
      final prompt = _buildPrompt(
        startLocation: startLocation,
        destination: destination,
        country: country,
        numberOfDays: numberOfDays,
        budget: budget,
        preferences: preferences,
        startDate: startDate,
      );

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        print('AI Response has no text. Candidates: ${response.candidates?.length ?? 0}');
        if (response.candidates != null && response.candidates!.isNotEmpty) {
          print('First candidate content: ${response.candidates!.first.content}');
        }
        throw Exception('No text response from AI. Check if content was filtered or blocked.');
      }
      
      print('AI Response received: ${response.text!.substring(0, response.text!.length > 200 ? 200 : response.text!.length)}...');

      // Parse the JSON response
      final trip = _parseResponse(
        response.text!,
        destination: destination,
        country: country,
        startDate: startDate,
        endDate: endDate,
        budget: budget,
        preferences: preferences,
      );

      return trip;
    } catch (e) {
      print('Error generating itinerary: $e');
      rethrow;
    }
  }

  String _buildPrompt({
    required String startLocation,
    required String destination,
    required String country,
    required int numberOfDays,
    required double budget,
    required List<String> preferences,
    required DateTime startDate,
  }) {
    return '''
Create a $numberOfDays-day itinerary from $startLocation to $destination, $country.

Budget: \$$budget USD (total trip including transportation)
Interests: ${preferences.join(', ')}
Start: ${startDate.toIso8601String().split('T')[0]}

Include: transportation, accommodations, meals, activities matching interests.
Day 1: arrival/check-in. Last day: departure prep.

Respond ONLY with valid JSON (no markdown, no code blocks):

{
  "days": [
    {
      "dayNumber": 1,
      "date": "2025-01-01",
      "summary": "Brief summary of the day",
      "activities": [
        {
          "name": "Activity name",
          "type": "sightseeing",
          "time": "09:00 AM",
          "description": "Detailed description",
          "estimatedCost": 25.0,
          "duration": 120,
          "location": {
            "name": "Location name",
            "address": "Full address",
            "latitude": 48.8584,
            "longitude": 2.2945
          }
        }
      ]
    }
  ]
}

Activity types must be one of: sightseeing, restaurant, hotel, shopping, entertainment, transport, other

Requirements:
1. Include 3-5 activities per day (keep it concise for faster generation)
2. Mix different activity types
3. Include realistic locations with coordinates for $destination
4. Keep costs within the budget of \$$budget
5. Match activities to: ${preferences.join(', ')}
6. Include meal recommendations
7. Return ONLY the JSON object, no additional text

Generate the itinerary now:
''';
  }

  // Public method to parse already-received text
  Trip parseItineraryFromText(
    String responseText, {
    required String destination,
    required String country,
    required DateTime startDate,
    required DateTime endDate,
    required double budget,
    required List<String> preferences,
  }) {
    return _parseResponse(
      responseText,
      destination: destination,
      country: country,
      startDate: startDate,
      endDate: endDate,
      budget: budget,
      preferences: preferences,
    );
  }

  Trip _parseResponse(
    String responseText, {
    required String destination,
    required String country,
    required DateTime startDate,
    required DateTime endDate,
    required double budget,
    required List<String> preferences,
  }) {
    try {
      // Clean the response text
      String cleanedText = responseText.trim();
      
      // Remove markdown code blocks - be more aggressive
      cleanedText = cleanedText.replaceAll('```json', '');
      cleanedText = cleanedText.replaceAll('```', '');
      cleanedText = cleanedText.trim();
      
      // Find the first { and last }
      final firstBrace = cleanedText.indexOf('{');
      final lastBrace = cleanedText.lastIndexOf('}');
      
      if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
        cleanedText = cleanedText.substring(firstBrace, lastBrace + 1);
      }

      Map<String, dynamic> jsonData;
      try {
        jsonData = json.decode(cleanedText) as Map<String, dynamic>;
      } catch (e) {
        print('JSON Parse Error: $e');
        print('Cleaned text: $cleanedText');
        throw Exception('Failed to parse AI response as JSON. The AI might have returned an unexpected format.');
      }
      
      if (!jsonData.containsKey('days')) {
        throw Exception('AI response is missing the "days" field. Response: ${cleanedText.substring(0, 100)}...');
      }
      
      final daysData = jsonData['days'] as List<dynamic>;

      final itinerary = daysData.map((dayData) {
        final activitiesData = dayData['activities'] as List<dynamic>;
        
        final activities = activitiesData.map((activityData) {
          final locationData = activityData['location'] as Map<String, dynamic>;
          
          return Activity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: activityData['name'] as String,
            type: _parseActivityType(activityData['type'] as String),
            time: activityData['time'] as String,
            location: Location(
              latitude: (locationData['latitude'] as num).toDouble(),
              longitude: (locationData['longitude'] as num).toDouble(),
              address: locationData['address'] as String,
              name: locationData['name'] as String? ?? activityData['name'] as String,
            ),
            description: activityData['description'] as String?,
            estimatedCost: (activityData['estimatedCost'] as num?)?.toDouble(),
            duration: activityData['duration'] as int?,
          );
        }).toList();

        return DayItinerary(
          id: '${DateTime.now().millisecondsSinceEpoch}_day_${dayData['dayNumber']}',
          dayNumber: dayData['dayNumber'] as int,
          date: DateTime.parse(dayData['date'] as String),
          activities: activities,
          summary: dayData['summary'] as String?,
        );
      }).toList();

      return Trip(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'guest',
        destination: destination,
        country: country,
        startDate: startDate,
        endDate: endDate,
        budget: budget,
        preferences: preferences,
        itinerary: itinerary,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      print('Error parsing response: $e');
      print('Response text: $responseText');
      throw Exception('Failed to parse AI response: $e');
    }
  }

  ActivityType _parseActivityType(String type) {
    switch (type.toLowerCase()) {
      case 'sightseeing':
        return ActivityType.sightseeing;
      case 'restaurant':
        return ActivityType.restaurant;
      case 'hotel':
        return ActivityType.hotel;
      case 'shopping':
        return ActivityType.shopping;
      case 'entertainment':
        return ActivityType.entertainment;
      case 'transport':
        return ActivityType.transport;
      default:
        return ActivityType.other;
    }
  }
}


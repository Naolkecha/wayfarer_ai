import 'package:flutter/material.dart';
import 'package:wayfarer_ai/core/constants/app_constants.dart';
import 'package:wayfarer_ai/core/theme/app_theme.dart';
import 'package:wayfarer_ai/data/datasources/ai_datasource.dart';
import 'package:wayfarer_ai/domain/entities/trip.dart';
import 'package:wayfarer_ai/presentation/screens/planner/generating_screen.dart';
import 'package:wayfarer_ai/presentation/screens/itinerary/itinerary_view_screen.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startLocationController = TextEditingController();
  final _destinationController = TextEditingController();
  final _countryController = TextEditingController();
  final _budgetController = TextEditingController();
  
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _selectedPreferences = [];

  @override
  void dispose() {
    _startLocationController.dispose();
    _destinationController.dispose();
    _countryController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _generateItinerary() async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select travel dates')),
        );
        return;
      }
      
      if (_selectedPreferences.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one preference')),
        );
        return;
      }

      // Navigate to the live generation screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GeneratingScreen(
            startLocation: _startLocationController.text.trim(),
            destination: _destinationController.text.trim(),
            country: _countryController.text.trim(),
            startDate: _startDate!,
            endDate: _endDate!,
            budget: double.parse(_budgetController.text),
            preferences: _selectedPreferences,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Your Trip'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Where are you starting from?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Starting Location
            TextFormField(
              controller: _startLocationController,
              decoration: const InputDecoration(
                labelText: 'Starting Location',
                hintText: 'e.g., New York, USA',
                prefixIcon: Icon(Icons.flight_takeoff),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your starting location';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            Text(
              'Where do you want to go?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Destination
            TextFormField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'City/Destination',
                hintText: 'e.g., Paris',
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a destination';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Country
            TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Country',
                hintText: 'e.g., France',
                prefixIcon: Icon(Icons.flag),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a country';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Dates
            Text(
              'When are you traveling?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, true),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _startDate == null
                          ? 'Start Date'
                          : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, false),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _endDate == null
                          ? 'End Date'
                          : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Budget
            Text(
              'What\'s your budget?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _budgetController,
              decoration: const InputDecoration(
                labelText: 'Total Budget (USD)',
                hintText: '1000',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your budget';
                }
                final budget = double.tryParse(value);
                if (budget == null || budget < AppConstants.minBudget) {
                  return 'Budget must be at least \$${AppConstants.minBudget}';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Preferences
            Text(
              'What are your interests?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.travelPreferences.map((pref) {
                final isSelected = _selectedPreferences.contains(pref);
                return FilterChip(
                  label: Text(pref),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPreferences.add(pref);
                      } else {
                        _selectedPreferences.remove(pref);
                      }
                    });
                  },
                  selectedColor: AppTheme.primary.withOpacity(0.3),
                  checkmarkColor: AppTheme.primary,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            
            // Generate Button
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _generateItinerary,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate Itinerary'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}


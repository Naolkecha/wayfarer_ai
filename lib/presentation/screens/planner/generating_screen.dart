import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wayfarer_ai/core/theme/app_theme.dart';
import 'package:wayfarer_ai/data/datasources/ai_datasource.dart';
import 'package:wayfarer_ai/presentation/screens/itinerary/itinerary_view_screen.dart';

class GeneratingScreen extends StatefulWidget {
  final String startLocation;
  final String destination;
  final String country;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final List<String> preferences;

  const GeneratingScreen({
    super.key,
    required this.startLocation,
    required this.destination,
    required this.country,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.preferences,
  });

  @override
  State<GeneratingScreen> createState() => _GeneratingScreenState();
}

class _GeneratingScreenState extends State<GeneratingScreen>
    with TickerProviderStateMixin {
  final _aiDataSource = AIDataSource();
  final StringBuffer _generatedText = StringBuffer();

  final List<String> _statusMessages = [
    'Analyzing destination',
    'Planning routes',
    'Finding accommodations',
    'Discovering restaurants',
    'Selecting attractions',
    'Optimizing budget',
    'Creating schedule',
    'Adding experiences',
    'Mapping locations',
    'Finalizing trip',
  ];

  int _currentMessageIndex = 0;
  String _currentStatus = '';
  bool _isComplete = false;
  String? _errorMessage;

  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  int _chunkCount = 0;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _currentStatus = _statusMessages.first;
    _startGeneration();
    _startStatusUpdates();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startStatusUpdates() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted || _isComplete || _errorMessage != null) return;

      setState(() {
        if (_currentMessageIndex < _statusMessages.length - 1) {
          _currentMessageIndex++;
          _currentStatus = _statusMessages[_currentMessageIndex];
          _startStatusUpdates();
        }
      });
    });
  }

  Future<void> _startGeneration() async {
    try {
      final stream = _aiDataSource.generateItineraryStream(
        startLocation: widget.startLocation,
        destination: widget.destination,
        country: widget.country,
        startDate: widget.startDate,
        endDate: widget.endDate,
        budget: widget.budget,
        preferences: widget.preferences,
      );

      await for (final chunk in stream.timeout(
        const Duration(seconds: 60),
        onTimeout: (sink) {
          sink.close();
          throw TimeoutException('Generation took too long. Please try again.');
        },
      )) {
        if (!mounted) return;
        _generatedText.write(chunk);
        _chunkCount++;
      }

      if (!mounted) return;

      setState(() {
        _isComplete = true;
        _currentStatus = 'Complete!';
      });

      await _parseAndNavigate();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _getUserFriendlyError(e);
      });
    }
  }

  String _getUserFriendlyError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Rate limit error
    if (errorString.contains('quota') || 
        errorString.contains('rate limit') || 
        errorString.contains('retry in')) {
      return 'Too many requests. Please wait a moment and try again.';
    }
    
    // Network errors
    if (errorString.contains('network') || 
        errorString.contains('connection') ||
        errorString.contains('failed to fetch')) {
      return 'Network error. Please check your internet connection and try again.';
    }
    
    // Timeout errors
    if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again with a shorter trip duration.';
    }
    
    // API key errors
    if (errorString.contains('api key') || 
        errorString.contains('unauthorized') ||
        errorString.contains('forbidden')) {
      return 'API authentication failed. Please check your API key.';
    }
    
    // Content filtering
    if (errorString.contains('blocked') || 
        errorString.contains('filtered') ||
        errorString.contains('safety')) {
      return 'Content was filtered. Please try different preferences or destination.';
    }
    
    // Generic error
    return 'Unable to generate itinerary. Please try again.';
  }

  Future<void> _parseAndNavigate() async {
    try {
      // Small delay for smooth transition animation
      await Future.delayed(const Duration(milliseconds: 300));

      // Parse the already-received text instead of making another API call
      final trip = _aiDataSource.parseItineraryFromText(
        _generatedText.toString(),
        destination: widget.destination,
        country: widget.country,
        startDate: widget.startDate,
        endDate: widget.endDate,
        budget: widget.budget,
        preferences: widget.preferences,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ItineraryViewScreen(trip: trip),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _getUserFriendlyError(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primary,
              AppTheme.primary.withOpacity(0.8),
              AppTheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: _errorMessage != null
              ? _buildErrorView()
              : _buildGeneratingView(),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 72,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Something Went Wrong',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 15,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Please try again or adjust your search criteria',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                          _isComplete = false;
                          _currentMessageIndex = 0;
                          _currentStatus = _statusMessages.first;
                          _generatedText.clear();
                          _chunkCount = 0;
                        });
                        _startGeneration();
                        _startStatusUpdates();
                      },
                      icon: const Icon(Icons.refresh, size: 22),
                      label: const Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, size: 20),
                      label: const Text(
                        'Go Back',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        foregroundColor: AppTheme.primary,
                        side: BorderSide(
                          color: AppTheme.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildGeneratingView() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Animated AI Icon with Glow Effect
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Middle glow
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.4),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                  // Icon container
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 50,
                            spreadRadius: 5,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: RotationTransition(
                        turns: _rotationController,
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              AppTheme.primary,
                              AppTheme.secondary,
                            ],
                          ).createShader(bounds),
                          child: const Icon(
                            Icons.auto_awesome,
                            size: 70,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Main Title with Gradient
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Colors.white70],
                ).createShader(bounds),
                child: Text(
                  _isComplete ? 'Almost There' : 'Crafting Your Journey',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle with glassmorphism
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  _isComplete
                      ? 'Finalizing your perfect itinerary'
                      : 'AI is designing your ${widget.destination} adventure',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 48),

              // Modern Status Card with Glassmorphism
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 40,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Current Status with Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primary.withOpacity(0.2),
                                AppTheme.secondary.withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getStatusIcon(),
                            color: AppTheme.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            _currentStatus,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A1A),
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),

                    // Sleek Progress Bar
                    Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              height: 8,
                              width: MediaQuery.of(context).size.width * 
                                  (_currentMessageIndex + 1) / _statusMessages.length * 0.8,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primary,
                                    AppTheme.secondary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Step ${_currentMessageIndex + 1} of ${_statusMessages.length}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primary.withOpacity(0.2),
                                    AppTheme.secondary.withOpacity(0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${((_currentMessageIndex + 1) / _statusMessages.length * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Mini progress dots
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      runSpacing: 6,
                      children: List.generate(
                        _statusMessages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: index == _currentMessageIndex ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: index <= _currentMessageIndex
                                ? LinearGradient(
                                    colors: [
                                      AppTheme.primary,
                                      AppTheme.secondary,
                                    ],
                                  )
                                : null,
                            color: index > _currentMessageIndex
                                ? Colors.grey[300]
                                : null,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Trip Details with Modern Cards
              Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildModernTripCard(
                        Icons.location_on_outlined,
                        widget.destination,
                        'Destination',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModernTripCard(
                        Icons.calendar_today_outlined,
                        '${widget.endDate.difference(widget.startDate).inDays + 1} days',
                        'Duration',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: _buildModernTripCard(
                  Icons.attach_money,
                  '\$${widget.budget.toStringAsFixed(0)}',
                  'Budget',
                ),
              ),

              const SizedBox(height: 32),

              // Time Estimate with better styling
              if (!_isComplete)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Usually takes 10-20 seconds',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    if (_currentStatus.toLowerCase().contains('analyzing')) return Icons.analytics_outlined;
    if (_currentStatus.toLowerCase().contains('planning')) return Icons.route_outlined;
    if (_currentStatus.toLowerCase().contains('accommodations')) return Icons.hotel_outlined;
    if (_currentStatus.toLowerCase().contains('restaurants')) return Icons.restaurant_outlined;
    if (_currentStatus.toLowerCase().contains('attractions')) return Icons.attractions_outlined;
    if (_currentStatus.toLowerCase().contains('budget')) return Icons.account_balance_wallet_outlined;
    if (_currentStatus.toLowerCase().contains('schedule')) return Icons.schedule_outlined;
    if (_currentStatus.toLowerCase().contains('experiences')) return Icons.celebration_outlined;
    if (_currentStatus.toLowerCase().contains('mapping')) return Icons.map_outlined;
    if (_currentStatus.toLowerCase().contains('finalizing')) return Icons.check_circle_outline;
    return Icons.auto_awesome_outlined;
  }

  Widget _buildModernTripCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

}

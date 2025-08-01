class AppConfig {
  // API Configuration
  static const String baseUrl = 'http://app.icaralgerie.com';
  static const String apiPrefix = '/api';
  
  // API Endpoints
  static String get googleLogin => '$apiPrefix/login/google'; // Updated to match Laravel route
  static String get logout => '$apiPrefix/logout';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Add other configuration values here as needed
}

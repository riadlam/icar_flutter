class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'http://192.168.1.8:8000';
  static const String apiPrefix = '/api';

  // Auth endpoints
  static const String googleLogin = '$apiPrefix/login/google';
  static const String logout = '$apiPrefix/logout';
  
  // User endpoints
  static const String updateRole = '$apiPrefix/update-role';
  static const String userRole = '$apiPrefix/user/role';
  // Profile endpoints by role
  static const String sellerProfile = '$apiPrefix/my-car-profile';
  static const String mechanicProfile = '$apiPrefix/mechanic-profile';
  static const String garageProfile = '$apiPrefix/garage-profiles'; // Updated to match backend API
  static const String profile = '$apiPrefix/profile'; // General profile endpoint
  static String userSubscription(int userId) => '$apiPrefix/users/$userId/subscribe';
  static String userSubscriptionStatus(int sellerId) => '/api/users/$sellerId/subscription-status';

  // Notifications endpoint
  static const String notifications = '/api/notifications';
  
  // Car endpoints
  static const String cars = '$apiPrefix/cars';
  static const String userCars = '$apiPrefix/user/cars';
  static const String userCarsList = '$apiPrefix/user/cars/list';
  static const String searchCars = '$apiPrefix/cars/search';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

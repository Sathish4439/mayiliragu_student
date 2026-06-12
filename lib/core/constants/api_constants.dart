import 'dart:io';

class ApiConstants {
  ApiConstants._();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       

  static String get baseUrl {
    try {
      if (Platform.isAndroid) {
        return 'https://education-api-tb3k.onrender.com/api';
      //  return 'http://192.168.0.142:5000/api';
      }
    } catch (_) {}
    return 'https://education-api-tb3k.onrender.com/api';
  }

  static const login = '/auth/login';                                                                                                                                                                                                                                                                                                                                                                       
  static const logout = '/auth/logout';
  static const dashboard = '/dashboard/student';
  static const courses = '/courses';
  static const profile = '/profile';
}

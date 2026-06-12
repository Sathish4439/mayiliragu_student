import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'core/network/api_client.dart';
import 'core/services/secure_storage_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Core Services
  final storage = Get.put(SecureStorageService());
  Get.put(ApiClient());

  final token = await storage.getAccessToken();
  final role = await storage.getUserRole();
  final hasSeenOnboarding = await storage.hasSeenOnboarding();

  String initialRoute = Routes.ONBOARDING;
  if (hasSeenOnboarding) {
    if (token != null && role == 'STUDENT') {
      initialRoute = Routes.DASHBOARD;
    } else {
      initialRoute = Routes.LOGIN;
    }
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Education App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}

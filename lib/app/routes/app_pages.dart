import 'package:get/get.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/auth_view.dart';
import '../../modules/dashboard/bindings/dashboard_binding.dart';
import '../../modules/dashboard/views/dashboard_view.dart';
import '../../modules/courses/bindings/course_binding.dart';
import '../../modules/courses/views/course_list_view.dart';
import '../../modules/lessons/bindings/lesson_binding.dart';
import '../../modules/lessons/views/lesson_detail_view.dart';
import '../../modules/profile/bindings/profile_binding.dart';
import '../../modules/profile/views/profile_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.COURSES,
      page: () => const CourseListView(),
      binding: CourseBinding(),
    ),
    GetPage(
      name: Routes.LESSON_DETAIL,
      page: () => const LessonDetailView(),
      binding: LessonBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}

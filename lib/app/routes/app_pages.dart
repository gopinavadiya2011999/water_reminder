import 'package:get/get.dart';

import '../../model/user_model.dart';
import '../modules/AccountDetail/bindings/account_detail_binding.dart';
import '../modules/AccountDetail/views/account_detail_view.dart';
import '../modules/ChangePassword/bindings/change_password_binding.dart';
import '../modules/ChangePassword/views/change_password_view.dart';
import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/bottom_tab/bindings/bottom_tab_binding.dart';
import '../modules/bottom_tab/views/bottom_tab_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/schedule_reminder/bindings/schedule_reminder_binding.dart';
import '../modules/schedule_reminder/views/schedule_reminder_view.dart';
import '../modules/selection/bindings/selection_binding.dart';
import '../modules/selection/views/selection_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_DETAIL,
      page: () => AccountDetailView(),
      binding: AccountDetailBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignUpView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.SELECTION,
      page: () => SelectionView(userModel: UserModel()),
      binding: SelectionBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOM_TAB,
      page: () => BottomTabView(),
      binding: BottomTabBinding(),
    ),
    GetPage(
      name: _Paths.SCHEDULE_REMINDER,
      page: () => const ScheduleReminderView(),
      binding: ScheduleReminderBinding(),
    ),
  ];
}
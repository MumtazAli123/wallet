import 'package:get/get.dart';

import '../../models/user_model.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/bottom_page_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/statement/bindings/statement_binding.dart';
import '../modules/statement/views/statement_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(
        userModel: UserModel(),
      ),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.WALLET,
      page: () => WalletView(
        loggedInUser: UserModel(),
      ),
      binding: WalletBinding(),
    ),
    GetPage(
        name: _Paths.BOTTOM_PAGE,
        page: () => BottomPageView(),
        binding: HomeBinding()),
    GetPage(
      name: _Paths.STATEMENT,
      page: () => const StatementView(),
      binding: StatementBinding(),
    ),
  ];
}

import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

import 'package:wallet/app/modules/realstate/bindings/realstate_binding.dart';
import 'package:wallet/app/modules/realstate/views/realstate_view.dart';
import 'package:wallet/app/modules/save_friends/bindings/save_friends_binding.dart';
import 'package:wallet/app/modules/save_friends/views/save_friends_view.dart';
import 'package:wallet/app/modules/shops/bindings/shops_binding.dart';
import 'package:wallet/app/modules/shops/views/shops_view.dart';
import 'package:wallet/models/realstate_model.dart';

import '../../models/user_model.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/bottom_page_view.dart';
import '../modules/home/views/web_home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/realstate/views/realstate_edit_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/send_money/bindings/send_money_binding.dart';
import '../modules/send_money/views/send_money_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/statement/bindings/statement_binding.dart';
import '../modules/statement/views/statement_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';

// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

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
      // page: () => BottomPageView(),
      page: () => LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return BottomPageView();
        } else {
          return WebHomeView();
        }
      }),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.WALLET,
      page: () => WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
        name: _Paths.BOTTOM_PAGE,
        page: () => BottomPageView(),
        binding: HomeBinding()),
    GetPage(
      name: _Paths.STATEMENT,
      page: () => StatementView(),
      binding: StatementBinding(),
    ),
    GetPage(
      name: _Paths.SEND_MONEY,
      page: () => SendMoneyView(),
      binding: SendMoneyBinding(),
    ),
    GetPage(
      name: _Paths.SAVE_FRIENDS,
      page: () => SaveFriendsView(
        otherUser: [],
      ),
      binding: SaveFriendsBinding(),
    ),
    GetPage(
      name: _Paths.SHOPS,
      page: () => ShopsView(),
      binding: ShopsBinding(),
    ),
    GetPage(
      name: _Paths.REALSTATE,
      page: () => RealStateView(),
      binding: RealstateBinding(),
    ),
    GetPage(
        name: _Paths.REALSTATE_EDIT_VIEW,
        page: () => RealstateEditView(model: RealStateModel()),
        binding: RealstateBinding()
    )
  ];
}

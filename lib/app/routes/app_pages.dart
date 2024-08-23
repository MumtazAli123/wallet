import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

import 'package:wallet/app/modules/job/bindings/job_binding.dart';
import 'package:wallet/app/modules/job/views/job_view.dart';
import 'package:wallet/app/modules/partner/bindings/partner_binding.dart';
import 'package:wallet/app/modules/partner/views/partner_view.dart';
import 'package:wallet/app/modules/products/bindings/products_binding.dart';
import 'package:wallet/app/modules/products/views/products_view.dart';
import 'package:wallet/app/modules/profile/bindings/profile_binding.dart';
import 'package:wallet/app/modules/profile/views/profile_view.dart';
import 'package:wallet/app/modules/realstate/bindings/realstate_binding.dart';
import 'package:wallet/app/modules/realstate/views/realstate_view.dart';
import 'package:wallet/app/modules/register/views/mob_register_view.dart';
import 'package:wallet/app/modules/save_friends/bindings/save_friends_binding.dart';
import 'package:wallet/app/modules/save_friends/views/save_friends_view.dart';
import 'package:wallet/app/modules/shops/bindings/shops_binding.dart';
import 'package:wallet/app/modules/shops/views/shops_view.dart';
import 'package:wallet/app/modules/vehicle/bindings/vehicle_binding.dart';
import 'package:wallet/app/modules/vehicle/views/vehicle_view.dart';
import 'package:wallet/models/realstate_model.dart';

import '../modules/gps/bindings/inspection_binding.dart';
import '../modules/gps/views/gps_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/bottom_page_view.dart';
import '../modules/home/views/web_home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/login/views/web_login.dart';
import '../modules/realstate/views/realstate_edit_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/web_register.dart';
import '../modules/send_money/bindings/send_money_binding.dart';
import '../modules/send_money/views/send_money_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/statement/bindings/statement_binding.dart';
import '../modules/statement/views/statement_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';
import '../modules/wallet/views/web_wallet.dart';

// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 950) {
          return LoginView();
        } else {
          return WebLoginPage();
        }
      }),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 950) {
          return MobRegisterView();
        } else {
          return WebRegisterView();
        }
      }),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      // page: () => BottomPageView(),
      page: () => LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 950) {
          return BottomPageView();
        } else {
          return WebHomeView();
        }
      }),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.WALLET,
      page: () => LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 950) {
          return WalletView();
        } else {
          return WebWalletView();
        }
      }),
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
        binding: RealstateBinding()),
    GetPage(
      name: _Paths.VEHICLE,
      page: () => VehicleView(),
      binding: VehicleBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCTS,
      page: () => ProductsView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.INSPECTION,
      page: () => InspectionView(),
      binding: InspectionBinding(),
    ),
    GetPage(
      name: _Paths.PARTNER,
      page: () => PartnerView(),
      binding: PartnerBinding(),
    ),
    GetPage(
      name: _Paths.JOB,
      page: () => JobView(),
      binding: JobBinding(),
    ),
  ];
}

// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/tabs/gf_tabbar_view.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/realstate/views/realstate_view.dart';
import 'package:wallet/app/modules/realstate/views/tabbar/all_realstate.dart';
import 'package:wallet/app/modules/realstate/views/tabbar/apartment.dart';
import 'package:wallet/app/modules/realstate/views/tabbar/land_view.dart';
import 'package:wallet/app/modules/realstate/views/tabbar/offices_view.dart';
import 'package:wallet/app/modules/realstate/views/tabbar/shops_view.dart';
import 'package:wallet/app/modules/realstate/views/tabbar/villas.dart';

import '../../../../widgets/mix_widgets.dart';
import '../../shops/controllers/shops_controller.dart';

class ShowRealstate extends StatefulWidget {
  const ShowRealstate({super.key});

  @override
  State<ShowRealstate> createState() => _ShowRealstateState();
}

class _ShowRealstateState extends State<ShowRealstate> {
  final controller = Get.put(ShopsController());
  bool isShopsEmpty = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller.fetchShops();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return SafeArea(
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                centerTitle: false,
                title: wText('Real State', size: 24),
                floating: true,
                snap: true,
                pinned: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _buildDialogProducts(context);
                    },
                  ),
                ],
                bottom: TabBar(
                  tabAlignment: TabAlignment.center,
                  labelColor: Colors.green[800],
                  controller: controller.tabController,
                  automaticIndicatorColorAdjustment: true,
                  isScrollable: true,
                  tabs: [
                    Tab(
                        icon: Icon(Icons.all_inbox),
                        text: 'All'),
                    Tab(icon: Icon(Icons.real_estate_agent), text: 'Villas'),
                    Tab(
                        icon: Icon(Icons.apartment),
                        text: 'Apartment'),
                    Tab(
                        icon: Icon(Icons.landscape),
                        text: 'Land'),
                    // offices
                    Tab(
                        icon: Icon(Icons.business),
                        text: 'Offices'),
                    Tab(
                        icon: Icon(Icons.shopping_bag),
                        text: 'Shops'),
                  ],
                ),
              ),
            ];
          },
        body: GFTabBarView(
          controller: controller.tabController,
          children: [
            AllRealstate(),
            VillasView(),
            Apartment(),
            LandView(),
            OfficesView(),
            ShopsViewPage(),
          ],
        ),
      ),
    );
  }


  void _buildDialogProducts(BuildContext context) {
    QuickAlert.show(context: context,
        type: QuickAlertType.custom,
        title: 'Add Realstate',
        text: 'Upload Realstate to sell or rent it out to customers',
       width: 400,
      showConfirmBtn: false,
      widget: Column(
        children: [
          Divider(),
          GFButton(
            onPressed: () {
              Get.to(() => RealStateView());
            },
            text: 'Upload Realstate',
            color: Colors.green,
          ),
        ],
      )
    );
  }
}

// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/alert/gf_alert.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
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
      child: SafeArea(
        child: Scaffold(
          body: _buildBody(),
        ),
      ),
    );
  }

  _buildBody() {
    return NestedScrollView(
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
        body: TabBarView(
          children: [
            AllRealstate(),
            VillasView(),
            Apartment(),
            LandView(),
            OfficesView(),
            ShopsViewPage(),
          ],
        )
    );
    // return StreamBuilder(
    //     stream: controller.realStateStream(),
    //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(child: CircularProgressIndicator());
    //       }
    //       if (snapshot.hasData) {
    //         if (snapshot.data!.docs.isEmpty) {
    //           return Center(child: Text('No Realstate found'));
    //         }
    //         return ListView.builder(
    //             itemCount: snapshot.data!.docs.length,
    //             itemBuilder: (context, index) {
    //               return _buildRealstateCard(snapshot.data!.docs[index]);
    //             });
    //       }
    //       return Center(child: Text('No Realstate found'));
    //     });
  }

  _buildRealstateCard(doc) {
    return GFCard(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      semanticContainer: true,
      showImage: true,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
      title: GFListTile(
        title: Row(
          children: [
            controller.user!.photoURL != null
                ? GFAvatar(
                    backgroundImage: NetworkImage(controller.user!.photoURL!),
                  )
                : GFAvatar(
                    size: 15,
                    child: Text("${doc['realStateType'][0]}"),
                  ),
            SizedBox(width: 10.0),
            Text(doc['realStateType'] + ' For ' + doc['realStateStatus'])
          ],
        ),
        subTitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.blueAccent,
              ),
              SizedBox(width: 10.0),
              Text('City: ${doc['city']}'),
            ],
          ),
        ),
        icon: Icon(Icons.favorite),
      ),
      image: Image.network(doc['image']),
      content: Text('Realstate Agent: ${doc['sellerName']}'),
      buttonBar: GFButtonBar(
        children: [
          // GFButton(
          //   onPressed: onTap,
          //   text: 'Scholarship',
          //   color: Colors.green,
          // ),
        ],
      ),
    );
  }

  void _buildDialogProducts(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return GFAlert(
            title: 'Add Product',
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(),
                SizedBox(height: 10.0),
                // Add Real state
                TextButton.icon(
                    onPressed: () {
                      Get.to(() => RealStateView());
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Realstate')),
                SizedBox(height: 10.0),
                // Add Vehicle
                TextButton.icon(
                    onPressed: () {
                      Get.toNamed('/addVehicle');
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Vehicle')),
                SizedBox(height: 10.0),
                // Add Electronics
                TextButton.icon(
                    onPressed: () {
                      Get.toNamed('/addElectronics');
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Electronics')),
                SizedBox(height: 10.0),
                // Add Furniture
                TextButton.icon(
                    onPressed: () {
                      Get.toNamed('/addFurniture');
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Furniture')),
              ],
            ),
          );
        });
  }
}

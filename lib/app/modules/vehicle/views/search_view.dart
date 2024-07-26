import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';
import 'package:wallet/app/modules/vehicle/views/tabbar/all_vehicle.dart';

import '../../../../models/vehicle_model.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final controller = Get.put(VehicleController());
  var searchName = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Search'),
        //   centerTitle: true,
        // ),
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return NestedScrollView(

        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(

              title: const Text('Search'),
              centerTitle: true,
              floating: true,
              snap: true,
              pinned: true,
              forceElevated: innerBoxIsScrolled,
              bottom: PreferredSize(

                preferredSize: const Size.fromHeight(100.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      helperText: 'Search by vehicle name',
                      filled: true,
                      fillColor: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchName = value;
                      });
                    },
                  ),
                ),
              ),
            ),
          ];
        },
        body: _buildSearchItems(),
    );
  }

  _buildSearchItems() {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('vehicle')
            // search by vehicle name, by model, by color with lowercase
            .orderBy('vehicleName')
            .startAt([searchName]).endAt(['$searchName\uf8ff'])
            .limit(3)
            .snapshots(),

        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.data!.docs.isEmpty){
            return const Center(
              child: Text('No data found'),
            );
          }
          else{
            return ListView.builder(
              // less than 3 items will not show
              itemCount: 3 < 3 ? 3 : snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index].data() as Map;
                VehicleModel model =
                VehicleModel.fromJson(data as Map<String, dynamic>);
                return wBuildVehicleCard(model.toJson());
              },
            );
          }
        },
      ),
    );
  }

  // _buildSearchField() {
  //   return TextField(
  //
  //     decoration: InputDecoration(
  //       hintText: 'Search',
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8),
  //         borderSide: BorderSide.none,
  //       ),
  //       prefixIcon: const Icon(Icons.search),
  //       helperText: 'Search by vehicle name',
  //       filled: true,
  //       fillColor: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
  //
  //     ),
  //     onChanged: (value) {
  //       setState(() {
  //         searchName = value;
  //       });
  //
  //     },
  //   );
  // }
  //
  // _buildSearchItems() {
  //   return Expanded(
  //     child: StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance.collection('vehicles')
  //           .orderBy('vehicleName')
  //       .startAt([searchName]).endAt(['$searchName\uf8ff'])
  //       // .where((_element) => _element['vehicleName'].toString().toLowerCase().contains(searchName.toLowerCase()))
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         try {
  //           if (snapshot.hasData) {
  //             return ListView.builder(
  //               itemCount: snapshot.data!.docs.length,
  //               itemBuilder: (context, index) {
  //                 var data = snapshot.data!.docs[index].data() as Map;
  //                 VehicleModel model =
  //                 VehicleModel.fromJson(data as Map<String, dynamic>);
  //                 return wBuildVehicleCard(model.toJson());
  //               },
  //             );
  //           } else {
  //             return const Center(
  //               child: CircularProgressIndicator(),
  //             );
  //           }
  //         } catch (e) {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }
}

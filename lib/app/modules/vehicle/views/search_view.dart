import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/register/controllers/register_controller.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';
import 'package:wallet/app/modules/vehicle/views/vehicle_page_view.dart';

import '../../../../models/vehicle_model.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final controller = Get.put(VehicleController());
  final controller1 = Get.put(RegisterController());
  var searchName = '';

  Stream<QuerySnapshot> searchVehicles() {
    // Convert search term to lowercase
    String lowerCaseSearchName = searchName.toLowerCase();
    if (searchName.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('vehicle')
          .orderBy('vehicleName')
          .startAt([searchName]).endAt(['$searchName\uf8ff'])
          .limit(5)
          .snapshots();
    }else if(searchName.isNotEmpty){
      return FirebaseFirestore.instance
          .collection('vehicle')
          .orderBy('vehicleStatus')
          .startAt([searchName]).endAt(['$searchName\uf8ff'])
          .limit(5)
          .snapshots();
    }else{
      return FirebaseFirestore.instance
          .collection('vehicle')
          .orderBy('vehicleName')
          .limit(5)
          .snapshots();
    }
    
  }

  @override
  void initState() {
    super.initState();
    searchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Vehicles'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                textInputAction: TextInputAction.search,
                inputFormatters: [
                  // ignore: deprecated_member_use
                  controller1.upperCaseTextFormatter,
                ],
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
          )
        ),
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return _buildSearchItems();
  }

  _buildSearchItems() {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: searchVehicles(),

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
              // itemCount: snapshot.data!.docs.length,
              itemCount: 5 < 5 ? 5 : snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index].data() as Map;
                VehicleModel model =
                VehicleModel.fromJson(data as Map<String, dynamic>);
                return wVehicleCard(model.toJson());
              },
            );
          }
        },
      ),
    );
  }

}
Widget wVehicleCard(doc) {
  return GestureDetector(
    onTap: () {
      Get.to(() => VehiclePageView(
          vModel: VehicleModel.fromJson(doc), doc: doc.toString()

      ));
    },
    child: Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0.0),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(doc['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    // leading: const Icon(Icons.directions_car),
                    title: Text("Vehicle: ${doc['vehicleName']}"
                        "\nModel: ${doc['vehicleModel']}\n"
                        "Color: ${doc['vehicleColor']}\n"
                        "For ${doc['vehicleStatus']}\n"
                        "Price: ${doc['vehiclePrice']}"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

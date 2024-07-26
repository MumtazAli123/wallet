import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';

import '../../../../models/vehicle_model.dart';

class SearchView extends GetView<VehicleController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          centerTitle: true,
        ),
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildSearchField(),
            _buildSearchItems(),
          ],
        ),
      ),
    );
  }

  _buildSearchField() {
    return TextField(
      controller: controller.searchController,
      onTap: () {
        controller.searchController.clear();
      },
      onSubmitted: (value) {
        controller.searchVehicleStream(value);
      },
      decoration: InputDecoration(
        hintText: 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }

  _buildSearchItems() {
    return Obx(
      () => controller.searchList.isEmpty
          ? const Center(
              child: Text('No data found'),
            )
          : Expanded(
              child: ListView.builder(
                itemCount: controller.searchList.length,
                itemBuilder: (context, index) {
                  VehicleModel model = VehicleModel.fromJson(
                    controller.searchList[index].data() as Map<String, dynamic>,
                  );
                  return ListTile(
                    onTap: () {
                      // Get.to(() => VehiclePageView(
                      //       vModel: model,
                      //       doc: model.toJson().toString(),
                      //     ));
                    },
                    title: Text(model.vehicleName!),
                    subtitle: Text(
                      'Price: ${model.vehiclePrice}'
                      '\nColor: ${model.vehicleColor}',
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        controller.deleteVehicle(model.vehicleId!);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

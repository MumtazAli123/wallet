import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';

import '../../../../utils/translation.dart';
import '../../../../widgets/mix_widgets.dart';

class UploadVehicleView extends StatefulWidget {
  const UploadVehicleView({super.key});

  @override
  State<UploadVehicleView> createState() => _UploadVehicleViewState();
}

class _UploadVehicleViewState extends State<UploadVehicleView> {
  final controller = Get.put(VehicleController());

  XFile? imageFile;
  ImagePicker image = ImagePicker();

  bool isUpLoading = false;

  // refresh the image list
  bool isImageRefresh = false;

  validateAndUploadForm() {
    if (imageFile == null) {
      Get.snackbar("Error", "Please select image");
      return;
    }
    if (controller.vehicleDescriptionController.text.isEmpty ||
        controller.vehicleDescriptionController.text.length < 3 &&
            controller.vehicleDescriptionController.text.length > 200) {
      Get.snackbar("Error", "Please enter description min 3 and max 200");
      return;
    } else if (controller.vehiclePriceController.text.isEmpty ||
        controller.vehiclePriceController.text.length < 3 &&
            controller.vehiclePriceController.text.length > 20) {
      Get.snackbar("Error", "Please enter starting from min 3 and max 20");
      return;
    } else {
      setState(() {
        isUpLoading = true;
      });
      controller.uploadImage();
    }
  }

  uploadFormScreen() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            actions: [
              //   uploadImage(),
              IconButton(
                  onPressed: () {
                    isUpLoading == true ? null : validateAndUploadForm();
                  },
                  icon: const Icon(Icons.upload, color: Colors.white)),
            ],
            title: const Text("Upload Vehicle",
                style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
          body: ListView(children: [
            isUpLoading == true ? wLinearProgressBar(context) : const Text(""),
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: controller.imageUrlPath.length,
                itemBuilder: (context, index) {
                  return index == 0
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: FileImage(
                                        File(controller.imageUrlPath[index])),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  onPressed: () {
                                    controller.imageUrlPath.removeAt(index);
                                    controller.imageFileCount.value =
                                        controller.imageUrlPath.length;
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: FileImage(
                                        File(controller.imageUrlPath[index])),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  onPressed: () {
                                    controller.imageUrlPath.removeAt(index);
                                    controller.imageFileCount.value =
                                        controller.imageUrlPath.length;
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                  // return Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Stack(
                  //     children: [
                  //       Container(
                  //         height: 150,
                  //         width: 150,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           image: DecorationImage(
                  //             image: FileImage(File(controller.imageUrlPath[index])),
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       ),
                  //       Positioned(
                  //         right: 0,
                  //         child: IconButton(
                  //           onPressed: () {
                  //             controller.imageUrlPath.removeAt(index);
                  //             controller.imageFileCount.value = controller.imageUrlPath.length;
                  //             setState(() {});
                  //           },
                  //           icon: const Icon(Icons.delete, color: Colors.red),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GFButton(
                  size: 50,
                  onPressed: () {
                    if (controller.imageUrlPath.length < 8) {
                      obtainImageBox();
                    } else {
                      Get.snackbar(
                          "Error", "You can't select more than 8 images",
                          backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  },
                  child: wText("Select More Images")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wTextField(
                  keyboardType: "text",
                  controller: controller.showroomNameController,
                  labelText: "Showroom Name",
                  hintText: "Enter Showroom Name",
                  prefixIcon: Icons.home),
            ),
            // vehicle type
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Vehicle Type",
                  hintText: "Select Vehicle Type",
                  prefixIcon: const Icon(Icons.directions_car),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.vehicleTypeValue,
                onChanged: (value) {
                  controller.vehicleTypeValue = value.toString();
                  setState(() {});
                },
                items: controller.vehicleType.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wTextField(
                  keyboardType: 'text',
                  controller: controller.vehicleNameController,
                  labelText: "Vehicle Name",
                  hintText: "Enter Vehicle Name",
                  prefixIcon: Icons.car_rental),
            ),
            // currency
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Currency",
                  hintText: "Select Currency",
                  prefixIcon: const Icon(Icons.money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.currencyValue,
                onChanged: (value) {
                  controller.currencyValue = value.toString();
                  setState(() {});
                },
                items: controller.currency.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
            // price
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wTextField(
                  keyboardType: "number",
                  controller: controller.vehiclePriceController,
                  labelText: "Vehicle Price",
                  hintText: "Enter Vehicle Price",
                  prefixIcon: Icons.money),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wTextField(
                  keyboardType: "number",
                  controller: controller.vehicleKmController,
                  labelText: "Vehicle Km",
                  hintText: "Enter Vehicle Km",
                  prefixIcon: Icons.directions_car),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Vehicle Model",
                  hintText: "Select Vehicle Model",
                  prefixIcon: const Icon(Icons.directions_car),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.vehicleModelValue,
                onChanged: (value) {
                  controller.vehicleModelValue = value.toString();
                  setState(() {});
                },
                items: controller.vehicleModel.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
            // vehicle fuel type
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Vehicle Fuel Type",
                  hintText: "Select Vehicle Fuel Type",
                  prefixIcon: const Icon(Icons.directions_car),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.vehicleFuelTypeValue,
                onChanged: (value) {
                  controller.vehicleFuelTypeValue = value.toString();
                  setState(() {});
                },
                items: controller.vehicleFuelType.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
            // vehicle transmission
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Vehicle Transmission",
                  hintText: "Select Vehicle Transmission",
                  prefixIcon: const Icon(Icons.directions_car),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.vehicleTransmissionValue,
                onChanged: (value) {
                  controller.vehicleTransmissionValue = value.toString();
                  setState(() {});
                },
                items: controller.vehicleTransmission.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
            // vehicle condition
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Vehicle Condition",
                  hintText: "Select Vehicle Condition",
                  prefixIcon: const Icon(Icons.directions_car),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.vehicleConditionValue,
                onChanged: (value) {
                  controller.vehicleConditionValue = value.toString();
                  setState(() {});
                },
                items: controller.vehicleCondition.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
            // vehicle status
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Vehicle Status",
                  hintText: "Select Vehicle Status",
                  prefixIcon: const Icon(Icons.directions_car),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.vehicleStatusValue,
                onChanged: (value) {
                  controller.vehicleStatusValue = value.toString();
                  setState(() {});
                },
                items: controller.vehicleStatus.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
            // vehicle amenities
            // Padding(padding: const EdgeInsets.all(8.0),
            //   child: DropdownButtonFormField(
            //     decoration: InputDecoration(
            //       labelText: "Vehicle Amenities",
            //       hintText: "Select Vehicle Amenities",
            //       prefixIcon: const Icon(Icons.directions_car),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //     value: controller.vehicleAmenitiesValue,
            //     onChanged: (value) {
            //       controller.vehicleAmenitiesValue = value.toString();
            //       setState(() {});
            //     },
            //     items: controller.vehicleAmenities.map((e) {
            //       return DropdownMenuItem(
            //         child: Text(e),
            //         value: e,
            //       );
            //     }).toList(),
            //   ),
            // ),
            // vehicle color
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Vehicle Color",
                  hintText: "Select Vehicle Color",
                  prefixIcon: const Icon(Icons.directions_car),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.vehicleColorValue,
                onChanged: (value) {
                  controller.vehicleColorValue = value.toString();
                  setState(() {});
                },
                items: controller.vehicleColor.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
            // vehicle body type
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Vehicle Body Type",
                  hintText: "Select Vehicle Body Type",
                  prefixIcon: const Icon(Icons.directions_car),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.vehicleBodyTypeValue,
                onChanged: (value) {
                  controller.vehicleBodyTypeValue = value.toString();
                  setState(() {});
                },
                items: controller.vehicleBodyType.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
            // address
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wTextField(
                  keyboardType: "text",
                  controller: controller.addressController,
                  labelText: "Vehicle Address",
                  hintText: "Enter Vehicle Address",
                  prefixIcon: Icons.location_on),
            ),
            // city
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wTextField(
                  keyboardType: "text",
                  controller: controller.cityController,
                  labelText: "Vehicle City",
                  hintText: "Enter Vehicle City",
                  prefixIcon: Icons.location_city),
            ),
            // description
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: controller.vehicleDescriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "Vehicle Description",
                    hintText: "Enter Vehicle Description",
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: GFButton(
                  size: 50,
                  onPressed: () {
                    isUpLoading == true ? null : validateAndUploadForm();
                  },
                  child: wText("Upload Vehicle")),
            ),
          ])),
    );
  }

  @override
  void initState() {
    super.initState();
    controller.vehiclePriceController = TextEditingController();
    controller.vehicleKmController = TextEditingController();
    controller.vehicleNameController = TextEditingController();
    controller.vehicleDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    // controller.vehiclePriceController.dispose();
    // controller.vehicleKmController.dispose();
    // controller.vehicleNameController.dispose();
    // controller.vehicleDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return imageFile == null ? defaultScreen() : uploadFormScreen();
  }

  Widget defaultScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.asset(
              "assets/images/popular_5.jpg",
            ).image,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppBar(
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Get.toNamed('/realstate');
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                title: Text(
                  Utils.dayTime(DateTime.now()),
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )),
            wTitleMedium(
              title: "Upload Vehicle Images",
              subtitle: "Please select image for upload vehicle",
            ),
            IconButton(
                onPressed: () {
                  obtainImageBox();
                },
                icon: const Icon(
                  Icons.add_photo_alternate,
                  color: Colors.white,
                  size: 110,
                )),
            const SizedBox(
              height: 80,
            ),
            wCustomButton(
                width: 250,
                text: 'Upload Image',
                icon: Icons.image,
                onPressed: () {
                  obtainImageBox();
                })
          ],
        ),
      ),
    );
  }

  void obtainImage(ImageSource source) async {
    final pickedFile = await image.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
        controller.imageUrlPath.add(imageFile!.path);
        controller.imageFileCount.value = controller.imageUrlPath.length;
      });
    }
  }

  void obtainImageBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Select Image"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text("Camera"),
                  onTap: () {
                    obtainImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text("Gallery"),
                  onTap: () {
                    obtainImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}

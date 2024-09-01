import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:wallet/models/vehicle_model.dart';

import '../../../../global/global.dart';
import '../../../../widgets/mix_widgets.dart';
import '../views/show_vehicle_view.dart';

class VehicleController extends GetxController {
  // showroom name controller
  TextEditingController showroomNameController = TextEditingController();
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController vehiclePriceController = TextEditingController();
  TextEditingController vehicleDescriptionController = TextEditingController();
  TextEditingController vehicleKmController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  // offer
  TextEditingController offerController = TextEditingController();
  TextEditingController offerDescriptionController = TextEditingController();

  // vehicle type
  List<String> vehicleModel = [
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
    '2018',
    '2017',
    '2016',
    '2015',
    '2014',
    '2013',
    '2012',
    '2011',
    '2010',
    '2009',
    '2008',
    '2007',
    '2006',
    '2005',
    '2004',
    '2003',
    '2002',
    '2001',
    '2000',
    '1999',
    '1998',
    '1997',
    '1996',
    '1995',
    '1994',
    '1993',
    '1992',
    '1991',
    '1990',
    '1989',
    '1988',
    '1987',
    '1986',
    '1985',
    '1984',
    '1983',
    '1982',
    '1981',
    '1980',
    '1979',
    '1978',
    '1977',
    '1976',
    '1975',
    '1974',
    '1973',
    '1972',
    '1971',
    '1970',
  ];
  List<String> vehicleType = [
    'Car',
    'Bike',
    'Truck',
    'Bus',
    'Land cruiser',
    'Other'
  ];
  List<String> vehicleName = [
    "Toyota",
    'Audi',
    'BMW',
    'Ford',
    'Honda',
    'Hyundai',
    'Kia',
    'Mercedes',
    'Tesla',
    'Nissan',
    'Suzuki',
    'Volkswagen',
    'Other'
  ];
  List<String> vehicleFuelType = [
    'Petrol',
    'Diesel',
    'Electric',
    'Hybrid',
    'Other'
  ];
  List<String> vehicleTransmission = ['Automatic', 'Manual', 'Other'];
  List<String> vehicleCondition = ['New', 'Used', 'Accident', 'Other'];
  List<String> vehicleStatus = ['Sale', 'Rent', 'Lease', 'Other'];
  List<String> vehicleAmenities = [
    'AC',
    'Heater',
    'Power Steering',
    'Power Windows',
    'ABS',
    'Air Bags',
    'Central Locking',
    'Immobilizer',
    'Keyless Entry',
    'CD Player',
    'DVD Player',
    'Navigation System',
    'Alloy Rims',
    'Sun Roof',
    'Leather Seats',
    'Other'
  ];
  List<String> vehicleColor = [
    'Black',
    'White',
    'Silver',
    'Grey',
    'Blue',
    'Red',
    'Green',
    'Yellow',
    'Orange',
    'Purple',
    'Brown',
    'Other'
  ];
  List<String> vehicleBodyType = [
    'Sedan',
    'Hatchback',
    'SUV',
    'MPV',
    'Crossover',
    'Coupe',
    'Convertible',
    'Pickup',
    'Van',
    'Bike',
    'Truck',
    'Other'
  ];
  // list of currency
  List<String> currency = ['AED', 'USD', 'PKR', 'INR', 'EUR', 'GBP', "CAD", "SAR", "BHD", 'Other'];

  // vehicle type value
  String? vehicleTypeValue;
  String? vehicleNameValue;
  String? vehicleFuelTypeValue;
  String? vehicleTransmissionValue;
  String? vehicleConditionValue;
  String? vehicleStatusValue;
  String? vehicleAmenitiesValue;
  String? vehicleColorValue;
  String? vehicleModelValue;
  String? vehicleBodyTypeValue;
  String? currencyValue;

  String vehicleUniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  var fabController;
  var tabIndex = 0.obs;

  final db = FirebaseFirestore.instance.collection("sellers").doc().snapshots();
  final user = FirebaseAuth.instance.currentUser;

  final date = DateTime.now();

  bool selected = false;
  double? val = 0;

  final ImagePicker _picker = ImagePicker();
  List<XFile>? images = [];
  List<String> imageUrlPath = [];
  var imageFileCount = 0.obs;
  String downloadImageUrl = "";

  var imageFile = "".obs;

  var imagePath = "".obs;

  var formKey = GlobalKey<FormState>();

  var search = "".obs;

  var searchList = [].obs;

  realStateStream() {
    return FirebaseFirestore.instance
        .collection("sellers")
        .doc(user!.uid)
        .collection("vehicle")
        .orderBy("publishedDate", descending: true)
        .snapshots();
  }

  Rx<List<Map<String, dynamic>>> vehicleList =
      Rx<List<Map<String, dynamic>>>([]);

  final Rx<List> vehicleProfilesList = Rx<List>([]);
  List get vehicleProfiles => vehicleProfilesList.value;

  var currentScreen = 0.obs;

  @override
  void onInit() {
    super.onInit();
    imagePath.value = "";
    showroomNameController = TextEditingController();
    vehicleNameController = TextEditingController();
    vehiclePriceController = TextEditingController();
    vehicleDescriptionController = TextEditingController();
    vehicleKmController = TextEditingController();
    offerController = TextEditingController();
    offerDescriptionController = TextEditingController();
    // vehicleList.bindStream(realStateStream());
    vehicleList.value = [];
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    super.onClose();
    showroomNameController.dispose();
    vehicleNameController.dispose();
    vehiclePriceController.dispose();
    vehicleDescriptionController.dispose();
    vehicleKmController.dispose();
    offerController.dispose();
    offerDescriptionController.dispose();
  }

  void selectMultipleImage() async {
    images = await _picker.pickMultiImage();
    if (images != null) {
      for (XFile file in images!) {
        imageUrlPath.add(file.path);
      }
    } else {
      imageFileCount.value = 0;
    }
    imageFileCount.value = imageUrlPath.length;
  }

  void uploadImage() async {
    try {
      showDialog(
          context: Get.context!, builder: (context) => wAppLoading(context));
      if (imageUrlPath.isNotEmpty) {
        for (int i = 1; i < imageUrlPath.length; i++) {
          File file = File(imageUrlPath[i]);
          fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
              .ref()
              .child("vehicle")
              .child(user!.uid)
              .child("$vehicleUniqueId$i.jpg");
          fStorage.UploadTask uploadImageTask = storageRef.putFile(file);
          fStorage.TaskSnapshot taskSnapshot = await uploadImageTask;
          await taskSnapshot.ref.getDownloadURL().then((urlImage) {
            downloadImageUrl = urlImage;
          });
          addVehicle();
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void addVehicle() async {
    try {
      await FirebaseFirestore.instance
          .collection("sellers")
          .doc(sharedPreferences!.getString("uid"))
          .collection("vehicle")
          .doc(vehicleUniqueId)
          .set({
        "vehicleId": vehicleUniqueId,
        "showroomName": showroomNameController.text,
        "vehicleName": vehicleNameController.text,
        "vehiclePrice": vehiclePriceController.text,
        "vehicleDescription": vehicleDescriptionController.text,
        "vehicleKm": vehicleKmController.text,
        "sellerId": sharedPreferences!.getString("uid"),
        "sellerName": sharedPreferences!.getString("name"),
        "email": sharedPreferences!.getString("email"),
        "phone": sharedPreferences!.getString("phone"),
        'sellerImage': sharedPreferences!.getString("image"),
        "image": downloadImageUrl,
        'address': addressController.text,
        'city': cityController.text,
        // "imagePath": imageUrlPath,
        "vehicleModel": vehicleModelValue,
        "vehicleType": vehicleTypeValue,
        "vehicleFuelType": vehicleFuelTypeValue,
        "vehicleTransmission": vehicleTransmissionValue,
        "vehicleCondition": vehicleConditionValue,
        "vehicleStatus": vehicleStatusValue,
        "vehicleAmenities": vehicleAmenitiesValue,
        "vehicleColor": vehicleColorValue,
        "vehicleBodyType": vehicleBodyTypeValue,
        "currency": currencyValue,
        "status": "available",
        "likeCount": 5,
        "publishedDate": date,
        "updatedDate": date,
      }).then((value) {
        FirebaseFirestore.instance
            .collection("vehicle")
            .doc(vehicleUniqueId)
            .set({
          "vehicleId": vehicleUniqueId,
          "showroomName": showroomNameController.text,
          "vehicleName": vehicleNameController.text,
          "vehiclePrice": vehiclePriceController.text,
          "vehicleDescription": vehicleDescriptionController.text,
          "vehicleKm": vehicleKmController.text,
          "sellerId": sharedPreferences!.getString("uid"),
          "sellerName": sharedPreferences!.getString("name"),
          "email": sharedPreferences!.getString("email"),
          "phone": sharedPreferences!.getString("phone"),
          'sellerImage': sharedPreferences!.getString("image"),
          "image": downloadImageUrl,
          'address': addressController.text.trim(),
          'city': cityController.text.trim(),
          // "imagePath": imageUrlPath,
          "vehicleModel": vehicleModelValue,
          "vehicleType": vehicleTypeValue,
          "vehicleFuelType": vehicleFuelTypeValue,
          "vehicleTransmission": vehicleTransmissionValue,
          "vehicleCondition": vehicleConditionValue,
          "vehicleStatus": vehicleStatusValue,
          "vehicleAmenities": vehicleAmenitiesValue,
          "vehicleColor": vehicleColorValue,
          "vehicleBodyType": vehicleBodyTypeValue,
          "currency": currencyValue,
          "status": "available",
          "likeCount": 5,
          "publishedDate": date,
          "updatedDate": date,
        });
        // Get.back();
        Get.to(() => const ShowVehicleView());

        Get.snackbar("Success", "Vehicle Added Successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void pickImage() {
    selectMultipleImage();
  }

  void uploadVehicle() {
    if (formKey.currentState!.validate()) {
      if (imageUrlPath.isNotEmpty) {
        uploadImage();
      } else {
        Get.snackbar("Error", "Please select image");
      }
    }
  }

  void deleteImage(int index) {
    imageUrlPath.removeAt(index);
    imageFileCount.value = imageUrlPath.length;
  }

  vehicleStream() {
    return FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("vehicle")
        .orderBy("publishedDate", descending: true)
        .snapshots();
  }

  allVehicleStream() {
    return FirebaseFirestore.instance
        .collection("vehicle")
        .orderBy("publishedDate", descending: true)
        .snapshots();
  }

  void editVehicle(VehicleModel model) {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(user!.uid)
        .collection("vehicle")
        .doc(model.vehicleId)
        .update(model.toJson())
        .then((value) {
      FirebaseFirestore.instance
          .collection("vehicle")
          .doc(model.vehicleId)
          .update(model.toJson());
      Get.back();
      Get.snackbar("Success", "Vehicle Updated Successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
      // Get.to(() => const ShowVehicleView());
    });
  }

  void deleteVehicle(id) {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(user!.uid)
        .collection("vehicle")
        .doc(id)
        .delete()
        .then((value) {
      FirebaseFirestore.instance.collection("vehicle").doc(id).delete();
      Get.snackbar("Success", "Vehicle Deleted Successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
    });
  }

  carVehicleStream() {
    return FirebaseFirestore.instance
        .collection("vehicle")
        .where("vehicleType", isEqualTo: "Car")
        .snapshots();
  }

  bikeStream() {
    return FirebaseFirestore.instance
        .collection("vehicle")
        .where("vehicleType", isEqualTo: "Bike")
        .snapshots();
  }

  truckStream() {
    return FirebaseFirestore.instance
        .collection("vehicle")
        .where("vehicleType", isEqualTo: "Truck")
        .snapshots();
  }

  busStream() {
    return FirebaseFirestore.instance
        .collection("vehicle")
        .where("vehicleType", isEqualTo: "Bus")
        .snapshots();
  }

  othersStream() {
    return FirebaseFirestore.instance
        .collection("vehicle")
        .where("vehicleType", isEqualTo: "Other")
        .snapshots();
  }

  allRealStateStream() {
    return FirebaseFirestore.instance
        .collection("realState")
        .orderBy("publishedDate", descending: true)
        .limit(20)
        .snapshots();
  }

  void favoriteSendAndReceive(String string, param1) {}

  void addVehicleToOffer(VehicleModel vehicle) async {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(user!.uid)
        .collection("vehicle")
        .doc(vehicle.vehicleId)
        .collection("offer")
        .doc(sharedPreferences!.getString("uid"))
        .set({
      "vehicleId": vehicle.vehicleId,
      "showroomName": vehicle.showroomName,
      "vName": vehicle.vehicleName,
      "price": vehicle.vehiclePrice,
      "description": vehicle.vehicleDescription,
      'buyerId': sharedPreferences!.getString("uid"),
      'buyerName': sharedPreferences!.getString("name"),
      'buyerPhone': sharedPreferences!.getString("phone"),
      "buyerOffer": offerController.text.trim(),
      "buyerDescription": offerDescriptionController.text.trim(),
      "buyerImage": sharedPreferences!.getString("image"),
      "publishedDate": date,
      "updatedDate": date,
    }).then((value) {
      Get.snackbar("Success", "Vehicle Added to Offer Successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
    });
  }

  carStream() {
  //   rent a car
    return FirebaseFirestore.instance
        .collection("vehicle")
        .where("vehicleStatus", isEqualTo: "Rent")
        .snapshots();
  }
}

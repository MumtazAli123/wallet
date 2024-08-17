import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:wallet/global/global.dart';

import '../../../../notification/push_notification_sys.dart';
import '../../../../widgets/mix_widgets.dart';
import '../views/show_products_view.dart';

class ProductsController extends GetxController {

  final pNameController = TextEditingController();
  final pPriceController = TextEditingController();
  final pDescriptionController = TextEditingController();
  final pBrandController = TextEditingController();
  final pQuantityController = TextEditingController();
  final pDiscountController = TextEditingController();
  final pColorController = TextEditingController();
  final pSizeController = TextEditingController();
  final pAddressController = TextEditingController();
  final pCityController = TextEditingController();

  List<String> pCategoryList = [
    "Electronics",
    "Phones",
    "Laptops",
    "Tablets",
    "Accessories & Parts",
    "Clothing",
    "Shoes",
    "Bags",
    "Fashion",
    "Home",
    "Appliances",
    "Beauty",
    "Toys",
    "Grocery",
    "Sports",
    "Books",
    "Stationery",
    "Others"
  ];
  List<String> pConditionList = ["New", "Used"];
  List<String> pDeliveryList = ["Yes", "No"];
  List<String> pReturnList = ["Yes", "No"];
  List<String> pDiscountTypeList = ["Percentage", "Amount"];
  List<String> pColorList = [
    "Red",
    "Blue",
    "Green",
    "Yellow",
    "Black",
    "White",
    "Sliver",
    "Grey",
    "Purple",
    "Pink",
    "Orange",
    "Brown"
  ];
  List<String> pSizeList = [
    "S",
    "M",
    "L",
    "XL",
    "XXL",
    "XXXL",
    "All Size",
    "4XL",
    "5XL",
    "6XL",
    "7XL",
    "8XL",
    "9XL",
    "10XL"
  ];

  String pCategoryValue = "Electronics";
  String pCondition = "New";
  String pDelivery = "Yes";
  String pReturn = "Yes";
  String pDiscountType = "Percentage";
  String pColor = "Red";
  String pSize = "S";

  bool uploading = false, next = false;
  List<String> urlList = [];
  double val = 0;

  final ImagePicker _picker = ImagePicker();
  List<XFile>? images = [];
  List<String> imageUrlPath = [];
  String downloadImageUrl = "";
  var imageFileCount = 0.obs;
  var pUniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  var productList = [].obs;

  @override
  void onInit() {
    super.onInit();
    pCategoryValue = pCategoryList[0];
    pCondition = pConditionList[0];
    pDelivery = pDeliveryList[0];
  }

  @override
  void onReady() {
  }

  @override
  void onClose() {
    pNameController.dispose();
    pPriceController.dispose();
    pDescriptionController.dispose();
    pBrandController.dispose();
    pQuantityController.dispose();
    pDiscountController.dispose();
    pColorController.dispose();
    pSizeController.dispose();
    pAddressController.dispose();
    pCityController.dispose();
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
              .child("$pUniqueId$i.jpg");
          fStorage.UploadTask uploadImageTask = storageRef.putFile(file);
          fStorage.TaskSnapshot taskSnapshot = await uploadImageTask;
          await taskSnapshot.ref.getDownloadURL().then((urlImage) {
            downloadImageUrl = urlImage;
          });
          addProducts();
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void addProducts() {
    try {
      FirebaseFirestore.instance
          .collection("sellers")
          .doc(user!.uid)
          .collection("products")
          .doc(pUniqueId)
          .set({
        "pUniqueId": pUniqueId,
        "pSellerId": user!.uid,
        "pSellerName": sharedPreferences!.getString("name"),
        "pSellerEmail": sharedPreferences!.getString("email"),
        "pSellerPhoto": sharedPreferences!.getString("image"),
        "pSellerAddress": sharedPreferences!.getString("address"),
        "pSellerPhone": sharedPreferences!.getString("phone"),
        "pSellerCity": sharedPreferences!.getString("city"),
        "pName": pNameController.text.trim(),
        "pPrice": pPriceController.text.trim(),
        "pDescription": pDescriptionController.text.trim(),
        "pBrand": pBrandController.text.trim(),
        "pQuantity": pQuantityController.text.trim(),
        "pDiscount": pDiscountController.text.trim(),
        "pCategory": pCategoryValue,
        "pCondition": pCondition,
        "pDelivery": pDelivery,
        "pReturn": pReturn,
        "pDiscountType": pDiscountType,
        "pColor": pColor,
        "pSize": pSize,
        "pImages": downloadImageUrl,
        "pCreatedAt": DateTime.now(),
      }).then((value) {
        FirebaseFirestore.instance.collection("products").doc(pUniqueId).set({
          "pUniqueId": pUniqueId,
          "pSellerId": user!.uid,
          "pSellerName": sharedPreferences!.getString("name"),
          "pSellerEmail": sharedPreferences!.getString("email"),
          "pSellerPhoto": sharedPreferences!.getString("image"),
          "pSellerAddress": sharedPreferences!.getString("address"),
          "pSellerPhone": sharedPreferences!.getString("phone"),
          "pSellerCity": sharedPreferences!.getString("city"),
          "pName": pNameController.text.trim(),
          "pPrice": pPriceController.text.trim(),
          "pDescription": pDescriptionController.text.trim(),
          "pBrand": pBrandController.text.trim(),
          "pQuantity": pQuantityController.text.trim(),
          "pDiscount": pDiscountController.text.trim(),
          "pCategory": pCategoryValue,
          "pCondition": pCondition,
          "pDelivery": pDelivery,
          "pReturn": pReturn,
          "pDiscountType": pDiscountType,
          "pColor": pColor,
          "pSize": pSize,
          "pImages": downloadImageUrl,
          "pCreatedAt": DateTime.now(),
        });

        Get.back();
        Get.snackbar("Success", "Product added successfully");
        Get.to(() =>  ShowProductsView());
        // PushNotificationSys().sendNotification(
        //     "New Product Added", "Product added successfully");
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  productsStream() {
    return FirebaseFirestore.instance
        .collection("sellers")
        .doc(user!.uid)
        .collection("products")
        .orderBy("publishedDate", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> searchProducts(String searchName) {
    return FirebaseFirestore.instance
        .collection("products")
        .orderBy("pName")
        .startAt([searchName]).endAt(["$searchName\uf8ff"])
        .limit(5)
        .snapshots();
  }

  void deleteProduct(String id) {
    try {
      FirebaseFirestore.instance
          .collection("sellers")
          .doc(user!.uid)
          .collection("products")
          .doc(id)
          .delete()
          .then((value) {
        FirebaseFirestore.instance.collection("products").doc(id).delete();
        Get.snackbar("Success", "Product deleted successfully", snackPosition: SnackPosition.BOTTOM);
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:like_button/like_button.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/models/products_model.dart';

import '../../../../notification/push_notification_sys.dart';
import '../../../../widgets/mix_widgets.dart';
import '../views/show_products_view.dart';
import '../views/tabbar/all_products.dart';

class ProductsController extends GetxController {
  TextEditingController pNameController = TextEditingController();
  TextEditingController pPriceController = TextEditingController();
  TextEditingController pDescriptionController = TextEditingController();
  TextEditingController pBrandController = TextEditingController();
  TextEditingController pQuantityController = TextEditingController();
  TextEditingController pDiscountController = TextEditingController();
  TextEditingController pColorController = TextEditingController();
  TextEditingController pSizeController = TextEditingController();
  TextEditingController pAddressController = TextEditingController();
  TextEditingController pCityController = TextEditingController();

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
    "Brown",
    "Gold",
    "Multi",
    "All Colors",
    "Others"
  ];
  List<String> pSizeList = [
    "S",
    "M",
    "L",
    "XL",
    "XXL",
    "XXXL",
    "All Size",
    "Others",
    "1ft",
    "2ft",
    "3ft",
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

  bool isFavorite = false;

  final ImagePicker _picker = ImagePicker();
  List<XFile>? images = [];
  List<String> imageUrlPath = [];
  String downloadImageUrl = "";
  var imageFileCount = 0.obs;
  var pUniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  var productList = [].obs;

  bool selected = false;

  final Rx<List> productsList = Rx<List>([]);

  List get allProductsDetails => productsList.value;

  var fabController;

  var quantity = 1.obs;
  var reFresh = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pNameController = TextEditingController();
    pPriceController = TextEditingController();
    pDescriptionController = TextEditingController();
    pBrandController = TextEditingController();
    pQuantityController = TextEditingController();
    pDiscountController = TextEditingController();
    pColorController = TextEditingController();
    pSizeController = TextEditingController();
    pAddressController = TextEditingController();
    pCityController = TextEditingController();
  }

  @override
  void onReady() {}

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
          .doc(sharedPreferences!.getString("uid"))
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
        "city": pCityController.text.trim(),
        "address": pAddressController.text.trim(),
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
          "city": pCityController.text.trim(),
          "address": pAddressController.text.trim(),
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
        Get.to(() => ShowProductsView());
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
        .doc(sharedPreferences!.getString("uid"))
        .collection("products")
        .orderBy("publishedDate", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> searchProducts(String searchName) {
    return FirebaseFirestore.instance
        .collection("products")
        .orderBy("pName")
        .startAt([searchName])
        .endAt(["$searchName\uf8ff"])
        .limit(5)
        .snapshots();
  }

  void deleteProduct(String id) {
    try {
      FirebaseFirestore.instance
          .collection("sellers")
          .doc(sharedPreferences!.getString("uid"))
          .collection("products")
          .doc(id)
          .delete()
          .then((value) {
        FirebaseFirestore.instance.collection("products").doc(id).delete();
        Get.snackbar("Success", "Product deleted successfully",
            snackPosition: SnackPosition.BOTTOM);
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  allProductsStream() {
    return FirebaseFirestore.instance
        .collection("products")
        .orderBy("pCreatedAt", descending: true)
        .snapshots();
  }

  Widget wBuildProductCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        wDialogMoreDetails(Get.context!, data);

        // Get.to(() => VehiclePageView(
        //     vModel: VehicleModel.fromJson(doc), doc: doc.toString()
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 2.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Image.network(
                      data['pImages'],
                      fit: BoxFit.fill,
                      height: 350,
                      width: double.infinity,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: LikeButton(
                        countPostion: CountPostion.right,
                        onTap: (isFavorite) async {
                          return !isFavorite;
                        },
                        likeBuilder: (isFavorite) {
                          return Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.white,
                            size: 30,
                          );
                        },
                      ),
                    ),
                    //   discount  show advance design
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.red,
                        child: data['pDiscountType'] == "Percentage"
                            ? Text(
                                '${data['pDiscount']}% OFF',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : wText('Rs: ${data['pDiscount']} OFF',
                                color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['pName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Brand: ${data['pBrand']}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    // description show
                    Text(
                      maxLines: 1,
                      "Desc: ${data['pDescription']}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 5),

                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // show price and cross after show discount price

                          Positioned(
                            right: 0,
                            child: Column(
                              children: [
                                Text(
                                  'Rs:${data['pPrice']}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    data['pDiscountType'] == "Percentage"
                                        ? 'Rs:${double.parse(data['pPrice']) - (double.parse(data['pPrice']) * double.parse(data['pDiscount']) / 100)}'
                                        : 'Rs:${double.parse(data['pPrice']) - double.parse(data['pDiscount'])}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  getProducts(String category) {
    return FirebaseFirestore.instance
        .collection("products")
        .where("pCategory", isEqualTo: category)
        .snapshots();
  }

  void editProducts(ProductsModel model) {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(user!.uid)
        .collection("products")
        .doc(model.pUniqueId)
        .update(model.toJson())
        .then((value) {
      FirebaseFirestore.instance
          .collection("products")
          .doc(model.pUniqueId)
          .update(model.toJson());
      Get.back();
      Get.snackbar("Success", "Vehicle Updated Successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
      // Get.to(() => const ShowVehicleView());
    });
  }

  getMoreProducts(String? pSellerId) {
    return FirebaseFirestore.instance
        .collection("products")
        .where("pSellerId", isEqualTo: pSellerId)
        .snapshots();
  }

  getRelatedProducts(String? pCategory) {
    return FirebaseFirestore.instance
        .collection("products")
        .where("pCategory", isEqualTo: pCategory)
        .snapshots();
  }

  void addToCart(ProductsModel vModel) {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("cart")
        .doc(vModel.pUniqueId)
        .set(vModel.toJson())
        .then((value) {
      Get.snackbar("Success", "Product added to cart successfully",
          snackPosition: SnackPosition.BOTTOM);
    });
  }

  void increaseQuantity(String? pQuantity) async{
    // check available quantity
    if (quantity.value == int.parse(pQuantity!)) {
      return;
    } else {
      quantity.value++;
    }

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("products")
        .doc(pUniqueId)
        .update({"pQuantity": pQuantityController.text.trim()});
    await FirebaseFirestore.instance
        .collection("products")
        .doc(pUniqueId)
        .update({"pQuantity": pQuantityController.text.trim()});

  }

  void decreaseQuantity(String? pQuantity) async{
    if (quantity.value == 1) {
      return;
    } else {
      quantity.value--;
    }

  await  FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("products")
        .doc(pUniqueId)
        .update({"pQuantity": quantity.value});
    await FirebaseFirestore.instance
        .collection("products")
        .doc(pUniqueId)
        .update({"pQuantity": quantity.value});

  }

  void increment() {
   //  when page chane quantity value is 1 auto refresh
    reFresh.value = 1;
    if (quantity.value == 20) {
      return;
    } else {
      quantity.value++;
    }


  }

  void decrement() {
    reFresh.value = 1;
    if (quantity.value == 1) {
      return;
    } else {
      quantity.value--;
    }
  }

}

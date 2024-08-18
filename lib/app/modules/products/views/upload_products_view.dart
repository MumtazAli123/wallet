// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet/app/modules/products/views/show_products_view.dart';
import 'package:wallet/widgets/mix_widgets.dart';

import '../../../../utils/translation.dart';
import '../controllers/products_controller.dart';

class UploadProductsView extends StatefulWidget {
  const UploadProductsView({super.key});

  @override
  State<UploadProductsView> createState() => _UploadProductsViewState();
}

class _UploadProductsViewState extends State<UploadProductsView> {
  final controller = Get.put(ProductsController());


  final List<File> _images = [];
  List<String> urlList = [];
  double val = 0;
  var pUniqueId = DateTime.now().millisecondsSinceEpoch.toString();
  XFile? imageFile;
  ImagePicker image = ImagePicker();

  bool isUpLoading = false;



  choseImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  uploadImages() async {
    int i = 1;
    for (var img in _images) {
      setState(() {
        val = i / _images.length;
      });
      var refImages = FirebaseStorage.instance.ref().child(
          'images/$pUniqueId.jpg');
      await refImages.putFile(img).whenComplete(() async {
        await refImages.getDownloadURL().then((urlImage) {
          urlList.add(urlImage);
        });
      });
    }
  }

  validateAndUploadForm() {
    if (imageFile == null) {
      Get.snackbar("Error", "Please select image");
      return;
    }if (controller.pDescriptionController.text.isEmpty ||
        controller.pDescriptionController.text.length < 3 &&
            controller.pDescriptionController.text.length > 200) {
      wGetSnackBar("Error", "Please enter description min 3 and max 200");
      return;
    } else if (controller.pPriceController.text.isEmpty ||
        controller.pPriceController.text.length < 3 &&
            controller.pPriceController.text.length > 20) {
      wGetSnackBar("Error", "Please enter Price from min 3 and max 20");
      return;
    }else if(controller.pDiscountController.text.isEmpty ||
        controller.pDiscountController.text.isEmpty &&
            controller.pDiscountController.text.length > 3){
      wGetSnackBar("Error", "Please enter discount min 1 and max 3");
      return;
      } else if (controller.pQuantityController.text.isEmpty ||
        controller.pQuantityController.text.isEmpty &&
            controller.pQuantityController.text.length > 20) {
      wGetSnackBar("Error", "Please enter quantity min 1 and max 20");
      return;
    }
    else {
      setState(() {
        isUpLoading = true;
      });
      controller.uploadImage();
    }
  }

  @override
  void initState() {
    super.initState();
    controller.selectMultipleImage();
  }

  @override
  Widget build(BuildContext context) {
    return imageFile == null ? defaultScreen() : uploadFormScreen();
  }

  Widget defaultScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: Image.asset(
          //     "assets/images/vendor.png",
          //   ).image,
          //   fit: BoxFit.contain,
          // ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Get.toNamed('/products');
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                title: Text(
                  Utils.dayTime(DateTime.now()),
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )),
            wTitleMedium(
              title: "Upload Products Images",
              subtitle: "Please select image for upload products",
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
                }),
            const SizedBox(height: 30.0),
            Lottie.asset('assets/lottie/card.json', height: 300),
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

  uploadFormScreen() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.to(() =>  ShowProductsView());
              },
              icon: const Icon(Icons.arrow_back),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.blue,
            actions: [
              //   uploadImage(),
              IconButton(
                  onPressed: () {
                    isUpLoading == true ? null : validateAndUploadForm();
                  },
                  icon: const Icon(Icons.upload, color: Colors.white)),
            ],
            title:  Text("Upload Products",
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
                              image: FileImage(File(controller.imageUrlPath[index])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            onPressed: () {
                              controller.imageUrlPath.removeAt(index);
                              controller.imageFileCount.value = controller.imageUrlPath.length;
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
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
                              image: FileImage(File(controller.imageUrlPath[index])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            onPressed: () {
                              controller.imageUrlPath.removeAt(index);
                              controller.imageFileCount.value = controller.imageUrlPath.length;
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // images
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GFButton(
                  size: 50,
                  onPressed: (){
                    if (controller.imageUrlPath.length < 5) {
                      obtainImageBox();
                    } else {
                      Get.snackbar("Error", "You can't select more than 8 images", backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  }, child:  wText("Select More Images")),
            ),
            // Product category
            Padding(padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Product Category",
                  hintText: "Select Product Category",
                  prefixIcon:  Icon(EvaIcons.tv),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.pCategoryValue,
                onChanged: (value) {
                  controller.pCategoryValue = value.toString();
                  setState(() {});
                },
                items: controller.pCategoryList.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
            // product name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wTextField(
                  keyboardType: "text",
                  controller: controller.pNameController,
                  labelText: "Product Name",
                  hintText: "Enter Product Name",
                  prefixIcon: EvaIcons.shoppingBag),
            ),
            // brand
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wTextField(
                  keyboardType: "text",
                  controller: controller.pBrandController,
                  labelText: "Brand Name",
                  hintText: "Enter Brand Name",
                  prefixIcon: Icons.branding_watermark),
            ),
            // price
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wTextField(
                  keyboardType: "number",
                  controller: controller.pPriceController,
                  labelText: "Product Price",
                  hintText: "Enter Product Price",
                  prefixIcon: Icons.money),
            ),
            // pDiscount
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wTextField(
                  keyboardType: "number",
                  controller: controller.pDiscountController,
                  labelText: "Product Discount",
                  hintText: "Enter Product Discount",
                  prefixIcon: Icons.money_off),
            ),
            //pDiscountType
            Padding(padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Product Discount Type",
                  hintText: "Select Product Discount Type",
                  prefixIcon:  Icon(EvaIcons.percent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.pDiscountType,
                onChanged: (value) {
                  controller.pDiscountType = value.toString();
                  setState(() {});
                },
                items: controller.pDiscountTypeList.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
            // pCondition
            Padding(padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Product Condition",
                  hintText: "Select Product Condition",
                  prefixIcon:  Icon(EvaIcons.calendar),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.pCondition,
                onChanged: (value) {
                  controller.pCondition = value.toString();
                  setState(() {});
                },
                items: controller.pConditionList.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
            // pQuantity
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wTextField(
                  keyboardType: "number",
                  controller: controller.pQuantityController,
                  labelText: "Product Quantity",
                  hintText: "Enter Product Quantity",
                  prefixIcon: Icons.add_shopping_cart),
            ),
            // pDelivery
            Padding(padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Product Delivery",
                  hintText: "Select Product Delivery",
                  prefixIcon:  Icon(Icons.delivery_dining),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.pDelivery,
                onChanged: (value) {
                  controller.pDelivery = value.toString();
                  setState(() {});
                },
                items: controller.pDeliveryList.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
            // pReturn
            Padding(padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Product Return",
                  hintText: "Select Product Return",
                  prefixIcon:  Icon(EvaIcons.repeat),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.pReturn,
                onChanged: (value) {
                  controller.pReturn = value.toString();
                  setState(() {});
                },
                items: controller.pReturnList.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),

            // pColor
            Padding(padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Product Color",
                  hintText: "Select Product Color",
                  prefixIcon:  Icon(EvaIcons.colorPalette),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.pColor,
                onChanged: (value) {
                  controller.pColor = value.toString();
                  setState(() {});
                },
                items: controller.pColorList.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
            // pSize
            Padding(padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Product Size",
                  hintText: "Select Product Size",
                  prefixIcon:  Icon(EvaIcons.options),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: controller.pSize,
                onChanged: (value) {
                  controller.pSize = value.toString();
                  setState(() {});
                },
                items: controller.pSizeList.map((e) {
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
                  controller: controller.pAddressController,
                  labelText: "Address",
                  hintText: "Enter Address",
                  prefixIcon: Icons.location_on),
            ),
            // city
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wTextField(
                  keyboardType: "text",
                  controller: controller.pCityController,
                  labelText: "City",
                  hintText: "Enter City",
                  prefixIcon: Icons.location_city),
            ),
            // description
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: controller.pDescriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Enter Products Description",
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
                    validateAndUploadForm();
                  },
                  child: wText("Upload Product")),
            ),


          ])),
    );
  }
}

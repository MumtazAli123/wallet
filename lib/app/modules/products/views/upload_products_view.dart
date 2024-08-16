// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:image_picker/image_picker.dart';
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


  bool uploading = false, next = false;
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
      Get.snackbar("Error", "Please enter description min 3 and max 200");
      return;
    } else if (controller.pPriceController.text.isEmpty ||
        controller.pPriceController.text.length < 3 &&
            controller.pPriceController.text.length > 20) {
      Get.snackbar("Error", "Please enter starting from min 3 and max 20");
      return;
    } else {
      setState(() {
        isUpLoading = true;
      });
      controller.uploadImage();
    }
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
                    Get.toNamed('/products');
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
                    if (controller.imageUrlPath.length < 8) {
                      obtainImageBox();
                    } else {
                      Get.snackbar("Error", "You can't select more than 8 images", backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  }, child:  wText("Select More Images")),
            ),
            // product name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wTextField(
                  keyboardType: "text",
                  controller: controller.pNameController,
                  labelText: "Product Name",
                  hintText: "Enter Product Name",
                  prefixIcon: Icons.home),
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
            // Product category
            Padding(padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Product Category",
                  hintText: "Select Product Category",
                  prefixIcon: const Icon(Icons.directions_car),
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
            // pCondition
            Padding(padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Product Condition",
                  hintText: "Select Product Condition",
                  prefixIcon: const Icon(Icons.directions_car),
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
            // pDelivery
            Padding(padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Product Delivery",
                  hintText: "Select Product Delivery",
                  prefixIcon: const Icon(Icons.directions_car),
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
                  prefixIcon: const Icon(Icons.directions_car),
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
            //pDiscountType
            Padding(padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Product Discount Type",
                  hintText: "Select Product Discount Type",
                  prefixIcon: const Icon(Icons.directions_car),
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
            // pColor
            Padding(padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Product Color",
                  hintText: "Select Product Color",
                  prefixIcon: const Icon(Icons.directions_car),
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
                  prefixIcon: const Icon(Icons.directions_car),
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
                    isUpLoading == true ? null : validateAndUploadForm();
                  }, child: wText("Upload Vehicle")),
            ),


          ])),
    );
  }
}

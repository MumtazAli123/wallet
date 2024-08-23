// ignore_for_file: must_be_immutable, library_prefixes, unused_import

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:wallet/app/modules/realstate/views/realstate_view.dart';
import 'package:wallet/models/realstate_model.dart';

import '../../../../global/global.dart';
import '../../../../models/brands.dart';
import '../../../../utils/translation.dart';
import '../../../../widgets/mix_widgets.dart';
import '../controllers/realstate_controller.dart';

class UploadRealstateView extends StatefulWidget {
  UploadRealstateView({super.key, this.models});

  Brands? models;

  @override
  State<UploadRealstateView> createState() => _UploadRealstateViewState();
}

class _UploadRealstateViewState extends State<UploadRealstateView> {
  final controller = Get.find<RealStateController>();
  XFile? imageFile;
  ImagePicker image = ImagePicker();

  final TextEditingController descriptionController =
  TextEditingController();
  final TextEditingController startingFromController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  List<String> parking = ['Bike', 'Car', 'Both', 'None', 'Other'];
  List<String> realStateFurnishing = ['Furnished', 'Semi-Furnished','Unfurnished','Other'];
  List<String> realStateCondition = ['New','Ready to move','Used','Under Construction', 'Other'];
  List<String> realStateStatus = ['Rent', 'Sale', 'Lease', 'Other'];
  List<String> realStateType = [ 'House','Apartment','Office','Land','Shop', "Portion", "Room", "Other"];
  String? realStateTypeValue;
  String? parkingValue;
  String? furnishingValue;
  String? conditionValue;
  String? realStateStatusValue;
  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String? likeCount = "5";

  final defaultCountry = RealStateModel(city: 'Pk', realStateName: 'Please select country');

  bool isUpLoading = false;
  String downloadImageUrl = "";
  String realStateUniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  validateAndUploadForm() {
    if (imageFile == null) {
      wGetSnackBar("Error", "Please select image");
      return;
    }if (descriptionController.text.isEmpty ||
        descriptionController.text.length < 3 &&
            descriptionController.text.length > 200) {
      wGetSnackBar("Error", "Please enter description min 3 and max 200");
      return;
    } else if (startingFromController.text.isEmpty ||
        startingFromController.text.length < 3 &&
            startingFromController.text.length > 20) {
      wGetSnackBar("Error", "Please enter starting from min 3 and max 20");
      return;
    //   if user use startingFromController , or . or latter after no select
    }else if(startingFromController.text.contains(",") || startingFromController.text.contains(".") || startingFromController.text.contains("a")){
      wGetSnackBar("Error", "Please enter starting from number only");
      return;
    }
    else {
      setState(() {
        isUpLoading = true;
      });
      uploadImage();
    }
  }

  uploadImage() async {
    showDialog(context: context, builder: (context) => wAppLoading(context));
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
        .ref()
        .child("hotelsImages")
        .child(imageFileName);
    fStorage.UploadTask uploadImageTask =
    storageRef.putFile(File(imageFile!.path));
    fStorage.TaskSnapshot taskSnapshot =
    await uploadImageTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      downloadImageUrl = urlImage;
    });
    saveHotelsInfo();
  }

  saveHotelsInfo() {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("realState")
        .doc(realStateUniqueId)
        .set({
      "realStateId": realStateUniqueId,
      "realStateType": realStateTypeValue,
      "country": countryValue,
      "state": stateValue,
      "city": cityValue,
      "currency": controller.currencyValue,
      "address": addressController.text.trim(),
      "sellerId": sharedPreferences!.getString("uid"),
      "sellerName": sharedPreferences!.getString("name"),
      "email": sharedPreferences!.getString("email"),
      "phone": sharedPreferences!.getString("phone"),
      "rating": sharedPreferences!.getString("rating"),
      "image": downloadImageUrl,
      "description": descriptionController.text.trim(),
      "startingFrom": startingFromController.text.trim(),
      "parking": parkingValue,
      "furnishing": furnishingValue,
      "condition": conditionValue,
      "likeCount": 5,
      "realStateStatus": realStateStatusValue,
      "status": "available",
      "publishedDate": DateTime.now(),
      "updatedDate": DateTime.now(),
    }).then((value) {
      FirebaseFirestore.instance.collection("realState").doc(realStateUniqueId).set({
        "realStateId": realStateUniqueId,
        "realStateType": realStateTypeValue,
        "country": countryValue,
        "state": stateValue,
        "city": cityValue,
        "currency": controller.currencyValue,
        "address": addressController.text.trim(),
        "sellerId": sharedPreferences!.getString("uid"),
        "sellerName": sharedPreferences!.getString("name"),
        "email": sharedPreferences!.getString("email"),
        "phone": sharedPreferences!.getString("phone"),
        "rating": sharedPreferences!.getString("rating"),
        "image": downloadImageUrl,
        "likeCount": "5",
        "description": descriptionController.text.trim(),
        "startingFrom": startingFromController.text.trim(),
        "parking": parkingValue,
        "furnishing": furnishingValue,
        "condition": conditionValue,
        "realStateStatus": realStateStatusValue,
        "status": "available",
        "publishedDate": DateTime.now(),
        "updatedDate": DateTime.now(),
      });
      setState(() {
        isUpLoading = false;
        realStateUniqueId = DateTime.now().millisecondsSinceEpoch.toString();
      });
      Get.to(() => const RealStateView());
      Get.snackbar("Success", "Real State Uploaded Successfully", backgroundColor: Colors.green, colorText: Colors.white);
    }).catchError((error) {
      setState(() {
        isUpLoading = false;
      });
      Get.snackbar("Error", error.toString());
    });
  }

  uploadFormScreen() {
    return Scaffold(
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
          leading: IconButton(
            onPressed: () {
              Get.toNamed('/realstate');
              // Navigator.pushNamed(context, '/upload');
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text("Upload Real State",
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
        body: ListView(
          children: [
            isUpLoading == true ? wLinearProgressBar(context) : const Text(""),
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(imageFile!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: "Select Real State",
                  border: OutlineInputBorder(),
                ),
                value: realStateTypeValue,
                onChanged: (newValue) {
                  setState(() {
                    realStateTypeValue = newValue.toString();
                  });
                },
                items: realStateType.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: Text(valueItem),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // conditionValue
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: "Select Condition",
                  border: OutlineInputBorder(),
                ),
                value: conditionValue,
                onChanged: (newValue) {
                  setState(() {
                    conditionValue = newValue.toString();
                  });
                },
                items: realStateCondition.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: Text(valueItem),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: "Select Furnishing",
                  border: OutlineInputBorder(),
                ),
                value: furnishingValue,
                onChanged: (newValue) {
                  setState(() {
                    furnishingValue = newValue.toString();
                  });
                },
                items: realStateFurnishing.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: Text(valueItem),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10.0),
            selectCountryCSCPicker(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: "Select Parking",
                  border: OutlineInputBorder(),
                ),
                value: parkingValue,
                onChanged: (newValue) {
                  setState(() {
                    parkingValue = newValue.toString();
                  });
                },
                items: parking.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: Text(valueItem),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: "Select Status",
                  border: OutlineInputBorder(),
                ),
                value: realStateStatusValue,
                onChanged: (newValue) {
                  setState(() {
                    realStateStatusValue = newValue.toString();
                  });
                },
                items: realStateStatus.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: Text(valueItem),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 2),
            // address
            Padding(padding: const EdgeInsets.all(8.0),
              child: wTextField(
                controller: addressController,
                hintText: "Enter Address",
                labelText: "Enter Address",
                keyboardType: "text",
                prefixIcon: Icons.location_city,

              ),
            ),
            const SizedBox(height: 2),
            // select currency
            Padding(padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: "Select Currency",
                  border: OutlineInputBorder(),
                ),
                value: "PKR",
                onChanged: (newValue) {
                  setState(() {
                    controller.currencyValue = newValue.toString();
                  });
                },
                items: controller.currencyList.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: Text(valueItem),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: startingFromController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter Price",
                  hintText: "Enter Price",
                  prefixIcon: Icon(Icons.money),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  isUpLoading == true ? null : validateAndUploadForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child:  wText("Upload", color: Colors.white),
              ),
            ),
          ],
        ));
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
              title: "Upload Real State Image",
              subtitle: "Please select image for upload real state",
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

  obtainImageBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  obtainImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  obtainImage(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  void obtainImage(ImageSource source) async {
    final pickedFile = await image.pickImage(source: source);
    setState(() {
      imageFile = pickedFile;
    });
  }

  selectCountryCSCPicker(){

    return  Container(
      padding: const EdgeInsets.all(10),
      child: CSCPicker(
        layout: Layout.vertical,

        showStates: true,

        showCities: true,


        // flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

        dropdownDecoration:  BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),

            border: Border.all(color: Colors.grey, width: 1)),

        disabledDropdownDecoration:  BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),

            border: Border.all(color: Colors.grey, width: 1)),


        selectedItemStyle: const TextStyle(

          fontSize: 14,
        ),

        dropdownHeadingStyle: const TextStyle(

            fontSize: 17,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline),

        dropdownItemStyle: const TextStyle(

          fontSize: 16,
        ),

        dropdownDialogRadius: 10.0,

        searchBarRadius: 10.0,

        onCountryChanged: (value) {
          setState(() {
            countryValue = value.toString();
          });
        },

        ///Call back function on state change [OPTIONAL PARAMETER]
        onStateChanged: (value) {
          setState(() {
            stateValue = value.toString();
          });
        },
        onCityChanged: (value) {
          setState(() {
            cityValue = value.toString();
          });
        },
      ),
    );
  }

}

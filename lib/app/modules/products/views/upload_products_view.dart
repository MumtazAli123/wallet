// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/widgets/mix_widgets.dart';

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

  choseImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  uploadImages() async {
    int i = 1;
    for (var img in _images) {
      setState(() {
        val = i / _images.length;
      });
      var refImages = await FirebaseStorage.instance.ref().child(
          'images/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg');
      await refImages.putFile(img).whenComplete(() async {
        await refImages.getDownloadURL().then((urlImage) {
          urlList.add(urlImage);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: wText('Upload Products '),
        centerTitle: true,
        actions: [
          next
              ? IconButton(
                  onPressed: () {
                    uploadImages().whenComplete(() {
                      setState(() {
                        next = false;
                        _images.clear();
                      });
                    });
                  },
                  icon: const Icon(Icons.upload),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      next = true;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
        ],
      ),
      body: next
          ? SingleChildScrollView()
          : Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 200,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length + 1,
                        itemBuilder: (context, index) {
                          return index == 0
                              ? Container(
                                  margin: const EdgeInsets.all(5),
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                  ),
                                  child: IconButton(
                                    onPressed: choseImage,
                                    icon: const Icon(Icons.add),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image:
                                                FileImage(_images[index - 1]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 5,
                                        top: 5,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _images.removeAt(index - 1);
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.loading,
                            title: 'Uploading...',
                        );
                        uploadImages().whenComplete(() {
                          Get.back();
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            title: 'Uploaded',
                          );
                          setState(() {
                            uploading = false;
                            _images.clear();
                          });
                        });
                      },
                      child: wText('Upload'),
                    ),
                  ],
                ),
                uploading
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              child: const CircularProgressIndicator(),
                            ),
                            const SizedBox(height: 10),
                            Text('${(val * 100).toStringAsFixed(0)} %'),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
    );
  }
}

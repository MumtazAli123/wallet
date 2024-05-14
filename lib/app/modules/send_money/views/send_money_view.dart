// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../models/user_model.dart';
import '../controllers/send_money_controller.dart';

class SendMoneyView extends StatefulWidget {
  final UserModel? loggedInUser;
  const SendMoneyView({super.key, this.loggedInUser});

  @override
  State<SendMoneyView> createState() => _SendMoneyViewState();
}

class _SendMoneyViewState extends State<SendMoneyView> {

  final controller = Get.put(SendMoneyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.loggedInUser!.name}"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller.searchController,
                onChanged: (value) {
                  controller.searchOtherUserList(value);
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isSearching.value) {
                  return ListView.builder(
                    itemCount: controller.searchList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(controller.searchList[index].name),
                        subtitle: Text(controller.searchList[index].email),
                        onTap: () {
                          controller.searchController.text = controller.searchList[index].name;
                          controller.isSearching.value = false;
                        },
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.otherUsers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(controller.otherUsers[index].name),
                        subtitle: Text(controller.otherUsers[index].email),
                        onTap: () {
                          controller.searchController.text = controller.otherUsers[index].name;
                          controller.isSearching.value = false;
                        },
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}


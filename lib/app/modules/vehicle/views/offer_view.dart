// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/models/vehicle_model.dart';

import '../../../../widgets/mix_widgets.dart';
import '../../profile/views/user_details_view.dart';

class OfferView extends StatefulWidget {
  final VehicleModel vehicle;
  const OfferView({super.key, required this.vehicle});

  @override
  State<OfferView> createState() => _OfferViewState();
}

class _OfferViewState extends State<OfferView> {
  final controller = Get.put(VehicleController());

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    controller.offerController.clear();
    controller.offerDescriptionController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          _buildDialog(vehicle: widget.vehicle, controller: controller);
        },
        label: aText('Make Offer'.tr, color: Colors.white),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              title: wText(widget.vehicle.vehicleName!,
                  size: 20, color: Colors.white),
              expandedHeight: 300,
              floating: false,
              pinned: true,
              flexibleSpace: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.vehicle.image!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: FlexibleSpaceBar(
                  background: Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.black.withOpacity(0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        aText(widget.vehicle.vehicleName!,
                            color: Colors.white, size: 20),
                        aText("Demand: ${widget.vehicle.vehiclePrice!}",
                            color: Colors.white, size: 18),
                        //   model
                        Text(
                          'Model: ${widget.vehicle.vehicleModel!}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ];
        },
        body: _buildBodyContent());
  }

  _buildBodyContent() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sellers')
            .doc(widget.vehicle.sellerId)
            .collection('vehicle')
            .doc(widget.vehicle.vehicleId)
            .collection('offers')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var offer = snapshot.data!.docs[index];
                  return _buildCard(offer: offer);
                });
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  void _buildDialog(
      {required VehicleModel vehicle, required VehicleController controller}) {
    QuickAlert.show(
      type: QuickAlertType.custom,
      context: context,
      title: 'Offer',
      text: 'Enter your offer price',
      width: 400,
      widget: Form(
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: Colors.black),
              controller: controller.offerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Offer Price'.splitMapJoin(' '),
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
      confirmBtnText: 'Submit',
      confirmBtnColor: Colors.green,
      onConfirmBtnTap: () {
        Get.back();
        if (controller.offerController.text.isNotEmpty) {
          _buyerOffer(
              vehicle: vehicle,
              controller: controller,
              buyerOffer: controller.offerController.text,
              buyerDescription: controller.offerDescriptionController.text);
        } else {
          Get.snackbar('Error', 'Please enter offer price', backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
    );
  }

  void _buyerOffer(
      {required VehicleModel vehicle,
      required VehicleController controller,
      required String buyerOffer,
      required String buyerDescription}) {
    try {
      FirebaseFirestore.instance
          .collection('sellers')
          .doc(vehicle.sellerId)
          .collection('vehicle')
          .doc(vehicle.vehicleId)
          .collection('offers')
          .add({
        'buyerOffer': buyerOffer,
        'buyerDescription': buyerDescription,
        'buyerId': sharedPreferences!.getString('uid'),
        'buyerName': sharedPreferences!.getString('name'),
        'buyerPhoto': sharedPreferences!.getString('image'),
        'sellerId': vehicle.sellerId,
        'sellerName': vehicle.sellerName,
        'vehicleId': vehicle.vehicleId,
        'vehicleName': vehicle.vehicleName,
        'vehiclePrice': vehicle.vehiclePrice,
        'vehicleImage': vehicle.image,
        'vehicleDescription': vehicle.vehicleDescription,
        'vehicleColor': vehicle.vehicleColor,
        'vehicleTransmission': vehicle.vehicleTransmission,
        'vehicleCondition': vehicle.vehicleCondition,
        'vehicleModel': vehicle.vehicleModel,
        'vehicleType': vehicle.vehicleType,
        'vehicleStatus': vehicle.vehicleStatus,
        "date": DateTime.now().toString(),
      });
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  _buildCard({required QueryDocumentSnapshot<Object?> offer}) {
    return SafeArea(
      child: Slidable(
        enabled: true,
          startActionPane: ActionPane(
            motion: ScrollMotion(),
            extentRatio: 0.25,
            closeThreshold: 0.2,

            children: [
              SlidableAction(
                padding: EdgeInsets.all(0),
                onPressed: (context) {
                  QuickAlert.show(
                    type: QuickAlertType.custom,
                    context: context,
                    title: 'Edit Offer',
                    text: 'Enter your offer price',
                    width: 400,
                    widget: Form(
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: controller.offerController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Offer Price',
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                    confirmBtnText: 'Submit',
                    confirmBtnColor: Colors.green,
                    onConfirmBtnTap: () {
                      Get.back();
                      // if current user is edit offer then update offer price
                      if (sharedPreferences!.getString('uid') == offer['buyerId']) {
                        FirebaseFirestore.instance
                            .collection('sellers')
                            .doc(offer['sellerId'])
                            .collection('vehicle')
                            .doc(offer['vehicleId'])
                            .collection('offers')
                            .doc(offer.id)
                            .update({
                          'buyerOffer': controller.offerController.text,
                        });
                      } else {
                        Get.snackbar('Error', 'You are not authorized to edit this offer', backgroundColor: Colors.red, colorText: Colors.white);
                      }
                    },
                  );
                },
                icon: Icons.edit,
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
                label: 'Edit',


              ),


          ],
          ),

          endActionPane: ActionPane(
            motion: ScrollMotion(),
            extentRatio: 0.25,
            closeThreshold: 0.2,

            children: [
            SlidableAction(
              flex: 6,
              padding: EdgeInsets.all(0),
              onPressed: (context) {
                // if current user is seller then delete offer or if current user is buyer then cancel offer
                if (sharedPreferences!.getString('uid') == offer['buyerId']) {
                  FirebaseFirestore.instance
                      .collection('sellers')
                      .doc(offer['sellerId'])
                      .collection('vehicle')
                      .doc(offer['vehicleId'])
                      .collection('offers')
                      .doc(offer.id)
                      .delete();
                  wGetSnackBar('Offer', 'Offer canceled successfully');
                }else{
                  Get.snackbar('Error', 'You are not authorized to delete this offer', backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
              icon: Icons.delete,
              foregroundColor: Colors.red,
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              label: 'Delete',
            ),

          ],
          ),

        child: Card(
          child: ListTile(
            onTap: () {
              Get.to(() => UserDetailsView(
                userID: offer['buyerId'],
              ));
            },
            leading: offer['buyerPhoto'] != null
                ? CircleAvatar(
              backgroundImage: NetworkImage(offer['buyerPhoto']),
            )
                : CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(offer['buyerName']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // in price show like this Offer Price: 1,000  or 1,000,000
                offer['buyerOffer'] != null
                    ? Text('Offer Price: ${offer['buyerOffer']}')
                    : Text('Offer Price: 0'),

                Text('Date: ${offer['date']}'.substring(0, 28)),
              ],
            ),
          ),
        ),

      ),
    );
  }
}

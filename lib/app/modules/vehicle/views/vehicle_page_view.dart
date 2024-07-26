// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';
import 'package:wallet/models/vehicle_model.dart';
import 'package:wallet/widgets/currency_format.dart';

import '../../../../widgets/mix_widgets.dart';

class VehiclePageView extends StatefulWidget {
  final String doc;
  final VehicleModel vModel;
  const VehiclePageView({super.key, required this.doc, required this.vModel});

  @override
  State<VehiclePageView> createState() => _VehiclePageViewState();
}

class _VehiclePageViewState extends State<VehiclePageView> {
  final controller = Get.put(VehicleController());

  void urlLauncher(String url, {bool? forceSafariVC}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<String> imageUrls = [];



  @override
  void initState() {
    super.initState();
  }

  Widget _buildProductsList() {
    return ScopedModelDescendant(
      builder: (context, child, VehicleModel model) {
        return ListView.builder(
          itemCount: model.vehicleType?.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(model.image![index][0]),
              ),
              title: Text(model.vehicleName![index]),
              subtitle: Text('\$${model.vehiclePrice![index].toString()}'),
              trailing: IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {},
                color: Colors.red,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(18.0),
        child: GFButtonBar(
          children: <Widget>[
            GFButton(
              onPressed: () {
                // email
                urlLauncher(
                  'mailto:${widget.vModel.email}'
                  '?subject=Vehicle Inquiry&body=Hello, I am interested in your vehicle ${widget.vModel.vehicleName}\n'
                  'Model: ${widget.vModel.vehicleModel} ${widget.vModel.vehicleType}\n'
                  'Description: ${widget.vModel.vehicleDescription}\n'
                  'Price: ${widget.vModel.vehiclePrice}\n'
                  'Type: ${widget.vModel.vehicleTransmission}\n'
                  'Color: ${widget.vModel.vehicleColor}'
                  '\n\nThank you\n',
                );
              },
              text: 'Email',
              icon: Icon(Icons.email),
              type: GFButtonType.outline,
              shape: GFButtonShape.pills,
            ),
            GFButton(
              onPressed: () {
                // call
                urlLauncher('tel:${widget.vModel.phone}');
              },
              text: 'Call',
              icon: Icon(Icons.phone),
              type: GFButtonType.outline,
              shape: GFButtonShape.pills,
            ),
            //   price != null
            GFButton(
              onPressed: () {
                // price
              },
              // rs 1000.00, like 1m 2 hundred 3 thousand 4 hundred 5 rupees
              text: 'Rs: ${(widget.vModel.vehiclePrice)}',
              textStyle: GoogleFonts.roboto(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
              ),
              // icon: Icon(Icons.money),
              type: GFButtonType.outline,
              shape: GFButtonShape.pills,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.green[800],
        // whatsapp
        onPressed: () {
          urlLauncher(
              'https://wa.me/${widget.vModel.phone}'
              '?text=Hello, I am interested in your vehicle Name: ${widget.vModel.vehicleName},'
              '\nType: ${widget.vModel.vehicleTransmission},'
              '\nModel: ${widget.vModel.vehicleModel}'
              '- ${widget.vModel.vehicleType}'
              '\nDescription: ${widget.vModel.vehicleDescription}\n'
              'Price: ${widget.vModel.vehiclePrice}'
              '\nColor: ${widget.vModel.vehicleColor}',
              forceSafariVC: false);
        },
        child: Image.asset('assets/images/whatsapp.png'),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
            expandedHeight: 400.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  ": ${widget.vModel.showroomName!}",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              background: Image.network(
                widget.vModel.image!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ];
      },
      body: SafeArea(
        child: ListView(
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          shrinkWrap: true,
          children: [
            ListTile(
              leading: Icon(Icons.directions_car, color: Colors.blue[800]),
              title: aText('Vehicle: ${widget.vModel.vehicleName}'),
              subtitle: aText('For: ${widget.vModel.vehicleStatus}'),
            ),
            ListTile(
              // if color  then show same color icon
              leading: Icon(
                Icons.money,
                color: Colors.blue[800],
              ),
              title: aText('Model: ${widget.vModel.vehicleModel}'),
              subtitle: aText('Color: ${widget.vModel.vehicleColor}'
                  '\nCondition: ${widget.vModel.vehicleCondition}\n'
                  '${widget.vModel.status}'),
            ),
            ListTile(
              leading: Icon(
                Icons.description,
                color: Colors.blue[800],
              ),
              title:
                  aText('Vehicle Type: ${widget.vModel.vehicleTransmission}'),
            ),
            ListTile(
              leading: Icon(
                Icons.directions_car,
                color: Colors.blue[800],
              ),
              title: aText('Vehicle Body: ${widget.vModel.vehicleBodyType}'),
            ),
            ListTile(
              leading: Icon(
                Icons.money,
                color: Colors.blue[800],
              ),
              title: aText('Km: ${widget.vModel.vehicleKm.toString()}'),
            ),
            ListTile(
              leading: Icon(
                Icons.email,
                color: Colors.blue[800],
              ),
              title: aText('Vehicle Fuel: ${widget.vModel.vehicleFuelType}'),
            ),
            ListTile(
              onTap: () {
                // call
                urlLauncher('tel:${widget.vModel.phone}');
              },
              leading: Icon(Icons.description, color: Colors.blue[800]),
              title: aText('Description: '),
              subtitle:
                  aText('${widget.vModel.vehicleDescription}', size: 12.0),
            ),
            // price
            ListTile(
                leading: Icon(
                  Icons.money,
                  color: Colors.blue[800],
                ),
                title: aText('Price: ${widget.vModel.vehiclePrice}'),
                subtitle: aText(
                  size: 10.0,
                  // rs 1000.00, like 1m 2 hundred 3 thousand 4 hundred 5 rupees
                  NumberToWord().convert(
                      widget.vModel.vehiclePrice.toString().isNotEmpty
                          ? int.parse(widget.vModel.vehiclePrice.toString())
                          : 0),
                )),
            ListTile(
              leading: Icon(
                Icons.date_range,
                color: Colors.blue[800],
              ),
              title: aText('Vehicle Update: Time'),
              subtitle: Text(
                "Upload: ${(GetTimeAgo.parse(DateTime.parse(widget.vModel.updatedDate!.toDate().toString()).toLocal()))}",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

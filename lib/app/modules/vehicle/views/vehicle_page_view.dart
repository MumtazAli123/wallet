// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';
import 'package:wallet/models/vehicle_model.dart';

import '../../../../widgets/mix_widgets.dart';

class VehiclePageViewView extends GetView<VehicleController> {
  final String doc;
  final VehicleModel vModel;
  const VehiclePageViewView({super.key, required this.doc, required this.vModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding:  EdgeInsets.all(18.0),
        child:GFButtonBar(
          children: <Widget>[
            GFButton(
              onPressed: () {
                // email
                launch('mailto:${vModel.email}' '?subject=Vehicle Inquiry&body=Hello, I am interested in your vehicle ${vModel.vehicleName}');
              },
              text: 'Email',
              icon: Icon(Icons.email),
              type: GFButtonType.outline,
              shape: GFButtonShape.pills,
            ),
            GFButton(
              onPressed: () {
                // call
                launch('tel:${vModel.phone}');
              },
              text: 'Call',
              icon: Icon(Icons.phone),
              type: GFButtonType.outline,
              shape: GFButtonShape.pills,
            ),
          //   price != null
            GFButton(onPressed: () {
              // price
            },
              text: 'Rs: ${vModel.vehiclePrice}.00',
              textStyle: GoogleFonts.roboto(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
              ),
              icon: Icon(Icons.money),
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
          launch('https://wa.me/${vModel.phone}');
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
                  icon:  const Icon(Icons.close, color: Colors.white),
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
                    ": ${vModel.showroomName!}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                background: Image.network(
                  vModel.image.toString(),
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
              leading:  Icon(Icons.directions_car, color: Colors.blue[800]),
              title: aText('Vehicle: ${vModel.vehicleType}'),
              subtitle: aText('Name: ${vModel.vehicleName}\nFor : ${ vModel.vehicleStatus}'),
            ),
            ListTile(
              // if color  then show same color icon
              leading:  Icon(Icons.money, color: Colors.blue[800],),
              title: aText('Model: ${vModel.vehicleModel}'),
              subtitle: aText('Color: ${vModel.vehicleColor}'
                  '\nCondition: ${vModel.vehicleCondition}\n'
                  '${vModel.status}'),
            ),
            ListTile(
              leading:  Icon(Icons.description, color: Colors.blue[800],),
              title: aText('Vehicle Type: ${vModel.vehicleTransmission}'),
            ),
            ListTile(
              leading:  Icon(Icons.directions_car, color: Colors.blue[800],),
              title: aText('Vehicle Engine: ${vModel.vehicleBodyType}'),
            ),
            ListTile(
              leading:  Icon(Icons.money, color: Colors.blue[800],),
              title: aText('Km: ${vModel.vehicleKm.toString()}'),
            ),
            ListTile(
              onTap: () {
                // email
                // launch('mailto:${vModel.email}' + '?subject=Vehicle Inquiry&body=Hello, I am interested in your vehicle ${vModel.vehicleName}');
              },
              leading:  Icon(Icons.email, color: Colors.blue[800],),
              title: aText('Vehicle Fuel: ${vModel.vehicleFuelType}'),
            ),
            ListTile(
              onTap: () {
                // call
                launch('tel:${vModel.phone}');
              },
              leading:  Icon(Icons.description,color: Colors.blue[800]),
              title: aText('Description: '),
              subtitle: aText('${vModel.vehicleDescription}'),
            ),
            ListTile(
              leading:  Icon(Icons.date_range, color: Colors.blue[800],),
              title: aText('Vehicle Update: Time'),
              subtitle:Text (
              "Upload: ${(GetTimeAgo.parse(DateTime.parse(vModel.updatedDate!.toDate().toString()).toLocal()))}",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

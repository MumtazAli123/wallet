import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet/app/modules/realstate/controllers/realstate_controller.dart';
import 'package:wallet/models/realstate_model.dart';

import '../../../../../widgets/currency_format.dart';
import '../../../../../widgets/mix_widgets.dart';

class RealstateViewPage extends GetView<RealStateController> {
  final String doc;
  final RealStateModel rsModel;
  const RealstateViewPage(
      {super.key, required this.rsModel, required this.doc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // whatsApp
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          // whatsApp
          launch(
              'https://wa.me/${rsModel.phone}?text=ZubiPay\nHello, I am interested in your property\n'
              '${rsModel.realStateType} for ${rsModel.realStateStatus}\n'
              'Description: ${rsModel.description}\n'
              'Price: ${rsModel.startingFrom}\n'
              'Type: ${rsModel.status}\n'
              'City: ${rsModel.city}\n'
              'State: ${rsModel.state}\n'
              'Country: ${rsModel.country}\n'
              'Phone: ${rsModel.phone}\n'
              'Email: ${rsModel.email}\n');
        },
        child: Image.asset(
          'assets/images/whatsapp.png',
          height: 50,
          width: 50,
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(18.0),
        child: GFButtonBar(
          children: <Widget>[
            GFButton(
              onPressed: () {
                // email
                urlLauncherA(
                  'mailto:${rsModel.email}?subject=Realstate Inquiry&body=Hello, I am interested in your property ${rsModel.realStateType}\n'
                  'Name: ${rsModel.realStateName}\n'
                  'Condition: ${rsModel.realStateType} ${rsModel.condition}\n'
                  'Description: ${rsModel.description}\n'
                  'Price: ${rsModel.startingFrom}\n'
                  'Type: ${rsModel.status}\n'
                  '${rsModel.furnishing}\n'
                  'City: ${rsModel.city}\n'
                  'State: ${rsModel.state}\n'
                  'Country: ${rsModel.country}\n'
                  'Phone: ${rsModel.phone}\n'
                  'Email: ${rsModel.email}\n',
                );
              },
              text: 'Email',
              icon: const Icon(Icons.email),
              type: GFButtonType.outline,
              shape: GFButtonShape.pills,
            ),
            GFButton(
              onPressed: () {
                // call
                urlLauncherA("tel:${rsModel.phone.toString()}");
              },
              text: 'Call',
              icon: const Icon(Icons.phone),
              type: GFButtonType.outline,
              shape: GFButtonShape.pills,
            ),
            //   price != null
            GFButton(
              onPressed: () {
                // price
              },
              // rs 1000.00, like 1m 2 hundred 3 thousand 4 hundred 5 rupees
              text: rsModel.currency == "AED"
                  ? '${rsModel.currency}: ${rsModel.startingFrom}'.splitMapJoin(
                      RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                      onMatch: (m) => '${m[1]},')
                  : 'Rs: ${rsModel.startingFrom}'.splitMapJoin(
                      RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                      onMatch: (m) => '${m[1]},'),
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
      // backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
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
              expandedHeight: 400,
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
                    rsModel.realStateType!,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                background: Image.network(
                  rsModel.image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.real_estate_agent),
              title: aText(rsModel.realStateType.toString()),
              subtitle:
                  aText("For ${rsModel.realStateStatus.toString()}", size: 12),
            ),
            // condition and disc
            ListTile(
              leading: const Icon(Icons.info),
              title: aText("Condition: ${rsModel.furnishing.toString()}"),
              subtitle: aText("Now: ${rsModel.condition.toString()}", size: 12),
            ),
            // description
            ListTile(
              leading: const Icon(
                Icons.description,
                color: Colors.green,
              ),
              title: aText("Description:"),
              subtitle: Text(
                rsModel.description.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.location_on,
                color: Colors.red,
              ),
              title: aText("City: ${rsModel.city.toString()}"),
              subtitle: aText("State: ${rsModel.state.toString()}", size: 12),
              trailing: aText(rsModel.country.toString(), size: 12),
            ),
            // address
            ListTile(
              leading: const Icon(Icons.location_city),
              title: aText("Address:"),
              subtitle: aText(rsModel.address.toString(), size: 12),
            ),
            // price
            ListTile(
                leading: Icon(
                  Icons.money,
                  color: Colors.orange[900],
                ),
                title: rsModel.currency == "AED"
                    ? aText('${rsModel.currency}: ${rsModel.startingFrom}'.splitMapJoin(
                        RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                        onMatch: (m) => '${m[1]},'))
                    : aText('Rs: ${rsModel.startingFrom}'.splitMapJoin(
                        RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                        onMatch: (m) => '${m[1]},')),
                subtitle: aText(
                  size: 12.0,
                  // rs 1000.00, like 1m 2 hundred 3 thousand 4 hundred 5 rupees
                  NumberToWord().convert(
                      rsModel.startingFrom.toString().isNotEmpty
                          ? int.parse(rsModel.startingFrom.toString())
                          : 0),
                )),
            // status
            ListTile(
              leading: const Icon(Icons.info),
              title: aText("Status: ${rsModel.status.toString()}"),
            ),
            // seller details
            ListTile(
              leading: const Icon(Icons.person),
              title: aText("Seller: Boss ${rsModel.sellerName.toString()}"),
            ),

            //     contact details
            Card(
              child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  splashColor: Colors.green,
                  onTap: () {
                    urlLauncherA("tel:${rsModel.phone.toString()}");
                  },
                  leading: const Icon(Icons.phone),
                  title: aText("Phone: ${rsModel.phone.toString()}"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  subtitle: const Text("Click to call",
                      style: TextStyle(fontSize: 12))),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  urlLauncherA("mailto:${rsModel.email.toString()}");
                },
                splashColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                leading: const Icon(Icons.contact_mail),
                title: aText("Email: ${rsModel.email.toString()}"),
                subtitle: const Text("Click to send email",
                    style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.send),
              ),
            ),
            //   upload date
            ListTile(
              leading: const Icon(Icons.date_range),
              title: aText(
                "Upload: ${(GetTimeAgo.parse(DateTime.parse(rsModel.updatedDate!.toDate().toString()).toLocal()))}",
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

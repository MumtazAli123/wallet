import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet/app/modules/realstate/controllers/realstate_controller.dart';
import 'package:wallet/models/realstate_model.dart';

import '../../../../../widgets/mix_widgets.dart';

class RealstateViewPage extends GetView<RealStateController> {
  final String doc;
  final RealStateModel rsModel;
  const RealstateViewPage(
      {super.key, required this.rsModel, required this.doc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.green,
        onPressed: () {
           launch(
              "https://wa.me/${rsModel.phone.toString()}?text= ${rsModel.realStateType.toString()} \nFor ${rsModel.realStateStatus.toString()} \nCondition: ${rsModel.furnishing.toString()} \nNow: ${rsModel.condition.toString()} \nDescription: ${rsModel.description.toString()} \nCity: ${rsModel.city.toString()} \nState: ${rsModel.state.toString()} \nCountry: ${rsModel.country.toString()} \nHello, I am interested in your property. Can you please provide me more details?");

        },
        child: Image.asset("assets/images/whatsapp.png"),
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
                    icon:  const Icon(Icons.close, color: Colors.white),
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
                trailing: aText("RS: ${rsModel.startingFrom.toString()}"),
              ),
              // condition and disc
              ListTile(
                leading: const Icon(Icons.info),
                title: aText("Condition: ${rsModel.furnishing.toString()}"),
                subtitle: aText("Now: ${rsModel.condition.toString()}", size: 12),
              ),
              // description
              ListTile(
                leading: const Icon(Icons.description),
                title: aText("Description:"),
                subtitle: Text(
                  rsModel.description.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: aText("City: ${rsModel.city.toString()}"),
                subtitle: aText("State: ${rsModel.state.toString()}", size: 12),
                trailing: aText(rsModel.country.toString(), size: 12),
              ),
              //     contact details
              Card(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                  splashColor: Colors.green,
                  onTap: (){
                    launch("tel:${rsModel.phone.toString()}");
                  },
                  leading: const Icon(Icons.phone),
                  title: aText("Phone: ${rsModel.phone.toString()}"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  subtitle: const Text("Click to call", style: TextStyle(fontSize: 12))
                
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    launch("mailto:${rsModel.email.toString()}");
                  },
                  splashColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  leading: const Icon(Icons.contact_mail),
                  title: aText("Email: ${rsModel.email.toString()}"),
                  subtitle: const Text("Click to send email", style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.send),
                
                ),
              ),
            ]),
          ),
        ),

    );
  }

  _buildRealstateView() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    centerTitle: true,
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
              body: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.real_estate_agent),
                    title: aText(rsModel.realStateType.toString()),
                    subtitle: aText("For ${rsModel.realStateStatus.toString()}",
                        size: 12),
                    trailing: aText("RS: ${rsModel.startingFrom.toString()}"),
                  ),
                  // condition and disc
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: aText("Condition: ${rsModel.furnishing.toString()}"),
                    subtitle: aText("Now: ${rsModel.condition.toString()}",
                        size: 12),
                  ),
                  // description
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: aText("Description:"),
                    subtitle: Text(
                      rsModel.description.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: aText("City: ${rsModel.city.toString()}"),
                    subtitle: aText("State: ${rsModel.state.toString()}",
                        size: 12),
                    trailing: aText(rsModel.country.toString(), size: 12),
                  ),
                  //     contact details
                  ListTile(
                      onTap: () {
                        launch("tel:${rsModel.phone.toString()}");
                      },
                      leading: const Icon(Icons.phone),
                      title: aText("Phone: ${rsModel.phone.toString()}"),
                      subtitle: const Text("Click to call",
                          style: TextStyle(fontSize: 12))),
                  ListTile(
                    onTap: () {
                      launch("mailto:${rsModel.email.toString()}");
                    },
                    leading: const Icon(Icons.contact_mail),
                    title: aText("Email: ${rsModel.email.toString()}?text= ${rsModel.realStateType.toString()} \nFor ${rsModel.realStateStatus.toString()} \nCondition: ${rsModel.furnishing.toString()} \nNow: ${rsModel.condition.toString()} \nDescription: ${rsModel.description.toString()} \nCity: ${rsModel.city.toString()} \nState: ${rsModel.state.toString()} \nCountry: ${rsModel.country.toString()} \nHello, I am interested in your property. Can you please provide me more details?"),
                    subtitle: const Text("Click to send email",
                        style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:wallet/app/modules/realstate/views/realstate_edit_view.dart';
import 'package:wallet/app/modules/realstate/views/tabbar/realstate_view_page.dart';
import 'package:wallet/models/realstate_model.dart';

import '../../../../widgets/mix_widgets.dart';
import '../controllers/realstate_controller.dart';

class RealStateUiDesignWidget extends StatefulWidget {
  final RealStateModel? model;
  final BuildContext? context;
   const RealStateUiDesignWidget({super.key, this.model, this.context});

  @override
  State<RealStateUiDesignWidget> createState() => _RealStateUiDesignWidgetState();
}

class _RealStateUiDesignWidgetState extends State<RealStateUiDesignWidget> {
  final controller = Get.find<RealStateController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _buildBottomSheet(context, widget.model);
      },
      // child: Container(
      //   margin: const EdgeInsets.all(10),
      //   decoration: BoxDecoration(
      //     color: controller.isUpLoading.isTrue
      //         ? Colors.grey.withOpacity(0.5)
      //         : Colors.white,
      //     borderRadius: BorderRadius.circular(10),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey.withOpacity(0.5),
      //         spreadRadius: 5,
      //         blurRadius: 7,
      //         offset: const Offset(0, 3), // changes position of shadow
      //       ),
      //     ],
      //   ),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Container(
      //         height: 200,
      //         width: double.infinity,
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(10),
      //           image: DecorationImage(
      //             image: NetworkImage(widget.model!.image.toString()),
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //         child: Align(
      //           alignment: Alignment.topRight,
      //           child: IconButton(
      //             onPressed: () {
      //               controller.deleteRealState(widget.model!.realStateId.toString());
      //             },
      //             icon: const Icon(
      //               Icons.delete,
      //               color: Colors.red,
      //             ),
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 10),
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         children: [
      //           ListTile(
      //             leading: Icon(
      //               Icons.home,
      //               color: Colors.orange,
      //             ),
      //             title: aText(widget.model!.realStateType.toString(), size: 20),
      //             subtitle: aText(widget.model!.condition.toString(), size: 16),
      //             trailing: aText(widget.model!.description.toString(), size: 16),
      //           ),
      //           ListTile(
      //             leading: Icon(
      //               Icons.location_on,
      //               color: Colors.orange,
      //
      //             ),
      //             title: aText(widget.model!.city.toString(), size: 20),
      //             trailing: aText(widget.model!.state.toString(), size: 16),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      //
      // ),
      child: GFCard(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        semanticContainer: true,
        showImage: true,
        image: Image.network(widget.model!.image.toString(), fit: BoxFit.cover, height: 200, width: double.infinity,),
        colorFilter:
        ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
        title: GFListTile(
          title: Row(
            children: [
              controller.countryValue.value == 'India'
                  ? GFAvatar(
                backgroundImage: NetworkImage(controller.user!.photoURL!),
              )
                  : GFAvatar(
                size: 15,
                child: Text(widget.model!.realStateType![0]),
              ),
              SizedBox(width: 10.0),
              wText('${widget.model!.realStateType} For ${widget.model!.realStateStatus!}'),
            ],
          ),
          subTitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.blueAccent,
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('City: ${widget.model!.city}'),
                    Text('State: ${widget.model!.state}'),
                    widget.model!.currency == "AED"
                        ? Text('${widget.model!.currency}: ${widget.model!.startingFrom}')
                        : Text('Rs: ${widget.model!.startingFrom}'),
                  ],
                )
              ],
            ),
          ),
        ),
        buttonBar: GFButtonBar(
          children: <Widget>[
            GFButton(
              onPressed: () {
                Get.to(() => RealstateViewPage(
                    rsModel: RealStateModel.fromJson(widget.model!.toJson()), doc: '',));
              },
              text: 'View',
              color: Colors.blue,
            ),
            GFButton(
              onPressed: () {
                Get.to(() => RealstateEditView(
                  model: widget.model!,
                ));
              },
              text: 'Edit',
              color: Colors.green,
            ),
            GFButton(
              onPressed: () {
                _buildAlertDialog(widget.model!.realStateId.toString());
              },
              text: 'Delete',
              color: Colors.red,
            ),
          ],
        ),

      ),
    );
  }
  void _buildAlertDialog(id) {
    QuickAlert.show(
      // delete dialog
        context: Get.context!,
        type: QuickAlertType.warning,
        title: 'Delete Realstate',
        text: 'Are you sure you want to delete this realstate?',
        width: 400,
        showConfirmBtn: false,
        widget: Column(
          children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GFButton(
                  onPressed: () {
                    controller.deleteRealState(id);
                    Get.back();
                  },
                  text: 'Delete',
                  color: Colors.red,
                ),
                GFButton(
                  onPressed: () {
                    Get.back();
                  },
                  text: 'No',
                  color: Colors.green,
                ),
              ],
            ),
          ],
        )

    );
  }
  void _buildBottomSheet(BuildContext context, RealStateModel? model) {
    showModalBottomSheet(
      clipBehavior: Clip.antiAlias,
      showDragHandle: true,
      isDismissible: true,
      context: context,
      builder: (context) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              height: 100,
              // width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(model!.image.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: aText(model.realStateType.toString(), size: 20),
              subtitle: aText(model.description.toString(), size: 12),
              trailing: aText(model.realStateStatus.toString(), size: 16),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: aText(model.city.toString(), size: 20),
              trailing: aText(model.state.toString(), size: 16),
            ),
            ListTile(
              leading:  const Icon(
                Icons.phone,
                color: Colors.orange,),
              title: aText(model.phone.toString(), size: 20),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Get.toNamed('/moreDetails', arguments: model);
              },
              child:  wText('Add to More Details', color: Colors.white),
            ),
          ],
        );
      },
    );
  }
}

// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: controller.isUpLoading.isTrue
              ? Colors.grey.withOpacity(0.5)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(widget.model!.image.toString()),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    controller.deleteRealState(widget.model!.realStateId.toString());
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.orange,
                  ),
                  title: aText(widget.model!.realStateType.toString(), size: 20),
                  subtitle: aText(widget.model!.condition.toString(), size: 16),
                  trailing: aText(widget.model!.description.toString(), size: 16),
                ),
                ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: Colors.orange,

                  ),
                  title: aText(widget.model!.city.toString(), size: 20),
                  trailing: aText(widget.model!.state.toString(), size: 16),
                ),
              ],
            ),
          ],
        ),

      ),
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

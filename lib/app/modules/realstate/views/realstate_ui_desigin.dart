
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
        Get.toNamed('/realstate-details', arguments: widget.model);
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
}

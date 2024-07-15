import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:wallet/app/modules/realstate/controllers/realstate_controller.dart';
import 'package:wallet/models/realstate_model.dart';

import '../../../../widgets/mix_widgets.dart';

class RealstateEditView extends GetView<RealStateController> {
  final RealStateModel model;
  const RealstateEditView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aText('Edit Real State'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildForm(),
          _buildButton(),
        ],
      ),
    );
  }

  _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              value: model.realStateType,
              items: controller.realStateType
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                model.realStateType = value;
              },
            ),
          ),

          Padding(padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            value: model.realStateStatus,
            items: controller.realStateStatus
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (value) {
              model.realStateStatus = value;
            },
          ),
          ),
          // condition
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              value: model.condition,
              items: controller.realStateCondition
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: (value) {
                model.condition = value;
              },
            ),
          ),


          // description
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: model.description,
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                model.description = value;
              },
            ),
          ),
        //   price
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: model.startingFrom.toString(),
              decoration: const InputDecoration(labelText: 'Price'),
              onChanged: (value) {
                model.startingFrom = double.parse(value) as String?;
              },
            ),
          ),

        ],
      ),
    );

  }

  _buildButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GFButton(
        onPressed: () {
          controller.editRealState(model);
        },
        text: 'Update',
        color: Colors.blue,
      ),
    );
  }



}


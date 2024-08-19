import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:wallet/app/modules/realstate/controllers/realstate_controller.dart';
import 'package:wallet/models/realstate_model.dart';

import '../../../../widgets/mix_widgets.dart';

class RealstateEditView extends StatefulWidget {
  final RealStateModel model;
  const RealstateEditView({super.key, required this.model});

  @override
  State<RealstateEditView> createState() => _RealstateEditViewState();
}

class _RealstateEditViewState extends State<RealstateEditView> {
  final controller = Get.put(RealStateController());



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
              value: widget.model.realStateType,
              items: controller.realStateType
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  widget.model.realStateType = value;
                });
              },
            ),
          ),

          Padding(padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            value: widget.model.realStateStatus,
            items: controller.realStateStatus
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                widget.model.realStateStatus = value;
              });
            },
          ),
          ),
          // condition
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              value: widget.model.condition,
              items: controller.realStateCondition
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  widget.model.condition = value;
                });
              },
            ),
          ),


          // description
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: widget.model.description,
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                setState(() {
                  widget.model.description = value;
                });
              },
            ),
          ),
        //   price
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: widget.model.startingFrom.toString(),
              decoration: const InputDecoration(labelText: 'Price'),
              onChanged: (value) {
                widget.model.startingFrom = value;
              },
            ),
          ),
        //   city
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: widget.model.city,
              decoration: const InputDecoration(labelText: 'City'),
              onChanged: (value) {
                widget.model.city = value;
              },
            ),
          ),
        //   address
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: widget.model.address,
              decoration: const InputDecoration(labelText: 'Address'),
              onChanged: (value) {
                setState(() {
                  widget.model.address = value;
                });
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
          controller.editRealState(widget.model);
        },
        text: 'Update',
        color: Colors.blue,
      ),
    );
  }
}


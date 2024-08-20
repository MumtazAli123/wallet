import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/app/modules/register/controllers/register_controller.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';
import 'package:wallet/models/vehicle_model.dart';

class VehicleEditView extends StatefulWidget {
  final VehicleModel model;
  const VehicleEditView({super.key, required this.model});

  @override
  State<VehicleEditView> createState() => _VehicleEditViewState();
}

class _VehicleEditViewState extends State<VehicleEditView> {
  final controller = Get.put(VehicleController());
  final controller1 = Get.put(RegisterController());

  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  var hintText = 'Email';


  @override
  void initState() {
    super.initState();
    priceController.text = widget.model.vehiclePrice!;
    descriptionController.text = widget.model.vehicleDescription!;
    nameController.text = widget.model.vehicleName!;

  }

  @override
  void dispose() {
    super.dispose();
    priceController.dispose();
    descriptionController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Vehicle'),
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
          const SizedBox(
            height: 50.0
          ),
        ],
      ),
    );
  }

  _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                inputFormatters: [
                  //every name of first latter capital after space
                  RegisterController.textUpperCaseTextFormatter(),

                ],
                controller: nameController,
                decoration:  InputDecoration(
                  labelText: 'Vehicle Name',
                  hintText: 'Name: ${widget.model.vehicleName}',
                  prefixIcon: const Icon(Icons.directions_car),
                ),
                onChanged: (value) {
                  widget.model.vehicleName = value;
                },
              ),
            ),
            // description
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                inputFormatters: [
                  //every name of first latter capital after space
                  RegisterController.textUpperCaseTextFormatter(),
                ],
                controller: descriptionController,
                decoration:  InputDecoration(
                  labelText: 'Vehicle Description',
                  hintText: 'Description: ${widget.model.vehicleDescription}',
                  prefixIcon: const Icon(Icons.description),
                ),
                onChanged: (value) {
                  widget.model.vehicleDescription = value;
                },
              ),
            ),
            // price
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration:  InputDecoration(
                  labelText: 'Vehicle Price',
                  hintText: 'Vehicle Price (Rs) ${widget.model.vehiclePrice}',
                  prefixIcon: const Icon(Icons.money),
                ),

                onChanged: (value) {
                  widget.model.vehiclePrice = value;
                },
              ),
            ),
            // vehicle
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Vehicle ',
                  hintText: 'Vehicle : ${widget.model.vehicleType}',
                  prefixIcon: const Icon(Icons.directions_car),
                ),
                value: widget.model.vehicleType,
                items: controller.vehicleType
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  widget.model.vehicleType = value;
                },
              ),
            ),
            // model
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Vehicle Model',
                  hintText: 'Vehicle Model: ${widget.model.vehicleModel}',
                  prefixIcon: const Icon(Icons.directions_car),
                ),
                value: widget.model.vehicleModel,
                items: controller.vehicleModel
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  widget.model.vehicleModel = value;
                },
              ),
            ),
            // vehicleTransmission
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Vehicle Type',
                  hintText: 'Vehicle Type: ${widget.model.vehicleTransmission}',
                  prefixIcon: const Icon(Icons.directions_car),
                ),
                value: widget.model.vehicleTransmission,
                items: controller.vehicleTransmission
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                 setState(() {
                    widget.model.vehicleTransmission = value;
                 });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Vehicle Status',
                  hintText: 'Vehicle Status: ${widget.model.vehicleStatus}',
                  prefixIcon: const Icon(Icons.directions_car),
                ),
                value: widget.model.vehicleStatus,
                items: controller.vehicleStatus
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  widget.model.vehicleStatus = value;
                },
              ),
            ),
            // condition
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Vehicle Condition',
                  hintText: 'Vehicle Condition: ${widget.model.vehicleCondition}',
                  prefixIcon: const Icon(Icons.directions_car),
                ),
                value: widget.model.vehicleCondition,
                items: controller.vehicleCondition
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  widget.model.vehicleCondition = value;
                },
              ),
            ),
          // city


          //   color
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Vehicle Color',
                  hintText: 'Vehicle Color: ${widget.model.vehicleColor}',
                  prefixIcon: const Icon(Icons.directions_car),
                ),
                value: widget.model.vehicleColor,
                items: controller.vehicleColor
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  widget.model.vehicleColor = value;
                },
              ),
            ),
            // city
            Padding(padding: const EdgeInsets.all(9.0),
              child: TextFormField(
                inputFormatters: [
                  //every name of first latter capital after space
                  RegisterController.textUpperCaseTextFormatter(),
                ],
                // controller: controller1.cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  hintText: 'City: ${widget.model.city}',
                  prefixIcon: const Icon(Icons.location_city),
                ),
                onChanged: (value) {
                  widget.model.city = value;
                },
              ),
            ),
            // address
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                inputFormatters: [
                  //every name of first latter capital after space
                  RegisterController.textUpperCaseTextFormatter(),
                ],
                // controller: controller1.addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'Address: ${widget.model.address}',
                  prefixIcon: const Icon(Icons.location_on),
                ),
                onChanged: (value) {
                  widget.model.address = value;
                },
              ),
            ),
            // phone
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                // start +92 300 1234567
                inputFormatters: [
                  phoneFormatter(),
                ],
                maxLength: 13,
                keyboardType: TextInputType.phone,
                controller: controller1.phoneController,
                decoration:  InputDecoration(
                  helperText: 'Update ${widget.model.phone} Phone Number if required',
                  labelText: 'Phone',
                  hintText: 'Phone: ${widget.model.phone}',
                  prefixIcon: const Icon(Icons.phone),
                ),
                onChanged: (value) {
                  widget.model.phone = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GFButton(
        size: GFSize.LARGE,
        hoverColor: Colors.green,
        highlightElevation: 81,
        onPressed: () {

          controller.editVehicle(widget.model);
          // Get.back();
        },
        text: 'Update',
        textStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.green,
      ),
    );
  }

  phoneFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      // enter + automatically before phone number
      if (newValue.text.isEmpty) {
        return newValue.copyWith(text: '+');
      } else {
        var text = newValue.text;
        if (text.length == 1) {
          return newValue.copyWith(text: "+${newValue.text}");
        }
      }
      return newValue;
    });
  }
}

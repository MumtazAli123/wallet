import 'package:country_picker/country_picker.dart';
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

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Vehicle Type',
                  hintText: 'Vehicle Type: ${widget.model.vehicleType}',
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
  _phoneField() {
    return TextFormField(
      maxLength: 10,
      onChanged: (value) {
        setState(() {
          hintText = 'Phone';
        });
      },
      keyboardType: TextInputType.phone,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.green,
          ),
        ),
        hintText: 'Phone Number',
        hintStyle: const TextStyle(
          color: Colors.black,
        ),
        // like 300 1234567
        helperText: 'Update ${widget.model.phone} Phone Number if required',
        helperStyle: const TextStyle(
          color: Colors.black,
        ),

        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        prefixStyle: const TextStyle(
          color: Colors.black,
        ),
        prefixIcon: Container(
          padding: const EdgeInsets.all(10),
          child: TextButton(
            onPressed: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                onSelect: (Country country) {
                  setState(() {
                    controller1.selectedCountry = country;
                    controller1.countryCode = country.phoneCode;
                    controller1.flagUri = country.flagEmoji;
                  });
                },
              );
            },
            child: Text(
              '${controller1.selectedCountry.flagEmoji} +${controller1.selectedCountry.phoneCode}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        suffixIcon: controller1.phoneController.text.length > 9
            ? Container(
          margin: const EdgeInsets.only(right: 10),
          height: 20,
          width: 20,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
          child: const Icon(
            Icons.done,
            color: Colors.white,
            size: 20,
          ),
        )
            : null,
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

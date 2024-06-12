import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class WTextFieldForm extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Widget? prefixIcon;
  const WTextFieldForm(
      {super.key,
      this.labelText,
      this.controller,
      this.validator,
      this.keyboardType,
      this.prefixIcon,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        labelText: labelText,
        prefixIcon: prefixIcon,
      ),
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
    );
  }
}

class WPhoneTextFieldForm extends StatefulWidget {
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? obscureText;
  const WPhoneTextFieldForm(
      {super.key,
      this.labelText,
      this.controller,
      this.validator,
      this.keyboardType,
      this.obscureText});

  @override
  State<WPhoneTextFieldForm> createState() => _WPhoneTextFieldFormState();
}

class _WPhoneTextFieldFormState extends State<WPhoneTextFieldForm> {
  final TextEditingController phoneController = TextEditingController();
  String hintText = 'Phone';
  var countryCode = '';
  var flagUri = '';
  Country selectedCountry = Country(
    phoneCode: '92',
    countryCode: 'PK',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Pakistan',
    example: "0300 1234567",
    displayName: "Pakistan",
    displayNameNoCountryCode: "PK",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 10,
      controller: widget.controller,
      onChanged: (value) {
        setState(() {
          hintText = 'Phone';
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        labelText: widget.labelText,
        hintText: hintText,
        suffixIcon: widget.controller!.text.length > 9
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
        prefixIcon: Container(
          padding: const EdgeInsets.all(10),
          child: TextButton(
            onPressed: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                onSelect: (Country country) {
                  setState(() {
                    selectedCountry = country;
                    countryCode = country.phoneCode;
                    flagUri = country.flagEmoji;
                  });
                },
              );
            },
            child: Text(
              '${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      validator: widget.validator,
      keyboardType: TextInputType.phone,
      obscureText: widget.obscureText ?? false,
    );
  }
}

// _phoneField() {
//   return TextFormField(
//     controller: phoneController,
//     maxLength: 10,
//     onChanged: (value) {
//       setState(() {
//         hintText = 'Phone';
//       });
//     },
//     keyboardType: TextInputType.phone,
//     style: const TextStyle(
//       fontSize: 18,
//       fontWeight: FontWeight.w500,
//     ),
//     decoration: InputDecoration(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(
//           color: Colors.green,
//         ),
//       ),
//       hintText: 'Phone Number',
//       // like 300 1234567
//       helperText: 'Enter phone number like 300 1234567',
//       prefixIcon: Container(
//         padding: const EdgeInsets.all(10),
//         child: TextButton(
//           onPressed: () {
//             showCountryPicker(
//               context: context,
//               showPhoneCode: true,
//               onSelect: (Country country) {
//                 setState(() {
//                   controller.selectedCountry = country;
//                   controller.countryCode = country.phoneCode;
//                   controller.flagUri = country.flagEmoji;
//                 });
//               },
//             );
//           },
//           child: Text(
//             '${controller.selectedCountry.flagEmoji} +${controller.selectedCountry.phoneCode}',
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//           ),
//         ),
//       ),
//       suffixIcon: controller.phoneController.text.length > 9
//           ? Container(
//               margin: const EdgeInsets.only(right: 10),
//               height: 20,
//               width: 20,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.green,
//               ),
//               child: const Icon(
//                 Icons.done,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             )
//           : null,
//     ),
//   );
// }

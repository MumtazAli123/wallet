// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:email_auth/email_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/mix_widgets.dart';
import '../controllers/register_controller.dart';

class EmailRegisterView extends StatefulWidget {
  const EmailRegisterView({super.key});

  @override
  State<EmailRegisterView> createState() => _EmailRegisterViewState();
}

class _EmailRegisterViewState extends State<EmailRegisterView> {
  final controller = Get.put(RegisterController());
  bool isOtpScreen = false;

  EmailAuth emailAuth = EmailAuth(sessionName: "Sample session");

  var textFieldIcon = "email";

  void sendOTP() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: controller.emailController.text, otpLength: 5);
    if (result) {
      setState(() {
        isOtpScreen = true;
      });
    }
  }

  void verifyOTP() async {
    bool result = emailAuth.validateOtp(
        recipientMail: controller.emailController.text,
        userOtp: controller.otpController.text);
    if (result) {
      if (kDebugMode) {
        print('OTP verified');
      }
    } else {
      if (kDebugMode) {
        print('Invalid OTP');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller.onInit();
  }

  emailRegisterView() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Email'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    suffixIcon: textFieldIcon == "email"
                        ? TextButton(
                            onPressed: () {
                              controller.sendOtp(
                                  controller.emailController.text.trim());
                            },
                            child: Text('Send OTP'))
                        : Text('')),
                onTap: () {
                  setState(() {
                    textFieldIcon = "email";
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20.0),
              // inter otp field
              TextFormField(
                controller: controller.otpController,
                decoration: InputDecoration(
                    labelText: 'OTP',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: textFieldIcon == "otp"
                        ? TextButton(
                            onPressed: () {
                              controller.verifyOtp(
                                  controller.emailController.text.trim(),
                                  controller.otpController.text.trim());
                            },
                            child: Text('Verify OTP'))
                        : Text('')),
                onTap: () {
                  setState(() {
                    textFieldIcon = "otp";
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.green),
                ),
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    sendOTP();
                  }
                },
                child: wText('Verify Otp', color: Colors.white),
              ),
              SizedBox(height: 20.0),
              wText(
                "Status: ${controller.status.value}",
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isOtpScreen ? otpScreen() : emailRegisterView();
  }

  otpScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: Column(
          children: [
            TextFormField(
              controller: controller.otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter OTP';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                  verifyOTP();
                }
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

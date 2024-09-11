
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/shape/gf_badge_shape.dart';
import 'package:wallet/notification/push_notification_model.dart';

class Utils {
  static String getLanguageCode(String language) {
    switch (language) {
      case 'English':
        return 'en';
      case 'Hindi':
        return 'hi';
      case 'Spanish':
        return 'es';
      case 'French':
        return 'fr';
      case 'German':
        return 'de';
      case 'Italian':
        return 'it';
      case 'Japanese':
        return 'ja';
      case 'Korean':
        return 'ko';
      case 'Portuguese':
        return 'pt';
      case 'Russian':
        return 'ru';
      case 'Chinese':
        return 'zh';
      case 'Arabic':
        return 'ar';
      case 'Turkish':
        return 'tr';
      case 'Sindhi':
        return 'sd';
      case 'Vietnamese':
        return 'vi';
      case 'Polish':
        return 'pl';
      case 'Dutch':
        return 'nl';
      case 'Bengali':
        return 'bn';
      case 'Thai':
        return 'th';
      case 'Indonesian':
        return 'id';
      case 'Malay':
        return 'ms';
      case 'Swedish':
        return 'sv';
      case 'Greek':
        return 'el';
      case 'Norwegian':
        return 'no';
      case 'Finnish':
        return 'fi';
      case 'Danish':
        return 'da';
      case 'Persian':
        return 'fa';
      case 'Hebrew':
        return 'he';
      case 'Czech':
        return 'cs';
      case 'Croatian':
        return 'hr';
      case 'Hungarian':
        return 'hu';
      case 'Romanian':
        return 'ro';
      case 'Hmong':
        return 'hmn';
      case 'Afrikaans':
        return 'af';
      case 'Albanian':
        return 'sq';
      case 'Amharic':
        return 'am';
      case 'Armenian':
        return 'hy';
      case 'Azerbaijani':
        return 'az';
      case 'Basque':
        return 'eu';
      case 'Belarusian':
        return 'be';
      case 'Bosnian':
        return 'bs';
      case 'Bulgarian':
        return 'bg';
      case 'Catalan':
        return 'ca';

      default:
        return 'en';
    }
  }

  static String dayTime(DateTime dateTime) {
    var hour = dateTime.hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  static StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<PNotificationModel>> transformer(PNotificationModel Function(Map<String, dynamic> json) param0) {
    return StreamTransformer.fromHandlers(handleData: (QuerySnapshot<Map<String, dynamic>> data, EventSink<List<PNotificationModel>> sink) {
      final notifications = data.docs.map((doc) => param0(doc.data())).toList();
      sink.add(notifications);
    });
  }

  static buildAppBar({required String title, required IconButton leading}) {
    return AppBar(
      title: Text(title),
      leading: leading,
    );
  }

  static buildImagePicker({File? image, required void Function() onTap, required void Function() onRemove}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
        //   back ground image
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(100),
            ),
            height: 150,
            width: 150,
           child: CircleAvatar(
             backgroundImage: image != null ? FileImage(image) : null,
             child: image == null ? const Icon(Icons.person, size: 100,) : null,
           ),
          ),
        //   profile image
          Positioned(
            bottom: 10,
            right: 10,
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ),
        //   remove icon
          Positioned(
            bottom: 10,
            left: 10,
            child: InkWell(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static buildTextField({required controller, required String labelText, required String hintText, required Icon prefixIcon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          suffixIcon: IconButton(
            onPressed: () => controller.clear(),
            icon: const Icon(Icons.clear),

          ),
          prefixIcon: prefixIcon,

          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)
            ),
          ),
        ),
      ),
    );
  }

  static dropDownField({required List<String> items, required String value, required  Function? onChanged}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        value: value,
        onChanged: onChanged as void Function(String?)?,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
    );
  }

  static buildGenderButton({required String text, required bool isSelected, required Null Function() onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey,
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }


}
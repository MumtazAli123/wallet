
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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


}
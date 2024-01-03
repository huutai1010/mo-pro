import 'dart:convert';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

class CustomAssetLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    try {
      var languageCodeFileName = locale.languageCode;
      if (locale.countryCode != null) {
        languageCodeFileName += '-${locale.countryCode!.toLowerCase()}';
      }
      final url =
          'https://firebasestorage.googleapis.com/v0/b/capstoneetravel-d42ad.appspot.com/o/Language%2FFileTranslate%2F$languageCodeFileName.json?alt=media&token=8a1bb11e-7aa2-4b42-981c-0af2c465eda2';
      return http.get(Uri.parse(url)).then((value) {
        //print(value.body);
        return json.decode(utf8.decode(value.bodyBytes));
      });
    } catch (e) {
      return Future.value();
    }
  }
}

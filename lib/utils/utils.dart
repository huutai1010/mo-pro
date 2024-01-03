import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../services/local_storage_service.dart';

class Utils {
  static toasMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  static flushbarErrorMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          forwardAnimationCurve: Curves.decelerate,
          reverseAnimationCurve: Curves.easeInOut,
        ));
  }

  static Locale getLanguageCodeToLocalize(String languageCode) {
    final languageCodeSplitting = languageCode.split('-');
    if (languageCodeSplitting.length > 1) {
      return Locale(
          languageCodeSplitting[0], languageCodeSplitting[1].toUpperCase());
    }
    return Locale(languageCodeSplitting[0]);
  }

  static Future<String> translate(
      bool isTranslating, String originalContent) async {
    if (!isTranslating) {
      return originalContent;
    }
    final account = await LocalStorageService.getInstance.getAccount();
    final translatingLanguage = account!.languageCode!.split('-')[0];

    final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.7);

    final List<IdentifiedLanguage> possibleLanguages =
        await languageIdentifier.identifyPossibleLanguages(originalContent);

    await languageIdentifier.close();

    final correctLanguage = possibleLanguages[0];

    final TranslateLanguage targetLanguage =
        BCP47Code.fromRawValue(translatingLanguage)!;

    final TranslateLanguage sourceLanguage =
        BCP47Code.fromRawValue(correctLanguage.languageTag)!;

    final onDeviceTranslator = OnDeviceTranslator(
        sourceLanguage: sourceLanguage, targetLanguage: targetLanguage);

    final response = await onDeviceTranslator.translateText(originalContent);

    await onDeviceTranslator.close();

    return response;
  }
}

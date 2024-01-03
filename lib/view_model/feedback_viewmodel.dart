import 'package:etravel_mobile/repository/feedback_repo.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:etravel_mobile/view/feedback/feedback_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FeedbackViewModel with ChangeNotifier {
  final _feedbackRepo = FeedbackRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> createFeedback({
    required int journeyId,
    int? tourId,
    double? tourRate,
    String? tourContent,
    required List<FeedbackItem> feedbackItems,
    required BuildContext context,
  }) async {
    bool result = false;
    // check content is empty
    if (tourId == 0) {
      for (var item in feedbackItems) {
        if (item.content.isEmpty) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(context.tr('you_didnot_give_all_feedback')),
              content:
                  Text(context.tr('please_give_feedback_for_all_places_here')),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                )
              ],
            ),
          );
          return result;
        }
      }
    }

    loggerInfo.i('${feedbackItems.length}');

    setLoading(true);
    final places = feedbackItems
        .map((e) => {
              "placeId": e.placeId,
              "placeRate": e.rate,
              "placeContent": e.content,
            })
        .toList();
    var data = tourId != 0
        ? {
            "journeyId": journeyId,
            "tourId": tourId,
            "tourRate": tourRate,
            "tourContent": tourContent,
          }
        : {
            "journeyId": journeyId,
            "tourId": 0,
            "tourRate": 0,
            "tourContent": "",
            "places": places,
          };
    await _feedbackRepo.createFeedback(data).then((value) {
      setLoading(false);
      result = true;
    });
    return result;
  }
}

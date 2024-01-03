import 'package:easy_localization/easy_localization.dart';

import '../services/location_service.dart';
import '../services/logger_service.dart';
import '../view/onboarding/onboarding_view.dart';
import 'package:flutter/material.dart';

class LocationAccessViewModel {
  Future handleAccessLocation(BuildContext context) async {
    bool isAllowed = false;
    await LocationService.getInstance
        .grantAccessCurrentLocation()
        .then((locationPermission) {
      isAllowed = locationPermission;
      loggerInfo.i('isAllowed = $isAllowed');
      if (isAllowed) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const OnboardingView(),
          ),
        );
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(context.tr('some_thing_went_wrong')),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: Text(context.tr('try_again')),
              ),
            ],
          ),
        );
      }
    });
  }
}

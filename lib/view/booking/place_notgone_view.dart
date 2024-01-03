import 'dart:async';

import 'package:etravel_mobile/helper/convert_duration.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:etravel_mobile/services/location_service.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:etravel_mobile/view/booking/loadingwarehouse.dart';
import 'package:etravel_mobile/view/tour/tour_tracking_view.dart';
import 'package:etravel_mobile/view/widgets/custom_alert_dialog.dart';
import 'package:etravel_mobile/view_model/placebooking_viewmodel.dart';
import 'package:etravel_mobile/view_model/placenotgone_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class PlaceNotGoneView extends StatefulWidget {
  BuildContext warehouseContext;
  PlaceNotGoneView({required this.warehouseContext, super.key});

  @override
  State<PlaceNotGoneView> createState() => _PlaceNotGoneViewState();
}

class _PlaceNotGoneViewState extends State<PlaceNotGoneView> {
  final placeNotGoneViewModel = PlaceNotGoneViewModel();
  late Future<List<Place>> placeData;
  late List<Place> places;
  late List<String> routes;
  late Position myPosition;
  final placeBookingViewModel = PlaceBookingViewModel();
  late List<bool> checkBoxStates = [];
  var choosesPlaces = <Place>[];
  bool createJourneyMode = false;
  @override
  void initState() {
    placeData = placeBookingViewModel.getPlacesByStatus(false);
    placeData.then(
      (value) {
        places = value;
        // ignore: unused_local_variable
        for (var place in places) {
          checkBoxStates.add(false);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Place>>(
        future: placeData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return places.isNotEmpty
                ? _buildListPlacesNotGone(context)
                : const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Center(
                          child: Text("You don't have any place"),
                        ),
                      ],
                    ),
                  );
          }
          return const Expanded(child: LoadingWarehouse());
        });
  }

  Expanded _buildListPlacesNotGone(BuildContext context) {
    return Expanded(
      child: ChangeNotifierProvider<PlaceNotGoneViewModel>(
        create: (context) => placeNotGoneViewModel,
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          places.length,
                          (index) {
                            var current = places[index];
                            return _buildPlaceItem(
                              index,
                              current.name!,
                              current.price!,
                              current.bookingPlaceImage!,
                              current.openTime!,
                              current.closeTime!,
                              places[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  _buildCreateJourneyButton(context),
                ],
              ),
            ),
            placeNotGoneViewModel.createJourneyLoading
                ? Container(
                    color: Colors.white,
                    width: MediaQuery.of(widget.warehouseContext).size.width,
                    height: MediaQuery.of(widget.warehouseContext).size.height,
                    child: const LoadingWarehouse())
                : Container()
          ],
        ),
      ),
    );
  }

  GestureDetector _buildCreateJourneyButton(BuildContext context) {
    return GestureDetector(
      onTap: choosesPlaces.isNotEmpty
          ? () async {
              var time = 0;

              placeNotGoneViewModel.setCreateJourneyLoading(true);
              var durations =
                  choosesPlaces.map((e) => parseDuration(e.duration!)).toList();
              for (var duration in durations) {
                time += duration.inSeconds;
              }

              setState(() {});
              loggerInfo.i(
                  'createJourneyLoading = ${placeNotGoneViewModel.createJourneyLoading}');
              List<Place> markerPlaces = [];
              List<Place> timelinePlaces = [];

              await LocationService.getInstance
                  .getUserCurrentLocation()
                  .then((position) => myPosition = position!);

              await placeNotGoneViewModel
                  .createRoutes(choosesPlaces)
                  .then((value) async {
                routes = value;
              });
              await placeNotGoneViewModel
                  .managePlacesOrdinalV2(choosesPlaces)
                  .then((value) => choosesPlaces = value);
              placeNotGoneViewModel.updateTotalTime(time);
              await placeNotGoneViewModel
                  .createJourney(
                placeNotGoneViewModel.totalTime,
                placeNotGoneViewModel.totalDistance,
                choosesPlaces,
              )
                  .then((value) async {
                if (value != null) {
                  var journeyId = (value)['journeys']['id'] ?? 0;
                  await placeNotGoneViewModel.saveUserJourneyRoutes(
                      routes, journeyId);
                } else {
                  loggerInfo.i('journeyId is null');
                }
                timelinePlaces = choosesPlaces;
                choosesPlaces += [
                  Place(
                      latitude: myPosition.latitude,
                      longitude: myPosition.longitude)
                ];
                markerPlaces = choosesPlaces;
                placeNotGoneViewModel.setCreateJourneyLoading(false);
                setState(() {});
                loggerInfo.i(
                    'createJourneyLoading = ${placeNotGoneViewModel.createJourneyLoading}');
                // ignore: use_build_context_synchronously
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TourTrackingView(
                      journeyId: value?['journeys']['id'],
                      totalTime: placeNotGoneViewModel.totalTime / 3600,
                      totalDistance: placeNotGoneViewModel.totalDistance / 1000,
                      isJourneyNotGone: true,
                    ),
                  ),
                ).then((value) {
                  choosesPlaces = [];
                  // ignore: unused_local_variable
                  for (var check in checkBoxStates) {
                    check = false;
                  }

                  createJourneyMode = false;
                  setState(() {});
                });
              });
            }
          : null,
      child: createJourneyMode
          ? Center(
              child: Container(
                margin: const EdgeInsets.only(top: 15, right: 40, bottom: 15),
                decoration: BoxDecoration(
                    color: choosesPlaces.isNotEmpty
                        ? AppColors.primaryColor
                        : Colors.grey.withOpacity(.6),
                    borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                width: 150,
                height: 50,
                child: Text(
                  context.tr('create_journey'),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            )
          : Container(),
    );
  }

  Widget _buildPlaceItem(
    int index,
    String name,
    double price,
    String placeImage,
    String openTime,
    String closeTime,
    Place currentPlace,
  ) {
    Timer? dialogTimer;
    return GestureDetector(
      onLongPress: () {
        HapticFeedback.vibrate();
        createJourneyMode = !createJourneyMode;
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(
          top: index == 0 ? 10 : 0,
          bottom: 10,
          right: 10,
        ),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(placeImage),
                    fit: BoxFit.cover,
                  ),
                ),
                margin: const EdgeInsets.all(5),
                width: 90,
                height: 90,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 3),
                        createJourneyMode
                            ? GestureDetector(
                                onTap: () {
                                  var isNotDuplicate = true;
                                  HapticFeedback.vibrate();
                                  for (var place in choosesPlaces) {
                                    if (currentPlace.placeId == place.placeId &&
                                        currentPlace.bookingPlaceId !=
                                            place.bookingPlaceId) {
                                      isNotDuplicate = false;
                                      break;
                                    }
                                  }
                                  if (!isNotDuplicate) {
                                    dialogTimer = Timer(
                                        const Duration(milliseconds: 2500), () {
                                      Navigator.of(context).pop();
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return CustomAlertDialog(
                                            content:
                                                '${context.tr('please_choose_another_place_that_not_exist')}!',
                                            assetImagePath:
                                                'assets/images/auth/warning.png',
                                          );
                                        }).then((value) {
                                      dialogTimer?.cancel();
                                      dialogTimer = null;
                                    });
                                    return;
                                  }
                                  checkBoxStates[index] =
                                      !checkBoxStates[index];
                                  if (checkBoxStates[index]) {
                                    if (isNotDuplicate) {
                                      choosesPlaces.add(currentPlace);
                                    }
                                  } else {
                                    choosesPlaces.remove(currentPlace);
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: checkBoxStates[index]
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                    border: Border.all(
                                      width: 1,
                                      color: checkBoxStates[index]
                                          ? AppColors.primaryColor
                                          : Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  width: 25,
                                  height: 25,
                                  child: checkBoxStates[index]
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 15,
                                        )
                                      : Container(),
                                ),
                              )
                            : Container()
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_filled_sharp,
                          size: 18,
                          color: Color(0xFFFC820A),
                        ),
                        const SizedBox(width: 5),
                        Text(
                            DateFormat.jm()
                                .format(DateFormat("hh:mm:ss").parse(openTime)),
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_off_sharp,
                          size: 18,
                          color: Color(0xFF1A94FF),
                        ),
                        const SizedBox(width: 5),
                        Text(
                            DateFormat.jm().format(
                                DateFormat("hh:mm:ss").parse(closeTime)),
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 7),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

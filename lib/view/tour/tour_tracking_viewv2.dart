import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/helper/convert_duration.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/models/tour.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:etravel_mobile/services/local_storage_service.dart';
import 'package:etravel_mobile/services/location_service.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:etravel_mobile/view/booking/loadingwarehouse.dart';
import 'package:etravel_mobile/view/feedback/feedback_view.dart';
import 'package:etravel_mobile/view/loading/loading_view.dart';
import 'package:etravel_mobile/view/tour/celebratedimage_view.dart';
import 'package:etravel_mobile/view/tour/checkbox_custom.dart';
import 'package:etravel_mobile/view/voice/place_visit_view.dart';
import 'package:etravel_mobile/view/widgets/custom_confirm_dialog.dart';
import 'package:etravel_mobile/view_model/journey_viewmodel.dart';
import 'package:etravel_mobile/view_model/placenotgone_viewmodel.dart';
import 'package:etravel_mobile/view_model/tourtracking_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../const/const.dart';

class TourTrackingViewV2 extends StatefulWidget {
  var isFeedback;
  var isJourneyNotGone;
  var isJourneyCompleted;
  int? statusForFeedback;
  int? journeyId;
  int? tourId;
  double totalTime;
  double totalDistance;
  List<Place> placesForMarker = [];
  List<Place> placesForTimeLine = [];
  List<String> routes = [];
  bool canDisplayVoice;
  bool? showCelebrated = false;
  TourTrackingViewV2({
    this.canDisplayVoice = false,
    this.journeyId,
    this.tourId,
    required this.totalTime,
    required this.totalDistance,
    this.isFeedback = false,
    this.isJourneyNotGone = false,
    this.isJourneyCompleted = false,
    this.showCelebrated = false,
    super.key,
  });

  @override
  State<TourTrackingViewV2> createState() => _TourTrackingViewV2State();
}

class _TourTrackingViewV2State extends State<TourTrackingViewV2> {
  final _tourTrackingViewModel = TourTrackingViewModel();
  final journeyViewModel = JourneyViewModel();
  bool isLoading = false;
  bool _isMapInit = false;
  var polylines = <List<PointLatLng>>[];
  late List<bool> checkBoxStates = [];
  late List<Place> feedbackPlaces = [];

  Future loadData() async {
    if (_isMapInit) {
      return;
    }
    List<Place> markerPlaces = [];
    var places = <Place>[];
    var routes = <String>[];

    await journeyViewModel
        .getUserJourneyRoutes(widget.journeyId!)
        .then((value) {
      widget.routes = value;
      routes = widget.routes;
    });
    polylines =
        widget.routes.map((e) => PolylinePoints().decodePolyline(e)).toList();
    final myLocation =
        await LocationService.getInstance.getUserCurrentLocation();
    await journeyViewModel.getJourneyDetails(widget.journeyId!).then(
      (journey) async {
        widget.statusForFeedback = journey.status;
        widget.tourId = journey.tourId;
        if (journey.bookingPlaces.isNotEmpty) {
          places = journey.bookingPlaces;
          widget.placesForTimeLine = places;
          markerPlaces = journey.bookingPlaces +
              [
                Place(
                  latitude: myLocation!.latitude,
                  longitude: myLocation.longitude,
                )
              ];
          widget.placesForMarker = markerPlaces;
          if (routes.isEmpty) {
            await PlaceNotGoneViewModel()
                .createRoutes(places, isCheckedOrdinal: true)
                .then(
              (routes) async {
                widget.routes = routes;

                polylines = widget.routes
                    .map((e) => PolylinePoints().decodePolyline(e))
                    .toList();
                await LocalStorageService.getInstance
                    .saveUserJourneyRoutes(routes, widget.journeyId!);
              },
            );
          }
        }
      },
    );
    setState(() {
      _isMapInit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _tourTrackingViewModel.notFeedback =
        widget.statusForFeedback != 3 ? true : false;
    return ChangeNotifierProvider(
      create: (context) => _tourTrackingViewModel,
      child: FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && _isMapInit) {
            CameraPosition kGooglePlex = CameraPosition(
              target: LatLng(widget.placesForMarker[0].latitude!,
                  widget.placesForMarker[0].longitude!),
              zoom: 14.4746,
            );
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                title: Text(
                  context.tr('journey_detail'),
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
                leading: const BackButton(),
                actions: [
                  widget.statusForFeedback == 2
                      ? Consumer<TourTrackingViewModel>(
                          builder: (context, vm, _) {
                          return vm.notFeedback
                              ? TextButton(
                                  onPressed: () async {
                                    loggerInfo.i('tourid = ${widget.tourId}');
                                    Tour? tour;
                                    if (widget.tourId != null &&
                                        widget.tourId! > 0) {
                                      await _tourTrackingViewModel
                                          .getTourdetailsToFeedback(
                                              widget.tourId!)
                                          .then((value) => tour = value);
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FeedbackView(
                                            tourTrackingViewModel:
                                                _tourTrackingViewModel,
                                            journeyId: widget.journeyId!,
                                            tourId: widget.tourId,
                                            tourFeedbackName: tour?.name ?? '',
                                            tourFeedbackImage:
                                                tour?.image ?? '',
                                            places: widget.placesForTimeLine,
                                          ),
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          for (var _
                                              in widget.placesForTimeLine) {
                                            checkBoxStates.add(false);
                                          }
                                          return _buildFeedbackOptionDialog(
                                              context);
                                        },
                                      );
                                    }
                                  },
                                  child: Text(
                                    context.tr('feedback'),
                                  ),
                                )
                              : Container();
                        })
                      : Container(),
                ],
              ),
              backgroundColor: Colors.grey,
              body: Stack(
                children: [
                  _buildTrackingTour(kGooglePlex, polylines),
                  isLoading
                      ? Container(
                          color: Colors.white,
                          child: const Center(
                            child: LoadingWarehouse(),
                          ),
                        )
                      : Container()
                ],
              ),
            );
          } else {
            return const LoadingView();
          }
        },
      ),
    );
  }

  AlertDialog _buildFeedbackOptionDialog(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr('choose_places_for_feedback')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.placesForTimeLine.length,
          (index) => Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(widget
                              .placesForTimeLine[index].bookingPlaceImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: 60,
                      height: 60,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        widget.placesForTimeLine[index].name ?? 'No name',
                        style: const TextStyle(
                          color: Color(0xFF808080),
                        ),
                      ),
                    ),
                    CheckboxCustom(
                      //state: checkBoxStates[index],
                      onTapCheckbox: () {
                        checkBoxStates[index] = !checkBoxStates[index];
                        print(checkBoxStates[index]);
                        for (int i = 0; i < checkBoxStates.length; i++) {
                          print(checkBoxStates[index]);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 15),
          child: TextButton(
            onPressed: () {
              feedbackPlaces = [];
              for (int i = 0; i < checkBoxStates.length; i++) {
                if (checkBoxStates[i]) {
                  feedbackPlaces.add(widget.placesForTimeLine[i]);
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FeedbackView(
                    tourTrackingViewModel: _tourTrackingViewModel,
                    journeyId: widget.journeyId!,
                    tourId: 0,
                    tourFeedbackName: '',
                    tourFeedbackImage: '',
                    places: feedbackPlaces,
                  ),
                ),
              );
            },
            child: Text(
              context.tr('continue'),
            ),
          ),
        )
      ],
    );
  }

  Stack _buildTrackingTour(
      CameraPosition kGooglePlex, List<List<PointLatLng>> polylines) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        //_buildMap(kGooglePlex, polylines),
        _buildTimeline(),
      ],
    );
  }

  Widget _buildTimeline() {
    void onListeningVoice(int index) async {
      if (!(widget.placesForTimeLine[index].isSupport ?? false)) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomConfirmDialog(
              yesContent: 'OK',
              title: context.tr('voice_file_error'),
              content:
                  '${context.tr('description_with_language_not_support')}.',
              icon: const Icon(
                Icons.warning,
                color: AppColors.primaryColor,
                size: 70,
              ),
              onYes: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
        return;
      }
      if (!widget.canDisplayVoice) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 500),
            content:
                Text(context.tr('please_start_your_journey_to_display_voice')),
          ),
        );
        return;
      }

      final now = DateTime.now().toLocal();
      final expiredPlaceVoiceTime = widget.placesForTimeLine[index].expiredTime;
      if (expiredPlaceVoiceTime != null) {
        final after = now.isAfter(expiredPlaceVoiceTime);
        if (after) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(milliseconds: 500),
              content: Text(
                '${context.tr('your_voice_is_expired_at')}${DateFormat(kDateTimeFormat).format(expiredPlaceVoiceTime)}',
              ),
            ),
          );
          return;
        }
      }

      Place? place;
      final placeId = widget.placesForTimeLine[index].placeId;
      await _tourTrackingViewModel
          .getDataPlaceVoiceScreen(placeId!)
          .then((value) async {
        print(value);
        place = value;
        if (place != null) {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return PlaceVisitView(
                indexPlace: index,
                tourTrackingViewModel: _tourTrackingViewModel,
                bookingPlaceId: widget.placesForTimeLine[index].bookingPlaceId!,
                checkInNeeded: expiredPlaceVoiceTime == null,
                place: place!,
              );
            }),
          ).then((checkInTime) {
            if ((checkInTime as DateTime?) != null) {
              setState(() {
                widget.placesForTimeLine[index].startTime =
                    checkInTime!.toLocal().toString();
                widget.placesForTimeLine[index].expiredTime =
                    checkInTime.add(const Duration(days: 7));
              });
            }
          });
        }
      });
    }

    _tourTrackingViewModel.initTimes(widget.placesForTimeLine);
    loggerInfo.i('times size = ${_tourTrackingViewModel.times.length}');

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.tr('information'),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              const Spacer(),
              widget.showCelebrated != null && widget.showCelebrated == true
                  ? TextButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CelebratedImageView(
                                journeyId: widget.journeyId!),
                          ),
                        );
                      },
                      child: Text(context.tr('celebrated_images')),
                    )
                  : Container(),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.15),
              borderRadius: BorderRadius.circular(10),
            ),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      context.tr('places'),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Color.fromARGB(255, 8, 107, 46),
                        ),
                        Text(
                          '${widget.placesForTimeLine.length} ${context.tr('places')}',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 8, 107, 46)),
                        )
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      context.tr('hours'),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.timeline_outlined),
                        Text(
                            '${widget.totalTime.toStringAsFixed(1)} ${context.tr('hour')}')
                      ],
                    )
                  ],
                ),
                const Divider(),
                Column(
                  children: [
                    Text(
                      context.tr('distance'),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.social_distance_rounded,
                          color: Color.fromARGB(255, 165, 162, 9),
                        ),
                        Text(
                          '${widget.totalDistance.toStringAsFixed(1)}km',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 165, 162, 9)),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children:
                    List.generate(widget.placesForTimeLine.length, (index) {
                  return Consumer<TourTrackingViewModel>(
                    builder: (ctx, vm, _) {
                      return TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.05,
                        isFirst: (index == 0) ? true : false,
                        endChild: GestureDetector(
                          onTap: () => onListeningVoice(index),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.withOpacity(.2),
                            ),
                            margin: const EdgeInsets.only(left: 15, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8)),
                                    image: DecorationImage(
                                      image: NetworkImage(widget
                                              .placesForTimeLine[index]
                                              .bookingPlaceImage ??
                                          'https://a.cdn-hotels.com/gdcs/production88/d1144/1165791f-ac3a-4956-88c2-3877e2aa0154.jpg?impolicy=fcrop&w=800&h=533&q=medium'),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade500,
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        offset: const Offset(4, 2),
                                      ),
                                      const BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-2, -2),
                                          blurRadius: 15,
                                          spreadRadius: 1)
                                    ],
                                  ),
                                  height: 100,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                        widget.placesForTimeLine[index].name ??
                                            'Current location',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '(${(parseDuration(widget.placesForTimeLine[index].duration!).inSeconds / 3600).toStringAsFixed(2)} ${context.tr('hours_visiting')})',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(height: 10),
                                      vm.times[index] != ''
                                          ? Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: AppColors
                                                        .primaryColor
                                                        .withOpacity(.8),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    vm.times[index],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Container(),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        indicatorStyle: IndicatorStyle(
                          width: 30,
                          height: 30,
                          color: (_tourTrackingViewModel.times[index] != '')
                              ? AppColors.primaryColor.withOpacity(.8)
                              : Colors.grey,
                          iconStyle: IconStyle(
                            iconData: Icons.location_city,
                            color: Colors.white,
                          ),
                        ),
                        afterLineStyle:
                            index == widget.placesForTimeLine.length - 1
                                ? const LineStyle(color: Colors.white)
                                : null,
                        beforeLineStyle: LineStyle(
                          color: (_tourTrackingViewModel.times[index] != '')
                              ? AppColors.primaryColor.withOpacity(.8)
                              : Colors.grey,
                          thickness: 6,
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ),
          widget.isJourneyNotGone
              ? GestureDetector(
                  onTap: () async {
                    isLoading = true;
                    setState(() {});
                    await journeyViewModel
                        .updateJourneyStatus(widget.journeyId!, 1)
                        .then(
                      (value) {
                        widget.isJourneyNotGone = false;
                        widget.canDisplayVoice = true;
                        isLoading = false;
                        setState(() {});
                      },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Text(
                      context.tr('start_journey'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  GoogleMap _buildMap(
      CameraPosition kGooglePlex, List<List<PointLatLng>> polylines) {
    return GoogleMap(
      initialCameraPosition: kGooglePlex,
      polylines: polylines
          .map(
            (polyline) => Polyline(
              width: 10,
              color: Colors.orange,
              polylineId: const PolylineId('overview_polyline'),
              points: polyline
                  .map((polypoint) =>
                      LatLng(polypoint.latitude, polypoint.longitude))
                  .toList(),
            ),
          )
          .toSet(),
      markers: widget.placesForMarker
          .map(
            (e) => Marker(
              icon: widget.placesForMarker.indexOf(e) ==
                      widget.placesForMarker.length - 1
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRose)
                  : BitmapDescriptor.defaultMarker,
              markerId: const MarkerId(''),
              position: LatLng(e.latitude!, e.longitude!),
            ),
          )
          .toSet(),
    );
  }
}

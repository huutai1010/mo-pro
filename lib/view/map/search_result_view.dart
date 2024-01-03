import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../models/place.dart';
import '../../res/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/logger_service.dart';
import '../../view_model/searchresult_viewmodel.dart';

class SearchResultView extends StatefulWidget {
  late List<Place> listSearchPlaces;
  SearchResultView({required this.listSearchPlaces, super.key});

  @override
  State<SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView> {
  final Completer<GoogleMapController> _controller = Completer();
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  final searchResultViewModel = SearchResultViewModel();
  late Set<Marker> setMarkers;

  late CameraPosition _firstPlace;

  @override
  void initState() {
    super.initState();

    _firstPlace = CameraPosition(
      target: LatLng(widget.listSearchPlaces[0].latitude!,
          widget.listSearchPlaces[0].longitude!),
      zoom: 14.4746,
    );

    setMarkers = widget.listSearchPlaces
        .map(
          (e) => Marker(
            markerId: MarkerId('${e.id}'),
            position: LatLng(e.latitude!, e.longitude!),
          ),
        )
        .toSet();

    loadData();
  }

  loadData() async {
    await searchResultViewModel.loadMarkerData(
        widget.listSearchPlaces, _customInfoWindowController, context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    loggerInfo.i('Google map places = ${widget.listSearchPlaces.length}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(context.tr('results')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: _firstPlace,
          markers: Set.of(searchResultViewModel.markers),
          zoomControlsEnabled: false,
          mapType: MapType.terrain,
          onTap: (position) => _customInfoWindowController.hideInfoWindow!(),
          onCameraMove: (position) =>
              _customInfoWindowController.onCameraMove!(),
          onMapCreated: (controller) {
            _customInfoWindowController.googleMapController = controller;
            _controller.complete(controller);
          },
        ),
        CustomInfoWindow(
          controller: _customInfoWindowController,
          height: 200,
          width: 250,
          offset: 50,
        ),
        SafeArea(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Spacer(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  widget.listSearchPlaces.length,
                  (index) {
                    var place = widget.listSearchPlaces[index];
                    return GestureDetector(
                      onTap: () async {
                        loggerInfo.i('on tap');
                        CameraPosition cameraPosition = CameraPosition(
                            zoom: 17,
                            target: LatLng(place.latitude!, place.longitude!));
                        final GoogleMapController controller =
                            await _controller.future;
                        controller.animateCamera(
                            CameraUpdate.newCameraPosition((cameraPosition)));

                        setState(() {});
                      },
                      child: PlaceResult(place.name!, place.image!,
                          place.daysOfWeek!, place.openTime!, place.endTime!,
                          placeId: place.id!, rate: place.rate!),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 15)
          ],
        ))
      ]),
    );
  }
}

class PlaceResult extends StatelessWidget {
  String name;
  String image;
  String daysOfWeek;
  String openTime;
  String endTime;
  int placeId;
  double rate;

  PlaceResult(
    this.name,
    this.image,
    this.daysOfWeek,
    this.openTime,
    this.endTime, {
    super.key,
    required this.placeId,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 30,
        ),
        decoration: BoxDecoration(
          border: Border.all(width: .1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        width: 320,
        height: 165,
        alignment: Alignment.center,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(image),
                ),
              ),
              width: 93,
              height: 140,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${context.tr('DayOfWeek')}: ${context.tr(daysOfWeek)}',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.primaryColor),
                    ),
                    Text('${context.tr('open')}: ${openTime.substring(0, 5)}'),
                    Text('${context.tr('close')}: ${endTime.substring(0, 5)}'),
                    rate == 0
                        ? Text(context.tr('no_reviews'))
                        : Row(
                            children: [
                              Text('$rate'),
                              RatingBar.builder(
                                itemSize: 16,
                                initialRating: rate,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Color(0xFFFFB23F),
                                ),
                                tapOnlyMode: true,
                                onRatingUpdate: (rating) {},
                              ),
                            ],
                          ),
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

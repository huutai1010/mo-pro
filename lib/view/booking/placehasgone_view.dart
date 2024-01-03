import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/view/booking/loadingwarehouse.dart';
import 'package:etravel_mobile/view_model/placebooking_viewmodel.dart';
import 'package:flutter/material.dart';

class PlaceHasGoneView extends StatefulWidget {
  const PlaceHasGoneView({super.key});

  @override
  State<PlaceHasGoneView> createState() => _PlaceHasGoneViewState();
}

class _PlaceHasGoneViewState extends State<PlaceHasGoneView> {
  late Future<List<Place>> placeData;
  late List<Place> places;
  final placeBookingViewModel = PlaceBookingViewModel();
  @override
  void initState() {
    placeData = placeBookingViewModel.getPlacesByStatus(true);
    placeData.then((value) => places = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Place>>(
      future: placeData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return places.isNotEmpty
              ? Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          places.length,
                          (index) {
                            var current = places[index];
                            return _buildPlaceItem(
                              index,
                              current.name!,
                              current.bookingPlaceImage!,
                              current.price!,
                              current.openTime!,
                              current.closeTime!,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                )
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
        return const Expanded(
          child: LoadingWarehouse(),
        );
      },
    );
  }

  Container _buildPlaceItem(
    int index,
    String name,
    String placeImage,
    double price,
    String openTime,
    String closeTime,
  ) {
    return Container(
      margin: EdgeInsets.only(
        top: index == 0 ? 10 : 0,
        bottom: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
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
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
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
                          DateFormat.jm()
                              .format(DateFormat("hh:mm:ss").parse(closeTime)),
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 7),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

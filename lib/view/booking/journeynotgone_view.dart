import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/journey.dart';
import 'package:etravel_mobile/view/booking/loadingwarehouse.dart';
import 'package:etravel_mobile/view/tour/tour_tracking_view.dart';
import 'package:etravel_mobile/view_model/journey_viewmodel.dart';
import 'package:flutter/material.dart';

class JourneyNotGoneView extends StatefulWidget {
  const JourneyNotGoneView({super.key});

  @override
  State<JourneyNotGoneView> createState() => _JourneyNotGoneViewState();
}

class _JourneyNotGoneViewState extends State<JourneyNotGoneView> {
  late Future<List<Journey>> journeysData;
  late List<Journey> journeys;
  final journeyViewModel = JourneyViewModel();
  bool isLoading = false;
  @override
  void initState() {
    journeysData = journeyViewModel.getJourneyByStatus(0);
    journeysData.then((value) => journeys = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Expanded(child: LoadingWarehouse())
        : FutureBuilder<List<Journey>>(
            future: journeysData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return journeys.isNotEmpty
                    ? Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                journeys.length,
                                (index) {
                                  var current = journeys[index];
                                  return _buildJourneyItemV2(
                                    index,
                                    current.id!,
                                    current.totalDistance!,
                                    current.totalTime!,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Center(
                              child: Text(
                                  context.tr('you_donot_have_journey_yet')),
                            ),
                          ],
                        ),
                      );
                ;
              }
              return const Expanded(
                child: LoadingWarehouse(),
              );
            },
          );
  }

  Widget _buildJourneyItemV2(
    int index,
    int journeyId,
    double totalDistance,
    double totalTime,
  ) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TourTrackingView(
              isJourneyNotGone: true,
              journeyId: journeyId,
              totalTime: totalTime,
              totalDistance: totalDistance,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20, left: 5, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade500,
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(4, 2)),
            const BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 15,
                spreadRadius: 1)
          ],
        ),
        width: MediaQuery.of(context).size.width,
        height: 240,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn.tcdulichtphcm.vn/upload/4-2022/images/2022-11-30/1669808251-khinh-khi-cau-1-9480.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              height: 120,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${journeys[index].firstPlaceName} - ${journeys[index].lastPlaceName}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF1A94FF),
                      ),
                      const SizedBox(width: 5),
                      Text(
                          '${totalDistance.toStringAsFixed(1)} km (${context.tr('total_distance')})',
                          style: const TextStyle(color: Color(0xFF808080)))
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_filled_outlined,
                        color: Color(0xFFFC820A),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                            '${totalTime.toStringAsFixed(1)} ${context.tr('hour')} (${context.tr('visit')} + ${context.tr('transport_time')})',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFF808080))),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

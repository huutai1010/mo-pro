import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

import '../models/place_item.dart';
import 'widgets/place_item_row.dart';

class PlaceItemView extends StatefulWidget {
  final PlaceItem? nowPlayingPlaceItem;
  final int placeId;
  final List<PlaceItem> placeItems;
  final Function(PlaceItem) onItemSelected;
  const PlaceItemView({
    super.key,
    required this.placeId,
    required this.placeItems,
    required this.onItemSelected,
    required this.nowPlayingPlaceItem,
  });

  @override
  State<PlaceItemView> createState() => _PlaceItemViewState();
}

class _PlaceItemViewState extends State<PlaceItemView>
    with WidgetsBindingObserver {
  List<PlaceItem> _placeItemsNearby = [];
  final regions = <Region>[];
  StreamSubscription<RangingResult>? _streamRanging;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _streamRanging?.pause();
    }
    if (state == AppLifecycleState.resumed) {
      _streamRanging?.resume();
    }
    super.didChangeAppLifecycleState(state);
  }

  void _onRanging(RangingResult result) {
    final beacons = result.beacons;
    List<PlaceItem> placesToShow = widget.placeItems;

    if (beacons.isNotEmpty) {
      for (var item in placesToShow) {
        final beaconFound = beacons
            .where((element) => element.proximityUUID == item.beaconId)
            .firstOrNull;
        if (beaconFound == null) {
          item.distance = null;
        } else {
          double distance = _calculateDistance(
              beaconFound.rssi.toDouble(), beaconFound.txPower!.toDouble());
          item.distance = distance;
        }
      }
      placesToShow.sort((a, b) {
        int result;
        if (a.distance == null) {
          result = 1;
        } else if (b.distance == null) {
          result = -1;
        } else {
          // Ascending Order
          result = a.distance!.compareTo(b.distance!);
        }
        return result;
      });
    }

    setState(() {
      _placeItemsNearby = widget.placeItems;
    });
  }

  double _calculateDistance(double rssi, double txPower) {
    // https://stackoverflow.com/a/20434019
    // http://www.davidgyoungtech.com/2020/05/15/how-far-can-you-go
    if (rssi == 0) {
      return -1.0;
    }
    double ratio = rssi * 1.0 / txPower;
    if (ratio < 1.0) {
      return pow(ratio, 10).toDouble();
    }
    double accuracy = (0.89976) * pow(ratio, 7.7095) + 0.111;
    return accuracy;
  }

  @override
  void initState() {
    _placeItemsNearby = widget.placeItems;
    flutterBeacon.initializeAndCheckScanning.then((beaconGranted) {
      if (beaconGranted) {
        flutterBeacon.setScanPeriod(5000).then((_) {
          if (beaconGranted && regions.isEmpty) {
            regions.add(Region(identifier: widget.placeId.toString()));
            _streamRanging = flutterBeacon.ranging(regions).listen(_onRanging);
          }
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _streamRanging?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingPlaceItem = widget.nowPlayingPlaceItem;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (nowPlayingPlaceItem != null) ...[
            Text(
              context.tr('now_playing'),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            PlaceItemRow(
              image: const AssetImage('assets/images/place/soundwave.gif'),
              placeItem: nowPlayingPlaceItem,
              distance: null,
              isDescription: true,
              onTap: () {
                // Intentionally do nothing
              },
            ),
          ],
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_placeItemsNearby.isNotEmpty) ...[
                Text(
                  context.tr('next_from_this_place'),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: _placeItemsNearby.length,
                    itemBuilder: (ctx, i) {
                      return PlaceItemRow(
                        image: NetworkImage(_placeItemsNearby[i].url),
                        placeItem: _placeItemsNearby[i],
                        distance: _placeItemsNearby[i].distance,
                        onTap: () =>
                            widget.onItemSelected(_placeItemsNearby[i]),
                      );
                    },
                  ),
                ),
              ] else
                Container(),
            ],
          )),
        ],
      ),
    );
  }
}

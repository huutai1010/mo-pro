import 'package:custom_info_window/custom_info_window.dart';
import 'package:etravel_mobile/view/place/placedetail_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import '../models/place.dart';
import '../repository/place_repository.dart';

class SearchResultViewModel with ChangeNotifier {
  final _placeRepo = PlaceRepository();
  var markers = <Marker>[];

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Set<Polyline> getSamplePolylines() {
    return _placeRepo.getPolylinesFromSearchPlacesResult();
  }

  Set<Marker> getSampleMarkers() {
    return _placeRepo.getSampleMarkers();
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  loadMarkerData(
      List<Place> listSearchPlaces,
      CustomInfoWindowController customInfoWindowController,
      BuildContext context) async {
    final Uint8List markerIcon =
        await getBytesFromAssets('assets/images/map/pin-place.png', 150);
    for (int i = 0; i < listSearchPlaces.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(
              listSearchPlaces[i].latitude!, listSearchPlaces[i].longitude!),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          onTap: () {
            customInfoWindowController.addInfoWindow!(
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaceDetailsView(
                                placeId: listSearchPlaces[i].id!),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(listSearchPlaces[i].image!),
                              fit: BoxFit.fitWidth,
                              filterQuality: FilterQuality.high,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          width: 250,
                          height: 150,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          listSearchPlaces[i].name!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                LatLng(
                  listSearchPlaces[i].latitude!,
                  listSearchPlaces[i].longitude!,
                ));
          },
        ),
      );
    }
  }
}

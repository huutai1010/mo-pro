import 'dart:async';
import 'package:etravel_mobile/services/local_storage_service.dart';
import 'package:etravel_mobile/view_model/tourtracking_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/view_model/voice_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../repository/place_item_repository.dart';
import '../../models/place_item.dart';
import '../../res/colors/app_color.dart';
import '../../view_model/auth_viewmodel.dart';
import '../place_item_view.dart';
import '../widgets/custom_audio_player.dart';
import '../../view_model/audio_viewmodel.dart';
import '../../models/place.dart';
import '../people/nearby_people_view.dart';
import '../widgets/place_visit_image.dart';

class PlaceVisitView extends StatefulWidget {
  final int indexPlace;
  final TourTrackingViewModel tourTrackingViewModel;
  final int bookingPlaceId;
  final Place place;
  final bool checkInNeeded;
  const PlaceVisitView({
    required this.indexPlace,
    required this.tourTrackingViewModel,
    required this.bookingPlaceId,
    required this.checkInNeeded,
    super.key,
    required this.place,
  });

  @override
  State<PlaceVisitView> createState() => _PlaceVisitViewState();
}

class _PlaceVisitViewState extends State<PlaceVisitView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  final voiceViewModel = VoiceViewModel();
  bool isLoading = false;
  DateTime? _checkInTime;
  bool _checkInNeeded = true;

  // Place Items loader
  late Future<List<PlaceItem>> _placeItemsFuture;
  List<PlaceItem> _placeItems = [];
  bool _isInit = true;
  late AudioViewModel _audioVm;
  PlaceItem? nowPlayingPlaceItem;

  Future<void> _onClickItem(BuildContext ctx, PlaceItem placeItem) async {
    final placeDetails =
        await PlaceItemRepository().getPlaceItemDetails(placeItem.id);
    final startTime = placeItem.startTimeInMs;

    await _audioVm.seek(startTime.toDouble());
    setState(() {
      nowPlayingPlaceItem = placeDetails;
    });
  }

  @override
  void initState() {
    _checkInNeeded = widget.checkInNeeded;
    _tabController = TabController(length: 2, vsync: this);
    _placeItemsFuture = PlaceItemRepository().getPlaceItems(widget.place.id!);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _audioVm = Provider.of<AudioViewModel>(context, listen: false);
      _audioVm.loadAudioPlayer(widget.place.voiceFile!);
      _placeItemsFuture.then((value) {
        setState(() {
          _placeItems = value;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioVm.close();
    super.dispose();
  }

  Future getImage(ImageSource source, int bookingPlaceId) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      Navigator.pop(context);
      if (image == null) return;
      isLoading = true;
      setState(() {});
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('imageFiles', image.path);
      await voiceViewModel
          .postCelebratedImage(bookingPlaceId, multipartFile)
          .then((value) {
        isLoading = false;
        setState(() {});
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            // <-- SEE HERE
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          context: context,
          builder: (_) {
            return SizedBox(
              height: MediaQuery.of(context).size.width * .5,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 15),
                    const Icon(
                      Icons.photo_camera_outlined,
                      color: AppColors.primaryColor,
                      size: 25,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Update image successfully!',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 25),
                      child: Text(
                        context.tr('celebrate_image_success'),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF808080),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primaryColor,
                      ),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 8,
                      height: 50,
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            );
          },
        );
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  _onFindNearby() async {
    var account = await LocalStorageService.getInstance.getAccount();
    if (context.mounted) {
      final authVm = Provider.of<AuthViewModel>(context, listen: false);
      authVm.submitToSocket('check-in', account!);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const NearbyPeopleView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioVm = Provider.of<AudioViewModel>(context);
    return isLoading
        ? const Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          )
        : WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop(_checkInTime);
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.place.name!),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                leading: const BackButton(),
                bottom: TabBar(
                  labelColor: Colors.black,
                  labelPadding: const EdgeInsets.all(10.0),
                  indicatorColor: AppColors.primaryColor,
                  tabs: [
                    Text(context.tr('overview')),
                    Text(context.tr('items')),
                  ],
                  controller: _tabController,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return Wrap(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await getImage(ImageSource.camera,
                                      widget.bookingPlaceId);
                                },
                                child: const ListTile(
                                  leading: Icon(Icons.camera),
                                  title: Text('Camera'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await getImage(ImageSource.gallery,
                                      widget.bookingPlaceId);
                                },
                                child: const ListTile(
                                  leading: Icon(Icons.photo_album),
                                  title: Text('Gallery'),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.photo_camera_back_outlined,
                    ),
                  ),
                  IconButton(
                    onPressed: _onFindNearby,
                    icon: const Icon(
                      Icons.share_outlined,
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        PlaceVisitImage(
                          address: widget.place.address ?? 'No address',
                          images: widget.place.placeImages!,
                        ),
                        PlaceItemView(
                          nowPlayingPlaceItem: nowPlayingPlaceItem,
                          placeId: widget.place.id!,
                          placeItems: _placeItems,
                          onItemSelected: (placeItem) =>
                              _onClickItem(context, placeItem),
                        ),
                      ],
                    ),
                  ),
                  CustomAudioPlayer(
                      indexPlace: widget.indexPlace,
                      tourTrackingViewModel: widget.tourTrackingViewModel,
                      audioVm: audioVm,
                      bookingPlaceId: widget.bookingPlaceId,
                      checkInNeeded: _checkInNeeded,
                      onCheckRefresh: (checkInTime) {
                        setState(() {
                          _checkInTime = checkInTime;
                          _checkInNeeded = false;
                        });
                      })
                ],
              ),
            ),
          );
  }
}

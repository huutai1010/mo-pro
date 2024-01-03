import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/booking.dart';
import 'package:etravel_mobile/models/place_image.dart';
import 'package:etravel_mobile/repository/booking_repository.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:etravel_mobile/view/booking/booking_detail_view.dart';
import 'package:etravel_mobile/view/loading/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BookingListView extends StatefulWidget {
  const BookingListView({super.key});

  @override
  State<StatefulWidget> createState() => _BookingListViewState();
}

class _BookingListViewState extends State<BookingListView> {
  static const _pageSize = 7;

  final PagingController<int, Booking> _pagingController =
      PagingController(firstPageKey: 0);
  Future<void> _getTransaction(int pageKey) async {
    try {
      final response =
          await BookingRepository().getHistoryBookings(pageKey, _pageSize);
      final responseData =
          (response['bookings']['data'] as List<dynamic>).map((responseItem) {
        return Booking.fromJson(responseItem);
      }).toList();
      final isLastPage = responseData.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(responseData);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(responseData, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _getTransaction(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.grey.withOpacity(.1),
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(
            context.tr('booking_history'),
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _pagingController.refresh();
          },
          child: PagedListView<int, Booking>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Booking>(
              itemBuilder: (ctx, item, index) {
                var listPlaceImages = <PlaceImages>[];
                if (item.placeImages!.length >= 3) {
                  listPlaceImages = [
                    item.placeImages![0],
                    item.placeImages![1],
                    item.placeImages![2],
                  ];
                } else if (item.placeImages!.length >= 2) {
                  listPlaceImages = [
                    item.placeImages![0],
                    item.placeImages![1]
                  ];
                } else if (item.placeImages!.isNotEmpty) {
                  listPlaceImages = [item.placeImages![0]];
                }
                var time =
                    DateFormat('dd-MM-yyyy HH:mm').format(item.createTime!);
                return _buildHistoryBookingItem(
                  context,
                  item.id!,
                  item.statusName!,
                  item.status!,
                  time,
                  item.totalPlaces!,
                  item.total!,
                  listPlaceImages,
                );
              },
              firstPageProgressIndicatorBuilder: (_) => const LoadingView(),
            ),
          ),
        ),
      );

  Color getTextColor(int status) {
    switch (status) {
      case 1:
        return const Color(0xFF00AB56);

      case 0:
        return Colors.orange;
      case 5:
        return AppColors.primaryColor;
      default:
        return Colors.white;
    }
  }

  Color getBackgroundColor(int status) {
    switch (status) {
      case 1:
        return const Color(0xFFEFFFF4);
      case 0:
        return Colors.orange.withOpacity(.1);
      case 5:
        return AppColors.primaryColor.withOpacity(.1);
      default:
        return Colors.white;
    }
  }

  Widget _buildHistoryBookingItem(
    BuildContext context,
    int id,
    String statusName,
    int status,
    String createTime,
    int totalPlaces,
    double total,
    List<PlaceImages> placeImages,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingDetailView(id: id, statusName: statusName),
        ),
      ).then((reload) {
        if (reload) {
          _pagingController.refresh();
        }
      }),
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            margin: const EdgeInsets.only(top: 8, left: 15, right: 15),
            height: 180,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: getBackgroundColor(status),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    width: 120,
                    child: Text(
                      context.tr(statusName.toLowerCase()),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: getTextColor(status)),
                    ),
                  ),
                  _getAddressAndTime(id, createTime),
                  Row(
                    children: [
                      Text(
                        '$totalPlaces ${context.tr('places')}',
                        style: const TextStyle(fontWeight: FontWeight.w300),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Text(
                    '$total USD',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            width: 220,
            child: Stack(
              children: [
                placeImages.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(placeImages[0].url ??
                                'https://media.tacdn.com/media/attractions-splice-spp-674x446/09/28/d2/0c.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: 65,
                        height: 105,
                      )
                    : Container(),
                placeImages.length >= 2
                    ? Positioned(
                        left: 50,
                        child: RotationTransition(
                          turns: const AlwaysStoppedAnimation(10 / 180),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(placeImages[1].url ??
                                    'https://media.tacdn.com/media/attractions-splice-spp-674x446/09/28/d2/0c.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: 65,
                            height: 105,
                          ),
                        ),
                      )
                    : Container(),
                placeImages.length >= 3
                    ? Positioned(
                        left: 100,
                        child: RotationTransition(
                          turns: const AlwaysStoppedAnimation(20 / 180),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(placeImages[2].url ??
                                    'https://media.tacdn.com/media/attractions-splice-spp-674x446/09/28/d2/0c.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: 65,
                            height: 105,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Column _getAddressAndTime(int id, String createTime) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF1A94FF),
            ),
            const SizedBox(width: 5),
            Text(
              '${context.tr('booking')} $id',
              style: const TextStyle(fontWeight: FontWeight.w300),
            )
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const Icon(
              Icons.access_time_filled_sharp,
              color: Color(0xFFFC820A),
            ),
            const SizedBox(width: 5),
            Text(
              createTime,
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ],
    );
  }
}

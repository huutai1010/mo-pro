import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/repository/place_repository.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:etravel_mobile/view/loading/loading_view.dart';
import 'package:etravel_mobile/view/place/placedetail_view.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListPlacesView extends StatefulWidget {
  const ListPlacesView({super.key});

  @override
  State<ListPlacesView> createState() => _ListPlacesViewState();
}

class _ListPlacesViewState extends State<ListPlacesView> {
  static const _pageSize = 5;

  final PagingController<int, Place> _pagingController =
      PagingController(firstPageKey: 0);
  Future<void> _getListPlaces(int pageKey) async {
    try {
      final response =
          await PlaceRepository().getListPopularPlaces(pageKey, _pageSize);
      final responseData =
          (response['places']['data'] as List<dynamic>).map((responseItem) {
        return Place.fromJson(responseItem);
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
      _getListPlaces(pageKey);
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
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(
            context.tr('list_place'),
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
          elevation: 1,
          leading: Container(
            margin: const EdgeInsets.only(left: 15),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
        body: PagedListView<int, Place>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Place>(
              itemBuilder: (ctx, item, index) {
                return _buildPlaceItem(
                  context,
                  item.image!,
                  item.name!,
                  item.rate!,
                  item.price!,
                  item.id!,
                  countReviews: item.reviewsCount ?? 0,
                );
              },
              firstPageProgressIndicatorBuilder: (_) => const LoadingView()),
        ),
      );

  Widget _buildPlaceItem(BuildContext context, String image, String name,
      double rate, double price, int id,
      {int countReviews = 0}) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlaceDetailsView(
                placeId: id,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 117,
                  height: 117,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          rate >= 4.5
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 7),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.primaryColor,
                                  ),
                                  child: Text(
                                    context.tr('eTravel\'s choice'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )
                              : Container(),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(
                              name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(height: 7),
                          countReviews == 0
                              ? Text(
                                  context.tr('no_reviews'),
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 13),
                                )
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: Colors.orange[500],
                                      size: 14,
                                    ),
                                    Text(
                                      '$rate',
                                      style: TextStyle(
                                        color: Colors.orange[500],
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      ' (${countReviews == 0 ? context.tr('no_reviews') : '$countReviews ${context.tr('reviews')}'})',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 13,
                                      ),
                                    )
                                  ],
                                ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            context.tr('From'),
                            style: const TextStyle(fontSize: 11),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            '\$',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            ' $price',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

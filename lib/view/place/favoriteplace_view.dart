import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/favorite.dart';
import 'package:etravel_mobile/repository/place_repository.dart';
import 'package:etravel_mobile/view/place/placedetail_view.dart';
import 'package:etravel_mobile/view/widgets/grid_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FavoritePlaceView extends StatefulWidget {
  const FavoritePlaceView({super.key});

  @override
  State<FavoritePlaceView> createState() => _FavoritePlaceViewState();
}

class _FavoritePlaceViewState extends State<FavoritePlaceView> {
  static const _pageSize = 10;

  final PagingController<int, Favorite> _pagingController =
      PagingController(firstPageKey: 0);

  void _onSelectImage(BuildContext ctx, int placeId) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (c) => PlaceDetailsView(placeId: placeId),
      ),
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems =
          await PlaceRepository().getFavoritePlaces(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: Text(
            context.tr('favourite_places'),
            style: const TextStyle(fontSize: 16),
          ),
          centerTitle: true,
        ),
        PagedSliverGrid<int, Favorite>(
          pagingController: _pagingController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
            childAspectRatio: 2 / 3,
          ),
          builderDelegate: PagedChildBuilderDelegate<Favorite>(
            itemBuilder: (ctx, item, index) {
              return GestureDetector(
                onTap: () => _onSelectImage(ctx, item.placeId),
                child: GridImage(
                  url: item.url,
                ),
              );
            },
          ),
        ),
        //   SliverGrid(
        //     delegate: SliverChildBuilderDelegate(
        //       (ctx, index) {
        //         final key = ValueKey(
        //           _gridItems[index].placeId,
        //         );
        //         return GestureDetector(
        //           key: key,
        //           onTap: () => _onSelectImage(ctx, _gridItems[index].placeId),
        //           child: GridImage(
        //             url: _gridItems[index].url,
        //             key: key,
        //           ),
        //         );
        //       },
        //       childCount: _gridItems.length,
        //     ),
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 3,
        //       mainAxisSpacing: 3,
        //       crossAxisSpacing: 3,
        //       childAspectRatio: 2 / 3,
        //     ),
        //   )
        // ],
      ]),
      // _isLoading
      //     ? const LoadingIndicator()
      //     : RefreshIndicator(
      //         onRefresh: _fetchAndSetFavoritePlaces,
      //         child: CustomScrollView(
      //           slivers: [
      //             SliverAppBar(
      //               pinned: true,
      //               foregroundColor: Colors.black,
      //               backgroundColor: Colors.white,
      //               title: Text(
      //                 context.tr('favourite_places'),
      //                 style: const TextStyle(fontSize: 16),
      //               ),
      //               centerTitle: true,
      //             ),
      //             SliverGrid(
      //               delegate: SliverChildBuilderDelegate(
      //                 (ctx, index) {
      //                   final key = ValueKey(
      //                     _gridItems[index].placeId,
      //                   );
      //                   return GestureDetector(
      //                     key: key,
      //                     onTap: () =>
      //                         _onSelectImage(ctx, _gridItems[index].placeId),
      //                     child: GridImage(
      //                       url: _gridItems[index].url,
      //                       key: key,
      //                     ),
      //                   );
      //                 },
      //                 childCount: _gridItems.length,
      //               ),
      //               gridDelegate:
      //                   const SliverGridDelegateWithFixedCrossAxisCount(
      //                 crossAxisCount: 3,
      //                 mainAxisSpacing: 3,
      //                 crossAxisSpacing: 3,
      //                 childAspectRatio: 2 / 3,
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
    );
  }
}

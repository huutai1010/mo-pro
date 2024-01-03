import 'package:chip_list/chip_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/category.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:etravel_mobile/view/loading/loading_view.dart';
import 'package:etravel_mobile/view/map/search_result_view.dart';
import 'package:etravel_mobile/view/place/placedetail_view.dart';
import 'package:etravel_mobile/view_model/search_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SearchPlaceView extends StatefulWidget {
  const SearchPlaceView({super.key});

  @override
  State<SearchPlaceView> createState() => _SearchPlaceViewState();
}

class _SearchPlaceViewState extends State<SearchPlaceView> {
  var searchPlaceController = TextEditingController();
  String searchPlace = '';
  final _categoryNames = <String>[];
  late List<CategoryLanguage> categories = [];
  late List<Place> placesAround = [];
  final searchViewModel = SearchViewModel();
  final _selectedIndexes = <int>[];
  var selectedCaregories = <String>[];
  bool isLoading = false;
  late Future<List<CategoryLanguage>> getCategoryData;
  late Future<List<Place>> getPlacesArroundData;

  @override
  void initState() {
    getCategoryData = searchViewModel.getCategory();
    getPlacesArroundData = searchViewModel.getPlacesAround();

    getPlacesArroundData.then((value) {
      placesAround = value;
      loggerInfo.i('placesAround = ${placesAround.length}');
    });

    getCategoryData.then((value) {
      categories = value;
      categories.map((category) => category.name).toList().forEach((name) {
        if (name != null) {
          _categoryNames.add(name);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: LoadingView(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(context),
                  _buildChipChoices(),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      context.tr('recommended'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _buildPlacesRecommended(),
                ],
              ),
      ),
    );
  }

  FutureBuilder<List<Place>> _buildPlacesRecommended() {
    return FutureBuilder<List<Place>>(
        future: getPlacesArroundData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  placesAround.length,
                  (index) => GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PlaceDetailsView(placeId: placesAround[index].id!),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                          left: index == 0 ? 20 : 0, right: 15, top: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: .2),
                      ),
                      width: 220,
                      height: 265,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8)),
                              image: DecorationImage(
                                image: NetworkImage(placesAround[index].image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            height: 190,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: Text(
                              placesAround[index].name!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: placesAround[index].rate == 0.0
                                ? Text(
                                    context.tr('no_reviews'),
                                    style: const TextStyle(color: Colors.grey),
                                  )
                                : Row(
                                    children: [
                                      Row(
                                        children: List.generate(
                                          placesAround[index].rate!.toInt(),
                                          (index) => Container(
                                            margin:
                                                const EdgeInsets.only(right: 1),
                                            child: const Icon(
                                              Icons.star,
                                              size: 15,
                                              color: Color(0xFFFFB23F),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '(${placesAround[index].reviewsCount} ${context.tr('reviews')})',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF808080)),
                                      ),
                                    ],
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                const Spacer(),
                                Text(
                                  '\$${placesAround[index].price}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(.6),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          // return const Expanded(
          //     child: Center(child: CircularProgressIndicator()));
          return Skeleton(
            isLoading: true,
            skeleton: SkeletonItem(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      2,
                      (index) => Container(
                        margin: const EdgeInsets.only(top: 15, right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey,
                        ),
                        width: 220,
                        height: 265,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            child: const SizedBox(),
          );
        });
  }

  FutureBuilder<List<CategoryLanguage>> _buildChipChoices() {
    return FutureBuilder<List<CategoryLanguage>>(
      future: getCategoryData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin:
                const EdgeInsets.only(left: 10, right: 5, top: 15, bottom: 20),
            child: ChipList(
              supportsMultiSelect: true,
              shouldWrap: true,
              activeBgColorList: const [AppColors.primaryColor],
              inactiveBorderColorList: const [Colors.grey],
              inactiveBgColorList: const [Colors.white],
              activeTextColorList: const [Colors.white],
              inactiveTextColorList: const [Colors.black],
              listOfChipNames: _categoryNames,
              listOfChipIndicesCurrentlySeclected: _selectedIndexes,
              extraOnToggle: (index) {
                loggerInfo.i(index);
                selectedCaregories =
                    _selectedIndexes.map((e) => _categoryNames[e]).toList();
                loggerInfo.i(_selectedIndexes);
                loggerInfo.i(selectedCaregories);
                setState(() {});
              },
            ),
          );
        }

        return Skeleton(
            isLoading: true,
            skeleton: SkeletonItem(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: List.generate(
                        3,
                        (index) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey,
                          ),
                          margin: const EdgeInsets.only(right: 15),
                          width: 100,
                          height: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: List.generate(
                        2,
                        (index) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey,
                          ),
                          margin: const EdgeInsets.only(right: 15),
                          width: 130,
                          height: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            child: const SizedBox());
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 5),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    context.tr('find_your_places'),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            selectedCaregories.isNotEmpty
                ? TextButton(
                    onPressed: () async {
                      isLoading = true;
                      setState(() {});
                      await searchViewModel
                          .searchByCategories(_selectedIndexes)
                          .then((value) async {
                        await Future.delayed(const Duration(seconds: 1));
                        isLoading = false;
                        setState(() {});
                        if (searchViewModel.loading == false &&
                            value.isNotEmpty) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SearchResultView(listSearchPlaces: value),
                            ),
                          );
                        } else if (value.isEmpty) {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('No results found.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Ok'),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                    },
                    child: Text(
                      context.tr('search'),
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(width: 10)
          ],
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../repository/people_repository.dart';

import '../../res/colors/app_color.dart';
import '../widgets/account_item.dart';

const double _sliderMin = 0;
const double _sliderMax = 5000;

class NearbyPeopleView extends StatefulWidget {
  const NearbyPeopleView({super.key});

  @override
  State<NearbyPeopleView> createState() => _NearbyPeopleViewState();
}

class _NearbyPeopleViewState extends State<NearbyPeopleView> {
  late Future<dynamic> _recentPeopleFuture;
  final Map<int, bool> _idsToSend = {};
  double _sliderValue = _sliderMax;
  bool _isInit = true;
  List<dynamic> _recentPeople = [];
  List<dynamic> _filteredRecentPeople = [];

  get canSend => _idsToSend.containsValue(true);

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _recentPeopleFuture.then((value) {
        final responseData = value['accounts'] as List;
        setState(() {
          _recentPeople = responseData;
          _filteredRecentPeople = responseData;
        });
      });
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    _recentPeopleFuture = PeopleRepository().getRecentPeopleApi();
    super.initState();
  }

  Future<void> sendRequests() async {
    final ids = _idsToSend.keys;
    final sendNotificationActions = ids.map((id) async {
      return PeopleRepository().sendNotificationApi(1, id);
    });
    await Future.wait(sendNotificationActions);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Requests sent.'),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _onSliderValueChange(value) {
    setState(() {
      _sliderValue = value;
      if (_sliderValue == _sliderMax) {
        _filteredRecentPeople = _recentPeople;
      } else {
        _filteredRecentPeople = _recentPeople
            .where((element) => (element['distance'] as double) <= _sliderValue)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('recent_people'),
          style: const TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !canSend
          ? null
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
              ),
              onPressed: () => sendRequests(),
              child: Container(
                padding: const EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width * .5,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          context.tr('add_request'),
                          textAlign: TextAlign.center,
                        )),
                    const Icon(Icons.arrow_circle_right_sharp)
                  ],
                ),
              )),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 1.0,
                )
              ],
            ),
            child: Column(
              children: [
                Text(
                  "${_sliderValue.toStringAsFixed(0)}m",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _sliderMin.round().toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        min: _sliderMin,
                        max: _sliderMax,
                        value: _sliderValue,
                        onChanged: _onSliderValueChange,
                      ),
                    ),
                    Text(
                      _sliderMax.round().toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _filteredRecentPeople.length,
              itemBuilder: (c, index) {
                final account = _filteredRecentPeople[index];
                return AccountItem(
                  selected: _idsToSend[account['id']] ?? false,
                  onSelected: (value) {
                    setState(() {
                      if (!value!) {
                        _idsToSend.remove(account['id']);
                        return;
                      }
                      _idsToSend[account['id']] = value;
                    });
                  },
                  account: account,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/view/tour/historybookingtourdetail_view.dart';
import 'package:flutter/material.dart';

class HistoryBookingTourView extends StatelessWidget {
  const HistoryBookingTourView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            title: Text(
              'Tour booking history',
              style: TextStyle(fontSize: 16),
            ),
            centerTitle: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://www.exoticvoyages.com/uploads/images/userfiles/aerial_view_of_notredame_cathedral_basilica_of_saigon2.jpg'),
                            ),
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Tour ${index + 1}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                HistoryBookingTourDetailView(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        context.tr('photos'),
                                      ),
                                    )
                                  ],
                                ),
                                const Text(
                                  'e provided. Most of the higher-level scrollable widgets provide this information automatically.',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: 5,
            ),
          )
        ],
      ),
    );
  }
}

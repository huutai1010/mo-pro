import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/place_item.dart';
import 'package:flutter/material.dart';

class PlaceItemRow extends StatelessWidget {
  final bool isDescription;
  final PlaceItem placeItem;
  final double? distance;
  final Function() onTap;
  final ImageProvider image;

  const PlaceItemRow({
    super.key,
    required this.placeItem,
    required this.distance,
    required this.onTap,
    required this.image,
    this.isDescription = false,
  });

  @override
  Widget build(BuildContext context) {
    String distanceText = context.tr('disconnected');
    if (distance != null) {
      distanceText =
          '${context.tr('distance')}: ${distance!.toStringAsFixed(2)}m';
    }
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isDescription
                            ? placeItem.description!.name
                            : placeItem.name.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (!isDescription) Text(distanceText),
                    ]),
              ]),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

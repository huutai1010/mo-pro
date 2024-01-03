import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:flutter/material.dart';

import '../../models/place_image.dart';

class PlaceVisitImage extends StatefulWidget {
  final String address;
  final List<PlaceImages> images;
  const PlaceVisitImage({
    super.key,
    required this.address,
    required this.images,
  });

  @override
  State<PlaceVisitImage> createState() => _PlaceVisitImageState();
}

class _PlaceVisitImageState extends State<PlaceVisitImage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Row(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      widget.images.length,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.images[index].url!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(top: 5, right: 15),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.images[_selectedIndex].url!),
                    fit: BoxFit.cover,
                  ),
                ),
              ))
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.address,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

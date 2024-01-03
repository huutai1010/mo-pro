import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../const/const.dart';

class ChangeCurrencyPopup extends StatelessWidget {
  final int selectedIndex;
  const ChangeCurrencyPopup({
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('change_currency'),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.grey),
                )
              ],
            ),
            const Divider(),
            SingleChildScrollView(
              child: Column(
                children: List.generate(
                  kCurrencies.length,
                  (index) => GestureDetector(
                    onTap: () => Navigator.of(context).pop(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == selectedIndex
                            ? const Color.fromARGB(255, 85, 163, 227)
                                .withOpacity(.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: .1),
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/currency/${kCurrencies[index]['image']}.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(kCurrencies[index]['key'] ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              Text(
                                kCurrencies[index]['name'] ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 12),
                              ),
                            ],
                          ),
                          const Spacer(),
                          index == selectedIndex
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Color.fromARGB(255, 66, 167, 69),
                                  weight: 3,
                                )
                              : const Icon(Icons.check, color: Colors.white)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

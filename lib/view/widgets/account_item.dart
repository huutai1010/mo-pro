import 'package:flutter/material.dart';

const double containerHeight = 80.0;

class AccountItem extends StatelessWidget {
  final bool selected;
  final dynamic account;
  final Function(bool?) onSelected;

  const AccountItem({
    super.key,
    required this.selected,
    required this.account,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelected(!selected),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        margin: const EdgeInsets.only(
          right: 20,
          left: 10,
        ),
        child: SizedBox(
          width: double.infinity,
          height: containerHeight,
          child: Row(
            children: [
              Container(
                width: 60,
                height: containerHeight,
                decoration: account['image'] == null
                    ? null
                    : BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(account['image'])),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${account['firstName']} ${account['lastName']}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(account['distance'] as double).round()}m',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  size: 25.0,
                  color: Theme.of(context).colorScheme.primary,
                )
              else
                const Icon(
                  Icons.check_circle_rounded,
                  size: 25.0,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

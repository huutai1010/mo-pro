import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final Color backgroundColor;
  final Widget? title;
  const CommonAppBar({
    super.key,
    this.title,
    required this.appBar,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: true,
      backgroundColor: backgroundColor,
      shadowColor: Colors.transparent,
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';

class AppBarWidget extends AppBar {
  AppBarWidget({
    Key? key,
    bool showBackButton = true,
    required BuildContext context,
    VoidCallback? onBackPressed,
    String title = "",
    Color? backgroundColor,
    List<Widget> rightActions = const [],
  }) : super(
          key: key,
          centerTitle: true,
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            overflow: TextOverflow.ellipsis,
          ),
          elevation: 0,
          backgroundColor: backgroundColor ?? AppColors.main,
          leading: showBackButton
              ? IconButton(
                  onPressed: onBackPressed ??
                      () {
                        Navigator.of(context).pop(true);
                      },
                  icon: const Icon(
                    Icons.keyboard_backspace,
                    color: Colors.white,
                  ))
              : null,
          actions: rightActions,
        );
}

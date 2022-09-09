import 'package:flutter/material.dart';
  import 'package:flutter_base/commons/app_colors.dart';
  import 'package:flutter_base/commons/app_text_styles.dart';

class AppTokenExpiredDialog extends StatelessWidget {
  VoidCallback? onConfirm;

  AppTokenExpiredDialog({
    Key? key,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text("Thông báo"),
      content: Center(child: Text("Phiên bản đã hết hạn, vui lòng đăng nhập lại"),),
      actions: [
        FlatButton(
            onPressed: (){
              print("Navigate Login Screen");
            },
            child: Text(
              "Đồng ý"
            ))
      ],
    );
  }
}

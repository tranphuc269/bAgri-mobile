import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';

class AppInputDialog extends StatelessWidget {
  final VoidCallback? onConfirm;
  final String? title;
  List<Widget> actions = const [];

  AppInputDialog({
    Key? key,
    this.onConfirm,
    this.title,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(7),
        constraints: BoxConstraints(
          maxHeight: double.infinity,
        ),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(title ?? "Thông báo",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                fontFamily: "Helvetica"))),
                  ),
                  Column(mainAxisSize: MainAxisSize.min, children: actions),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: AppButton(
                            color: AppColors.redButton,
                            title: 'Hủy bỏ',
                            width: 80,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                            child: AppButton(
                                color: AppColors.main,
                                title: "Xác nhận",
                                textStyle: AppTextStyle.whiteS16Bold,
                                onPressed: onConfirm)),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

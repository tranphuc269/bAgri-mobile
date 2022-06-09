import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/utils/validators.dart';

class AppModifyDialog extends StatelessWidget {
  final VoidCallback? onConfirm;
  final VoidCallback? onCancle;
  final Text? title;
  final String? textSpan;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;

  AppModifyDialog({
    Key? key,
    this.onConfirm,
    this.onCancle,
    this.title,
    this.textSpan,
    this.hintText = '',
    this.validator,
    this.controller,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: title,
        content: Container(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width,
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 28),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: textSpan,
                      style: AppTextStyle.blackS14,
                    ),
                  ]),
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Form(
                    key: key,
                    child:AppTextField(
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      hintText: hintText.toString(),
                      controller: controller,
                      validator: validator,
                    ),
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                      height: 40,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: AppColors.redButton,
                      onPressed: onCancle,
                      child: Text("Hủy",
                          style: TextStyle(color: Colors.white, fontSize: 14))),
                  FlatButton(
                      height: 40,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: AppColors.main,
                      onPressed: onConfirm,
                      child: Text("Thêm",
                          style: TextStyle(color: Colors.white, fontSize: 14)))
                ],
              )

            ])),
      );
    });
  }
}

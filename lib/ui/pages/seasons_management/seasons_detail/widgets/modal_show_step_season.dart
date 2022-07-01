import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/configs/app_config.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_base/utils/date_utils.dart' as Util;

class ModalShowStepSeasonWidget extends StatefulWidget {
  const ModalShowStepSeasonWidget(
      {Key? key,
        this.name,
        this.description,
        this.start,
        this.end,
        this.from_day,
        this.to_day,
        required this.onEnd,
       })
      : super(key: key);
  final void Function() onEnd;
  final String? name;
  final String? start;
  final String? end;
  final int? from_day;
  final int? to_day;
  final String? description;


  @override
  State<ModalShowStepSeasonWidget> createState() =>
      _ModalShowStepSeasonWidgetState();
}

class _ModalShowStepSeasonWidgetState extends State<ModalShowStepSeasonWidget> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController descriptionController = TextEditingController(text: '');
  TextEditingController fromDayController = TextEditingController(text: '');
  TextEditingController toDayController = TextEditingController(text: '');
  late double heightResize = 0.5;
  String startTime = DateTime.now().toString().substring(0, 10);

  @override
  void initState() {
    super.initState();
    startTime = widget.start?.substring(0, 10) ?? startTime;
    nameController = TextEditingController(text: widget.name);
    descriptionController =
        TextEditingController(text: widget.description ?? 'Không có mô tả');
    fromDayController = TextEditingController(text: widget.from_day.toString());
    toDayController = TextEditingController(text: widget.to_day.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    toDayController.dispose();
    fromDayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentScope = FocusScope.of(context);
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    if (viewInsetsBottom == 0 || currentScope.hasPrimaryFocus == true) {
      setState(() {
        heightResize = 0.7;
      });
    } else {
      setState(() {
        heightResize = 0.95;
      });
    }
    return Container(
      height: MediaQuery.of(context).size.height * heightResize,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20))),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFECE5D5),
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20))),
            height: 40,
            child: Stack(
              children: [
                Center(
                  child: Container(
                      height: 40,
                      padding: EdgeInsets.all(10),
                      child: Text('Chỉnh sửa bước', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic), textAlign: TextAlign.center,)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        AppImages.icCloseCircleShadow,
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  AppTextField(
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    hintText: 'Tên của giai đoạn',
                    controller: nameController,
                   enable: false,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AppTextAreaField(
                    hintText: 'Mô tả',
                    // maxLines: 8,
                    enable: false,
                    controller: descriptionController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          hintText: 'Từ ... ngày',
                          enable: false,
                          keyboardType: TextInputType.number,
                          controller: fromDayController,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: AppTextField(
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          hintText: 'Đến ... ngày',
                          keyboardType: TextInputType.number,
                          controller: toDayController,
                          enable: false,

                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Ngày bắt đầu:',
                        style: AppTextStyle.greyS18,
                      ),
                      SizedBox(width: 15),
                      Text(
                        startTime,
                        style: AppTextStyle.blackS16
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                      SizedBox(width: 10),

                    ],
                  ),
                  if(GlobalData.instance.role == "GARDEN_MANAGER") ...[
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            isEnabled: (widget.end == null),
                            color: AppColors.redButton,
                            title: 'Kết thúc',
                            onPressed: () {
                              widget.onEnd();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }


}

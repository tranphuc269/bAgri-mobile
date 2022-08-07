import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/configs/app_config.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_base/utils/date_utils.dart' as Util;

class ModalEditStageSeasonWidget extends StatefulWidget {
  const ModalEditStageSeasonWidget(
      {Key? key,
        this.name,this.description,
        this.start,
        this.end,
        required this.onPressed,
        required this.onEnd,
        this.onDelete})
      : super(key: key);
  final void Function(String name, String description, String start) onPressed;
  final void Function() onEnd;
  final String? name;
  final String? start;
  final String? end;
  final String? description;
  final VoidCallback? onDelete;

  @override
  State<ModalEditStageSeasonWidget> createState() => _ModalEditStageSeasonWidgetState();
}

class _ModalEditStageSeasonWidgetState extends State<ModalEditStageSeasonWidget> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController descriptionController = TextEditingController(text: '');
  late double heightResize = 0.5;
  String startTime = DateTime.now().toString().substring(0,10);

  @override
  void initState() {
    super.initState();
    startTime = widget.start?.substring(0,10) ?? startTime;
    nameController = TextEditingController(text: widget.name);
    descriptionController = TextEditingController(text: widget.description ?? '');
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
                Container(
                    height: 40,
                    padding: EdgeInsets.all(10),
                    child: Text('Chỉnh sửa giai đoạn')),
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
                    hintText: 'Nhập tên của giai đoạn',
                    controller: nameController,
                    validator: (value) {
                      if (Validator.validateNullOrEmpty(value!))
                        return "Chưa nhập tên giai đoạn";
                      else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AppTextAreaField(
                    hintText: 'Mô tả',
                    maxLines: 8,
                    enable: true,
                    controller: descriptionController,
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
                        style: AppTextStyle.blackS16.copyWith(
                            decoration: TextDecoration.underline),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          final result = await showDatePicker(
                              context: context,
                              locale: Locale('vi'),
                              initialEntryMode:
                              DatePickerEntryMode.input,
                              builder: (context, child) {
                                return _buildCalendarTheme(child);
                              },
                              fieldHintText: "yyyy/mm/dd",
                              initialDate: widget.start!= null
                                  ? Util.DateUtils.fromString(
                                  widget.start,
                                  format: AppConfig
                                      .dateDisplayFormat)!
                                  : DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2024));
                          if (result != null) {
                            // widget.start =
                            //     Util.DateUtils.toDateString(
                            //         result);

                            startTime = Util.DateUtils.toDateString(
                                result);
                            setState(() {

                            });
                          }
                        },
                        child: SizedBox(
                          height: 26,
                          width: 26,
                          child: Image.asset(
                            AppImages.icCalendar,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Expanded(
                      //   child: AppButton(
                      //     color: AppColors.redButton,
                      //     title: 'Kết thúc',
                      //     onPressed: () {
                      //       widget.onEnd();
                      //       Navigator.of(context).pop();
                      //     },
                      //   ),
                      // ),
                      // SizedBox(width: 20),
                      Expanded(
                        child: AppButton(
                            color: AppColors.main,
                            title: 'Xác nhận',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.of(context).pop(true);
                                widget.onPressed(nameController.text, descriptionController.text, startTime);
                              }
                            }),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Theme _buildCalendarTheme(Widget? child) {
    return Theme(
      data: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
            primary: AppColors.main,
            surface: AppColors.main,
            // onSurface: AppColors.main,
            background: AppColors.main,
            onPrimary: Colors.white),
      ),
      child: SingleChildScrollView(child: child!),
    );
  }
}

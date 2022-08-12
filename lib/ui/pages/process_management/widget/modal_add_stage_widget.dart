import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/utils/validators.dart';

class ModalAddStageWidget extends StatefulWidget {
  const ModalAddStageWidget(
      {Key? key,
      this.name,this.description,
      required this.onPressed,
      this.onDelete})
      : super(key: key);
  final void Function(String name, String description) onPressed;
  final String? name;
  final String? description;
  final VoidCallback? onDelete;

  @override
  State<ModalAddStageWidget> createState() => _ModalAddStageWidgetState();
}

class _ModalAddStageWidgetState extends State<ModalAddStageWidget> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController descriptionController = TextEditingController(text: '');
  late double heightResize = 0.5;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    descriptionController = TextEditingController(text: widget.description);
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentScope = FocusScope.of(context);
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    if (viewInsetsBottom == 0 || currentScope.hasPrimaryFocus == true) {
      setState(() {
        heightResize = 0.75;
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
                    child: Text('Thêm giai đoạn')),
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
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppButton(
                          color: AppColors.redButton,
                          title: 'Hủy',
                          onPressed: () {
                            Navigator.of(context).pop();
                            // widget.onDelete!();
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: AppButton(
                            color: AppColors.main,
                            title: 'Xác nhận',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.of(context).pop(true);
                                widget.onPressed(nameController.text, descriptionController.text);
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
}

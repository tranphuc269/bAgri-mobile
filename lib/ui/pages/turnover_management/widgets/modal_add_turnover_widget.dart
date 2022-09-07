import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/utils/validators.dart';

class ModalAddTurnoverWidget extends StatefulWidget {
  const ModalAddTurnoverWidget(
      {Key? key,
        this.name,
        this.quantity,
        this.unit,
        this.unitPrice,
        required this.onPressed,
        this.onDelete})
      : super(key: key);
  final void Function(String name, num quantity, String unit, int? unitPrice) onPressed;
  final String? name;
  final num? quantity;
  final String? unit;
  final int? unitPrice;
  final VoidCallback? onDelete;

  @override
  State<ModalAddTurnoverWidget> createState() => _ModalAddTurnoverWidgetState();
}

class _ModalAddTurnoverWidgetState extends State<ModalAddTurnoverWidget> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController quantityController = TextEditingController(text: '');
  TextEditingController unitController = TextEditingController(text: '');
  TextEditingController unitPriceController = TextEditingController(text: '');
  late double heightResize = 0.5;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentScope = FocusScope.of(context);
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    if (viewInsetsBottom == 0 || currentScope.hasPrimaryFocus == true) {
      setState(() {
        heightResize = 0.6;
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
                    child: Text('Thêm doanh thu') ),
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
            height: 10,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextLabel("Loại"),
                      SizedBox(
                        height: 5,
                      ),
                      AppTextField(
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        hintText: 'Nhập tên loại',
                        controller: nameController,
                        suffixTextStyle: TextStyle(
                          color: AppColors.mainDarker,
                          fontSize: 18,
                        ),
                        validator: (value) {
                          if (Validator.validateNullOrEmpty(value!))
                            return "Chưa nhập loại";
                          else
                            return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _buildTextLabel("Sản lượng: "),
                      SizedBox(
                        height: 5,
                      ),
                      AppTextField(
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        hintText: 'Nhập vào sản lượng',
                        keyboardType: TextInputType.number,
                        controller: quantityController,
                        suffixTextStyle: TextStyle(
                          color: AppColors.mainDarker,
                          fontSize: 18,
                        ),
                        validator: (value) {
                          if (Validator.validateNullOrEmpty(value!))
                            return "Chưa nhập số lương vật tư";
                          else
                            return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _buildTextLabel("Đơn vị: "),
                      SizedBox(
                        height: 5,
                      ),
                      AppTextField(
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        hintText: 'Nhập vào đơn vị',
                        controller: unitController,
                        suffixTextStyle: TextStyle(
                          color: AppColors.mainDarker,
                          fontSize: 18,
                        ),
                        validator: (value) {
                          if (Validator.validateNullOrEmpty(value!))
                            return "Chưa nhập đơn vị";
                          else
                            return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _buildTextLabel("Đơn giá: "),
                      SizedBox(
                        height: 5,
                      ),
                      AppTextField(
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        hintText: 'Nhập vào đơn giá',
                        keyboardType: TextInputType.number,
                        controller: unitPriceController,
                        suffixTextStyle: TextStyle(
                          color: AppColors.mainDarker,
                          fontSize: 18,
                        ),
                        validator: (value) {
                          if (Validator.validateNullOrEmpty(value!))
                            return "Chưa nhập đơn giá";
                          else
                            return null;
                        },
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AppButton(
                                color: AppColors.main,
                                title: 'Xác nhận',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.of(context).pop();
                                    widget.onPressed(
                                      nameController.text,
                                      num.parse(quantityController.text),
                                      unitController.text,
                                      int.parse(unitPriceController.text),
                                    );
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

  Widget _buildTextLabel(String text) {
    return Container(
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: text,
            style: AppTextStyle.blackS14,
          ),
        ]),
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/garden_picker/app_garden_picker.dart';
import 'package:flutter_base/utils/validators.dart';

class AddContractTaskPage extends StatefulWidget {
  @override
  _AddContractTaskState createState() => _AddContractTaskState();
}

class _AddContractTaskState extends State<AddContractTaskPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final taskNameController = TextEditingController(text: "");
  late GardenPickerController gardenController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    gardenController = GardenPickerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      appBar: AppBarWidget(
        title: 'Thêm công việc hằng ngày',
        context: context,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildInput(),
            _buildButton(),
            SizedBox(height: 30,)
          ],
        ),
      )

    );
    Container(
      child: Text("Add ContractTaskPage"),
    );
  }
  Widget _buildInput() {
    return Expanded(
      child: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20.15),
                _buildTextLabel("Công việc: "),
                _buildNameTaskInput(),
                SizedBox(height: 3),
                _buildTextLabel("Chọn vườn:"),
                _buildGardenPicker(),

                SizedBox(height: 3),
                _buildTextLabel("Số bầu cây: "),
                _buildTreeQuantity(),
                SizedBox(height: 3,),
                _buildDatePicker(),
                // _buildTextLabel('Vai trò'),
                // // _buildRoleOption(),
                // SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
        return Container(
          height: 40,
          width: double.infinity,
          margin: EdgeInsets.only(top: 25),
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            children: [
                    Expanded(
                      child: AppButton(
                        color: AppColors.redButton,
                        title: 'Hủy bỏ',
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: AppButton(
                        color: AppColors.main,
                        title: 'Xác nhận',
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    )
            ],
          )

        );
      }

  Widget _buildTextLabel(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 28),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: text,
            style: AppTextStyle.blackS12,
          ),
        ]),
      ),
    );
  }

  Widget _buildNameTaskInput() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: AppTextField(
        autoValidateMode: AutovalidateMode.onUserInteraction,
        hintText: 'Nhập vào tên công việc',
        validator: (value) {
          if (Validator.validateNullOrEmpty(value!))
            return "Chưa nhập tên người dùng";
          else
            return null;
        },
      ),
    );
  }
  Widget _buildTreeQuantity(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child:  AppTextField(
        hintText: "Nhập số lượng bầu cây",
        keyboardType: TextInputType.number,
      ),
    );
  }
  Widget _buildGardenPicker(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child:  AppPageGardenPicker(
        controller: gardenController,
        onChanged: (value) {},
      ),
    );
  }
  Widget _buildDatePicker(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Row(children: [
        Text(
          'Ngày bắt đầu:',
          style: AppTextStyle.greyS18,
        ),
        SizedBox(width: 15),
        Text(
          "yyyy/mm/dd",
          style: AppTextStyle.blackS16
              .copyWith(decoration: TextDecoration.underline),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () async {
            final result = await showDatePicker(
                context: context,
                locale: Locale('vi'),
                initialEntryMode: DatePickerEntryMode.input,
                builder: (context, child) {
                  return _buildCalendarTheme(child);
                },
                fieldHintText: "yyyy/mm/dd",
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2024));
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
      ]),
    );
  }


  Widget _buildLabelText(String label) {
    return Text(
      label,
      style: AppTextStyle.greyS18,
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
      child: child!,
    );
  }
}

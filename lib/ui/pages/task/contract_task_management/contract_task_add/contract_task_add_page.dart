import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/garden_picker/app_garden_picker.dart';

class AddContractTaskPage extends StatefulWidget {
  @override
  _AddContractTaskState createState() => _AddContractTaskState();
}

class _AddContractTaskState extends State<AddContractTaskPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final taskNameController = TextEditingController(text: "");
  late GardenPickerController gardenController;

  @override
  void initState() {
    gardenController = GardenPickerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(
        title: 'Thêm công việc hằng ngày',
        context: context,
      ),
      body: _buildBody(),
    );
    Container(
      child: Text("Add ContractTaskPage"),
    );
  }

  Widget _buildBody() {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildLabelText("Tên công việc:"),
          SizedBox(height: 10),
          AppTextField(
            controller: taskNameController,
            hintText: 'Chọn tên công việc',
          ),
          SizedBox(height: 20),
          _buildLabelText("Chọn vườn:"),
          SizedBox(height: 10),
          AppPageGardenPicker(
            controller: gardenController,
            onChanged: (value) {},
          ),
          SizedBox(
            height: 20,
          ),
          _buildLabelText("Số lượng bầu cây:"),
          SizedBox(
            height: 10,
          ),
          AppTextField(
            hintText: "Nhập số lượng bầu cây",
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 20,
          ),
          Row(children: [
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
          SizedBox(height: 30),
          Row(children: [
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
          ]),
        ]),
      ),
    ));
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/contract_task_add/contract_task_add_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/garden_picker/app_garden_picker.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/process_picker/app_process_picker.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/season_picker/app_season_picker.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/work_picker/app_work_picker.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_base/utils/date_utils.dart' as Util;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddContractTaskPage extends StatefulWidget {
  final SeasonEntity? seasonEntity;

  AddContractTaskPage({Key? key, this.seasonEntity}) : super(key: key);

  @override
  _AddContractTaskState createState() => _AddContractTaskState();
}

class _AddContractTaskState extends State<AddContractTaskPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late ContractTaskAddingCubit _cubit;
  var treeQuantityController = TextEditingController(text: "");
  late SeasonPickerController seasonPickerController;
  late WorkPickerController workPickerController;
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  var initialValue = "";

  @override
  void initState() {
    _cubit = BlocProvider.of<ContractTaskAddingCubit>(context);

    seasonPickerController = SeasonPickerController();
    print(widget.seasonEntity);
    workPickerController = WorkPickerController();
    super.initState();
    seasonPickerController.addListener(() {
      _cubit.changeSeason(seasonPickerController.seasonEntity!);
    });
    workPickerController.addListener(() {
      _cubit.changeWork(workPickerController.contractWorkEntity!);
    });
  }

  @override
  void dispose() {
    super.dispose();
    seasonPickerController.dispose();
    workPickerController.dispose();
    treeQuantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        appBar: AppBarWidget(
          onBackPressed: (){
            Navigator.of(context).pop(false);
          },
          title: 'Thêm công việc hằng ngày',
          context: context,
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildInput(),
              _buildButton(),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ));
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
                _buildWorkPicker(),
                SizedBox(height: 3),
                _buildTextLabel("Chọn mùa:"),
                _buildSeasonPicker(),
                SizedBox(height: 3),
                _buildTextLabel("Số lượng: "),
                _buildTreeQuantity(),
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
                  if (_formKey.currentState!.validate()) {
                    await _cubit
                        .createContractTask(treeQuantityController.text);
                    Navigator.of(context).pop(true);
                  }
                },
              ),
            )
          ],
        ));
  }

  Widget _buildTextLabel(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 28),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: text,
            style: AppTextStyle.blackS16,
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

  Widget _buildTreeQuantity() {
    if (workPickerController.contractWorkEntity?.unit == "Đồng/bầu") {
      treeQuantityController = TextEditingController(
          text: seasonPickerController.seasonEntity?.treeQuantity.toString());
    } else {
      treeQuantityController = TextEditingController();
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: AppTextField(
        hintText: "Nhập số lượng ",
        keyboardType: TextInputType.number,
        controller: treeQuantityController,
        validator: (value) {
          if (Validator.validateNullOrEmpty(value!))
            return "Chưa nhập số lượng ";
          if (workPickerController.contractWorkEntity?.unit == "Đồng/bầu" &&
              (int.parse(treeQuantityController.text) >
                  (seasonPickerController.seasonEntity?.treeQuantity)!.toInt()))
            return "Số lượng đã lớn hơn số lượng bầu của vườn";
          else
            return null;
        },
        // initialValue: ,
      ),
    );
  }

  Widget _buildSeasonPicker() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: AppPageSeasonPicker(
        controller: seasonPickerController,
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildWorkPicker() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: AppPageWorkPicker(
        controller: workPickerController,
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildLabelText(String label) {
    return Text(
      label,
      style: AppTextStyle.greyS18,
    );
  }

  void changeDate(DateTime value) {
    selectedDate = value;
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

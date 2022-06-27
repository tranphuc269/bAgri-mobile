import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/contract_task_add/contract_task_add_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/garden_picker/app_garden_picker.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/process_picker/app_process_picker.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/work_picker/app_work_picker.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_base/utils/date_utils.dart' as Util;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddContractTaskPage extends StatefulWidget {
  const AddContractTaskPage({Key? key}) : super(key: key);

  @override
  _AddContractTaskState createState() => _AddContractTaskState();
}

class _AddContractTaskState extends State<AddContractTaskPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late ContractTaskAddingCubit _cubit;

  final treeQuantityController = TextEditingController(text: "");
  late GardenPickerController gardenController;
  late WorkPickerController workPickerController;
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  var initialValue = "";

  @override
  void initState() {
    _cubit = BlocProvider.of<ContractTaskAddingCubit>(context);
    gardenController = GardenPickerController();
    workPickerController = WorkPickerController();
    super.initState();
    gardenController.addListener(() {
      _cubit.changeGarden(gardenController.gardenEntity!);
    });
    workPickerController.addListener(() {
      _cubit.changeWork(workPickerController.contractWorkEntity!);
    });
  }
  @override
  void dispose() {
    super.dispose();
    gardenController.dispose();
    workPickerController.dispose();
    treeQuantityController.dispose();
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
                _buildTextLabel("Chọn vườn:"),
                _buildGardenPicker(),
                SizedBox(height: 3),
                _buildTextLabel("Số bầu cây: "),
                _buildTreeQuantity(),
                // SizedBox(height: 3,),
                // _buildDatePicker(),
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
                 await _cubit.createContractTask(treeQuantityController.text);
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
    return Container(
            margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: AppTextField(
              hintText: "Nhập số lượng bầu cây",
              keyboardType: TextInputType.number,
              controller: treeQuantityController,
             // initialValue: ,
            ),
          );
  }

  Widget _buildGardenPicker() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: AppPageGardenPicker(
        controller: gardenController,
        onChanged: (value) {},
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

  // Widget _buildDatePicker() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(25.0),
  //     ),
  //     child: Row(children: [
  //       Text(
  //         'Ngày bắt đầu:',
  //         style: AppTextStyle.greyS16,
  //       ),
  //       SizedBox(width: 15),
  //       Text(
  //         "${selectedDate.toLocal()}".split(' ')[0],
  //         style: AppTextStyle.blackS16
  //             .copyWith(decoration: TextDecoration.underline),
  //       ),
  //       SizedBox(width: 10),
  //       GestureDetector(
  //         onTap: () async {
  //           final result = await showDatePicker(
  //               context: context,
  //               locale: Locale('vi'),
  //               initialEntryMode: DatePickerEntryMode.input,
  //               builder: (context, child) {
  //                 return _buildCalendarTheme(child);
  //               },
  //               fieldHintText: "yyyy/mm/dd",
  //               initialDate: DateTime.now(),
  //               firstDate: DateTime.now(),
  //               lastDate: DateTime(2024));
  //           if(result != null){
  //             setState(() {
  //               changeDate(result);
  //             });
  //             // print(result);
  //             // // changeDate(result);
  //           }
  //         },
  //         child: SizedBox(
  //           height: 26,
  //           width: 26,
  //           child: Image.asset(
  //             AppImages.icCalendar,
  //             fit: BoxFit.fill,
  //           ),
  //         ),
  //       ),
  //     ]),
  //   );
  // }


  Widget _buildLabelText(String label) {
    return Text(
      label,
      style: AppTextStyle.greyS18,
    );
  }
  void changeDate(DateTime value){
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
      child: child!,
    );
  }
}

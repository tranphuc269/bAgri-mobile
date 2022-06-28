import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/daily_task_widget.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_task_add/temporary_task_add_cubit.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/widget/modal_add_daily_task_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/garden_picker/app_garden_picker.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TemporaryTaskAddPage extends StatefulWidget {
  String? garden;

  @override
  _TemporaryTaskAddPageState createState() {
    return _TemporaryTaskAddPageState();
  }
}

class _TemporaryTaskAddPageState extends State<TemporaryTaskAddPage> {
  final _formKey3 = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late GardenPickerController gardenController;
  late TemporaryTaskAddCubit _cubit;

  @override
  void initState() {
    nameController = TextEditingController();
    gardenController = GardenPickerController();
    descriptionController = TextEditingController();
    _cubit = BlocProvider.of<TemporaryTaskAddCubit>(context);
    gardenController.addListener(() {
      _cubit.changeGarden(gardenController.gardenEntity!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(
        title: 'Tạo công nhật',
        context: context,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Form(
          key: _formKey3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.15),
              _buildTextLabel('Tên công viêc: '),
              SizedBox(height: 5),
              BlocBuilder<TemporaryTaskAddCubit, TemporaryTaskAddState>(
                buildWhen: (prev, current) =>
                    prev.loadStatus != current.loadStatus,
                builder: (context, state) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: AppTextField(
                      hintText: 'Tên công việc',
                      controller: nameController,
                      onChanged: (value) {
                        _cubit.changeName(value);
                      },
                      validator: (value) {
                        if (Validator.validateNullOrEmpty(value!))
                          return "Chưa nhập tên công việc";
                        else
                          return null;
                      },
                    ),
                  );
                },
              ),
              _buildTextLabel("Chọn vườn:"),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: AppPageGardenPicker(
                  controller: gardenController,
                  onChanged: (value) {},
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // _buildTextLabel('Mô tả: '),
              // SizedBox(height: 5),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(25.0),
              //   ),
              //   child: AppTextAreaField(
              //     hintText: 'Mô tả',
              //     maxLines: 8,
              //     enable: true,
              //     controller: descriptionController,
              //   ),
              // ),
              _buildTextLabel("Danh sách việc:"),
              BlocBuilder<TemporaryTaskAddCubit, TemporaryTaskAddState>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.only(left: 160),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: AppButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Thêm công việc'),
                          FittedBox(
                              child: Icon(
                            Icons.add,
                            color: Color(0xFF373737),
                          )),
                        ],
                      ),
                      color: Color(0xFF8FE192),
                      height: 30,
                      width: double.infinity,
                      onPressed: () {
                        addDailyTask();
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              BlocBuilder<TemporaryTaskAddCubit, TemporaryTaskAddState>(
                builder: (context, state) {
                  return Column(
                    children: List.generate(
                      state.dailyTasks?.length ?? 0,
                      (index) => DailyTaskWidget(
                        index: index,
                        dailyTask: state.dailyTasks![index],
                        onRemove: () {
                          _cubit.removeList(index);
                        },
                      ),
                      // Container(child: Text(state.dailyTasks![index].title ?? ""), color: Colors.blue,)
                    ),
                  );
                },
              ),
              buildActionCreate(context),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildTextLabel(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
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

  addDailyTask() {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20))),
        builder: (context) => Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20))),
              child: ModalAddDailyTaskWidget(
                cubit: _cubit,
                onDelete: () {},
                onPressed: (String name, String fee, String workerQuantity,
                    String startTime) {
                  _cubit.addList(name, fee, workerQuantity, startTime);
                },
              ),
            ));
  }

  Widget buildActionCreate(BuildContext context) {
    return BlocConsumer<TemporaryTaskAddCubit, TemporaryTaskAddState>(
      bloc: _cubit,
      listenWhen: (prev, current) {
        return prev.loadStatus != current.loadStatus;
      },
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.SUCCESS) {
          _showCreateSuccess();
        }
        if (state.loadStatus == LoadStatus.FAILURE) {
          showSnackBar('Có lỗi xảy ra!');
        }
      },
      builder: (context, state) {
        final isLoading = (state.loadStatus == LoadStatus.LOADING);
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: AppButton(
                  color: AppColors.redButton,
                  title: 'Hủy bỏ',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: AppButton(
                  width: 100,
                  color: AppColors.main,
                  title: 'Xác nhận',
                  onPressed: () {
                    if (_formKey3.currentState!.validate()) {
                      _cubit.createTemporaryTask();
                    }
                  },
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      message: message,
      typeSnackBar: '',
    ));
  }

  void _showCreateSuccess() async {
    showSnackBar('Tạo mới thành công!');
    Navigator.of(context).pop(true);
  }
}

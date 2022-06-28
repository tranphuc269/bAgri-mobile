import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/router/application.dart';
import 'package:flutter_base/router/routers.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_task_update/temporary_task_update_cubit.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/widget/modal_add_daily_task_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../main.dart';
import '../daily_task_widget.dart';

class TemporaryTaskUpdatePage extends StatefulWidget{
  String? temporaryTaskId;
  TemporaryTaskUpdatePage({Key? key, required this.temporaryTaskId}) : super(key: key);
  @override
  _TemporaryTaskUpdatePageState createState() {
    return _TemporaryTaskUpdatePageState();
  }

}
class _TemporaryTaskUpdatePageState extends State<TemporaryTaskUpdatePage>{

  TemporaryTaskUpdateCubit? cubit;

  @override
  void initState() {
    cubit = BlocProvider.of<TemporaryTaskUpdateCubit>(context);
    cubit?.getTemporaryDetail(widget.temporaryTaskId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'Chỉnh sửa công việc',
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Scrollbar(
          isAlwaysShown: true,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocConsumer<TemporaryTaskUpdateCubit,
                    TemporaryTaskUpdateState>(listener: (context, state) {
                  if (state.loadStatus == LoadStatus.SUCCESS) {}
                }, builder: (context, state) {
                  return _buildInformation(
                      title: "Công việc: ",
                      information: state.temporaryTask?.title ?? "");
                }),
                SizedBox(
                  height: 10,
                ),
                BlocConsumer<TemporaryTaskUpdateCubit,
                    TemporaryTaskUpdateState>(listener: (context, state) {
                  if (state.loadStatus == LoadStatus.SUCCESS) {}
                }, builder: (context, state) {
                  return _buildInformation(
                      title: "Vườn: ",
                      information: state.temporaryTask?.garden ?? "");
                }),
                SizedBox(
                  height: 10,
                ),

                Text("Mô tả công việc từ kĩ thuật viên: ",
                    style: AppTextStyle.greyS16),
                SizedBox(height: 10),
                BlocConsumer<TemporaryTaskUpdateCubit,
                    TemporaryTaskUpdateState>(listener: (context, state) {
                  if (state.loadStatus == LoadStatus.SUCCESS) {}
                }, builder: (context, state) {
                      var description = state.temporaryTask?.description ?? 'Hiện chưa có';
                  return Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 0),
                    child: Text(
                     /* hintText:*/ state.temporaryTask?.description ?? ' Hiện chưa có',
                      // keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      // enable: false,
                      // textInputAction: TextInputAction.newline,
                    ),
                  );
                }),
                // Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 30),
                //     child: Text(
                //       widget.temporaryTask?.description ?? "",
                //       style: AppTextStyle.greyS16Bold,
                //     )),

                // if (GlobalData.instance.role == "ADMIN" ||
                //     GlobalData.instance.role == "SUPER_ADMIN")
                //
                SizedBox(
                  height: 5,
                ),
                Text("Danh sách công việc: ", style: AppTextStyle.greyS16),
                BlocBuilder<TemporaryTaskUpdateCubit, TemporaryTaskUpdateState>(
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
                SizedBox(height: 10),
                BlocConsumer<TemporaryTaskUpdateCubit,
                    TemporaryTaskUpdateState>(listener: (context, state) {
                  if (state.loadStatus == LoadStatus.SUCCESS) {}
                }, builder: (context, state) {
                    if (state.loadStatus == LoadStatus.LOADING) {
                      return Center(
                        child: CircularProgressIndicator(
                        color: AppColors.main,
                      ));
                    } else if (state.loadStatus == LoadStatus.FAILURE) {
                        return Container();
                    } else if (state.loadStatus ==
                    LoadStatus.SUCCESS) {
                      return state.dailyTasks!.length != 0
                          ? ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                DailyTaskWidget(
                                    onRemove: () {
                                      cubit?.removeList(index);
                                    },
                                    dailyTask: state.dailyTasks![index],
                                    isUpdate: true,
                                    index: index),
                            itemCount: state.dailyTasks?.length ?? 0,
                      ): Container();
                    }
                    return Container();
                }),
                SizedBox(height: 15,),
                _buildActionUpdate()
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildInformation({String? title, String? information}) {
    return Row(
      children: [
        Text(title!, style: AppTextStyle.greyS16),
        Text(information!, style: AppTextStyle.blackS16)
      ],
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
            // cubit: cubit,
            onDelete: () {},
            onPressed: (String name, String fee, String workerQuantity,
                String startTime) {
              cubit?.addList(name, fee, workerQuantity, startTime);
            },
          ),
        ));
  }
  Widget _buildActionUpdate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: AppButton(
            color: AppColors.redButton,
            title: 'Quay lại',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          child: AppButton(
            width: 100,
            color: AppColors.main,
            title: (GlobalData.instance.role == "ADMIN" ||
                GlobalData.instance.role == "SUPER_ADMIN") ? 'Cập nhật mô tả công việc' : 'Chỉnh sửa công việc',
            onPressed: () async {
              cubit?.updateTemporaryTask(widget.temporaryTaskId!);
                Navigator.of(context).pop(true);
            },
          ),
        ),
      ],
    );
  }

}
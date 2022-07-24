import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/router/application.dart';
import 'package:flutter_base/router/routers.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/daily_task_widget.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_task_detail/temporary_task_detail_cubit.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_task_update/temporary_task_update_page.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../main.dart';

class TemporaryTaskDetailPage extends StatefulWidget {
  TemporaryTask? temporaryTask;

  TemporaryTaskDetailPage({Key? key, this.temporaryTask}) : super(key: key);

  @override
  _TemporaryTaskDetailPageState createState() {
    return _TemporaryTaskDetailPageState();
  }
}

class _TemporaryTaskDetailPageState extends State<TemporaryTaskDetailPage> {
  TemporaryTaskDetailCubit? cubit;
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    cubit = BlocProvider.of<TemporaryTaskDetailCubit>(context);
    cubit?.getTemporaryDetail(widget.temporaryTask!.temporaryTaskId);
    cubit!.getSeasonDetail(widget.temporaryTask!.season);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'Công nhật',
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
                BlocConsumer<TemporaryTaskDetailCubit,
                    TemporaryTaskDetailState>(listener: (context, state) {
                  if (state.loadStatus == LoadStatus.SUCCESS &&
                      state.getSeasonStatus == LoadStatus.SUCCESS) {}
                }, builder: (context, state) {
                  return Column(
                    children: [
                      _buildInformation(
                          title: "Công việc: ",
                          information: state.temporaryTask?.title ?? ""),
                      SizedBox(
                        height: 10,
                      ),
                      _buildInformation(
                          title: "Vườn: ",
                          information:
                              state.seasonEntity?.gardenEntity!.name ?? ""),
                      SizedBox(
                        height: 10,
                      ),
                      _buildInformation(
                          title: "Diện tích: ",
                          information: (state.seasonEntity?.gardenEntity!.area
                                      .toString() ??
                                  "") +
                              " " +
                              (state.seasonEntity?.gardenEntity!.areaUnit
                                      .toString() ??
                                  "")),
                    ],
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                // BlocConsumer<TemporaryTaskDetailCubit,
                //     TemporaryTaskDetailState>(listener: (context, state) {
                //   if (state.loadStatus == LoadStatus.SUCCESS) {}
                // }, builder: (context, state) {
                //   return _buildInformation(
                //       title: "Vườn: ",
                //       information: state.temporaryTask?.garden ?? "");
                // }),
                // SizedBox(
                //   height: 10,
                // ),
                // if (widget.temporaryTask?.description != null) ...[
                Text("Mô tả công việc từ kĩ thuật viên: ",
                    style: AppTextStyle.greyS16),
                SizedBox(height: 10),
                BlocConsumer<TemporaryTaskDetailCubit,
                    TemporaryTaskDetailState>(listener: (context, state) {
                  if (state.loadStatus == LoadStatus.SUCCESS) {}
                }, builder: (context, state) {
                  if (state.temporaryTask?.description != null) {
                    descriptionController = TextEditingController(
                        text: state.temporaryTask?.description);
                  }
                  return Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 0),
                    child: AppTextAreaField(
                      controller: descriptionController,
                      onSaved: (value) {
                        cubit?.changeDescription(value);
                      },
                      hintText:
                          state.temporaryTask?.description ?? ' Hiện chưa có',
                      keyboardType: TextInputType.multiline,
                      enable: (GlobalData.instance.role == "ADMIN" ||
                          GlobalData.instance.role == "SUPER_ADMIN"),
                      textInputAction: TextInputAction.newline,
                    ),
                  );
                }),
                // Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 30),
                //     child: Text(
                //       widget.temporaryTask?.description ?? "",
                //       style: AppTextStyle.greyS16Bold,
                //     )),
                // ],
                // if (GlobalData.instance.role == "ADMIN" ||
                //     GlobalData.instance.role == "SUPER_ADMIN")
                //
                SizedBox(
                  height: 5,
                ),
                Text("Danh sách công việc: ", style: AppTextStyle.greyS16),
                SizedBox(
                  height: 10,
                ),
                BlocConsumer<TemporaryTaskDetailCubit,
                    TemporaryTaskDetailState>(listener: (context, state) {
                  if (state.loadStatus == LoadStatus.SUCCESS) {}
                }, builder: (context, state) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => DailyTaskWidget(
                        dailyTask: state.temporaryTask?.dailyTasks![index],
                        index: index),
                    itemCount: state.temporaryTask?.dailyTasks?.length ?? 0,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
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
                    GlobalData.instance.role == "SUPER_ADMIN")
                ? 'Cập nhật mô tả công việc'
                : 'Chỉnh sửa công việc',
            onPressed: () async {
              if (GlobalData.instance.role == "ADMIN" ||
                  GlobalData.instance.role == "SUPER_ADMIN") {
                cubit?.changeDescription(descriptionController.text);
                cubit?.updateTemporaryDetail();
                Navigator.pop(context);
              } else {
                bool isUpdate = await Application.router!.navigateTo(
                  appNavigatorKey.currentContext!,
                  Routes.updateTemporaryTask,
                  routeSettings: RouteSettings(
                      arguments: TemporaryTaskUpdateArgument(
                          temporaryTask: widget.temporaryTask)),
                );
                if (isUpdate) {
                  _refreshData();
                }
              }
            },
          ),
        ),
      ],
    );
  }

  _refreshData() {
    cubit?.getTemporaryDetail(widget.temporaryTask!.temporaryTaskId!);
  }
}

class TemporaryTaskDetailArgument {
  TemporaryTask? temporaryTask;

  TemporaryTaskDetailArgument({
    this.temporaryTask,
  });
}

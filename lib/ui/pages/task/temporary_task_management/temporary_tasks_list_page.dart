import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/temporary_task_repository.dart';
import 'package:flutter_base/router/application.dart';
import 'package:flutter_base/router/routers.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_task_list_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_delete_dialog.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_emty_data_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/custome_slidable_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../main.dart';

class TabListTemporaryTask extends StatelessWidget {
  const TabListTemporaryTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final temporaryTaskRepository =
            RepositoryProvider.of<TemporaryTaskRepository>(context);
        return TemporaryTaskListCubit(
            temporaryTaskRepository: temporaryTaskRepository);
      },
      child: TemporaryTaskListPage(),
    );
  }
}

class TemporaryTaskListPage extends StatefulWidget {
  @override
  _TemporaryTaskListPageState createState() => _TemporaryTaskListPageState();
}

class _TemporaryTaskListPageState extends State<TemporaryTaskListPage> {
  bool selectTools = false;
  bool selectSupplies = true;
  TemporaryTaskListCubit? _cubit;
  final _scrollController = ScrollController();

  @override
  void initState() {
    _cubit = BlocProvider.of<TemporaryTaskListCubit>(context);
    _cubit!.getListTemporaryTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: _buildBody()),
        floatingActionButton: (GlobalData.instance.role != 'ACCOUNTANT')
            ? FloatingActionButton(
                heroTag: 'btnadd',
                backgroundColor: AppColors.main,
                onPressed: () async {
                  bool isAdd = await Application.router
                      ?.navigateTo(context, Routes.addTemporaryTask);
                  if (isAdd) {
                    _onRefreshData();
                    showSnackBar('Thêm mới thành công!');
                  }
                },
                child: Icon(
                  Icons.add,
                  size: 40,
                ),
              )
            : Container());
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: "success",
      message: message,
    ));
  }

  Widget _buildBody() {
    return BlocBuilder<TemporaryTaskListCubit, TemporaryTaskListState>(
      bloc: _cubit,
      buildWhen: (previous, current) =>
          previous.loadStatus != current.loadStatus,
      builder: (context, state) {
        if (state.loadStatus == LoadStatus.LOADING) {
          return Center(
              child: CircularProgressIndicator(
            color: AppColors.main,
          ));
        } else if (state.loadStatus == LoadStatus.FAILURE) {
          return AppErrorListWidget(onRefresh: _onRefreshData);
        } else if (state.loadStatus == LoadStatus.SUCCESS) {
          return state.temporaryTaskList!.length != 0
              ? RefreshIndicator(
                  color: AppColors.main,
                  onRefresh: _onRefreshData,
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 25),
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: state.temporaryTaskList!.length,
                    shrinkWrap: true,
                    primary: false,
                    controller: _scrollController,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 15);
                    },
                    itemBuilder: (context, index) {
                      String? name =
                          state.temporaryTaskList![index].title ?? "";
                      var temporaryTask = state.temporaryTaskList![index];
                      return _buildItem(
                        temporaryTask: temporaryTask,
                        onPressed: () async{
                          Application.router!.navigateTo(
                            appNavigatorKey.currentContext!,
                            Routes.temporaryTaskDetail,
                            routeSettings: RouteSettings(
                              arguments: temporaryTask.temporaryTaskId,
                            ),
                          );
                        },
                        onUpdate: () async {
                          bool isUpdate = await Application.router!.navigateTo(
                            appNavigatorKey.currentContext!,
                            Routes.updateTemporaryTask,
                            routeSettings:
                                RouteSettings(arguments: temporaryTask.temporaryTaskId,),
                          );
                          if (isUpdate) {
                            _onRefreshData();
                          }
                        },
                        onDelete: () async {
                          bool isDelete = await showDialog(
                              context: context,
                              builder: (context) => AppDeleteDialog(
                                    onConfirm: () async {
                                      await _cubit?.deleteTemporaryTask(state
                                          .temporaryTaskList![index]
                                          .temporaryTaskId!);
                                      // await _cubit!.deleteTemporary(state
                                      //     .listMaterials![index].materialId!);
                                      Navigator.pop(context, true);
                                    },
                                  ));

                          if (isDelete) {
                            await _onRefreshData();
                            showSnackBar('Xóa công việc thành công!');
                          }
                        },
                      );
                    },
                  ),
                )
              : /* Expanded(
                  child:*/
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: EmptyDataWidget(),
                    ),
                  ],
                  /*  ),*/
                );
        } else {
          return Container();
        }
      },
    );
  }

  Future<void> _onRefreshData() async {
    _cubit!.getListTemporaryTasks();
  }

  Widget _buildItem(
      {required TemporaryTask temporaryTask,
      String? avatarUrl,
      VoidCallback? onDelete,
      VoidCallback? onPressed,
      VoidCallback? onUpdate}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.grayEC,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Slidable(
          endActionPane: ActionPane(
            extentRatio: 1 / 3,
            motion: BehindMotion(),
            children: [
              CustomSlidableAction(
                  backgroundColor: AppColors.blueSlideButton,
                  foregroundColor: Colors.white,
                  onPressed: (BuildContext context) {
                    onUpdate?.call();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(AppImages.icSlideEdit),
                      ),
                      SizedBox(height: 4),
                      FittedBox(
                        child: Text(
                          'Sửa',
                          style: AppTextStyle.whiteS16,
                        ),
                      )
                    ],
                  )),
              CustomSlidable(
                  backgroundColor: AppColors.redSlideButton,
                  foregroundColor: Colors.white,
                  onPressed: (BuildContext context) {
                    onDelete?.call();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(AppImages.icSlideDelete),
                      ),
                      SizedBox(height: 4),
                      FittedBox(
                        child: Text(
                          'Xóa',
                          style: AppTextStyle.whiteS16,
                        ),
                      )
                    ],
                  )),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
            child: Row(
              children: [
                Image.asset(avatarUrl ?? AppImages.icTemplateTask),
                SizedBox(width: 18),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      temporaryTask.title ?? "",
                      style: TextStyle(
                          color: Color(0xFF5C5C5C),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Vườn: ${temporaryTask.garden}",
                      style: AppTextStyle.blackS14,
                    )
                  ],
                )),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                  size: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

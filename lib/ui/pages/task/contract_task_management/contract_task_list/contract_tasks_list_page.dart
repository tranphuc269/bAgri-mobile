import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/models/entities/task/contract_task.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/contract_task_responsitory.dart';
import 'package:flutter_base/router/application.dart';
import 'package:flutter_base/router/routers.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/contract_task_add/contract_task_add_page.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/contract_task_detail/contract_task_detail_page.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/contract_task_list/contract_tasks_list_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_delete_dialog.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_emty_data_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/custome_slidable_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_base/utils/date_utils.dart' as Util;
import 'package:intl/intl.dart';

class TabListContractTask extends StatelessWidget {
  const TabListContractTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final contractTaskRepository =
            RepositoryProvider.of<ContractTaskRepository>(context);
        return ContractTaskListCubit(
            contractTaskRepositoy: contractTaskRepository);
      },
      child: ContractTaskListPage(),
    );
  }
}

class ContractTaskListPage extends StatefulWidget {
  @override
  _ContractTaskListState createState() => _ContractTaskListState();
}

class _ContractTaskListState extends State<ContractTaskListPage>
    with AutomaticKeepAliveClientMixin {
  bool selectTools = false;
  bool selectSupplies = true;
  ContractTaskListCubit? _cubit;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<ContractTaskListCubit>(context);
    _cubit!.fetchListContractTask();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildBody(),
        floatingActionButton: (GlobalData.instance.role != 'ACCOUNTANT')
            ? FloatingActionButton(
                backgroundColor: AppColors.main,
                onPressed: () async {
                  bool isAdd = await Application.router
                      ?.navigateTo(context, Routes.addContractTask);
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

  Widget _buildBody() {
    return BlocBuilder<ContractTaskListCubit, ContractTaskListState>(
        bloc: _cubit,
        buildWhen: (previous, current) =>
            previous.getListContractTaskStatus !=
            current.getListContractTaskStatus,
        builder: (context, state) {
          if (state.getListContractTaskStatus == LoadStatus.LOADING) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.main,
            ));
          } else if (state.getListContractTaskStatus == LoadStatus.FAILURE) {
            return AppErrorListWidget(onRefresh: _onRefreshData);
          } else if (state.getListContractTaskStatus == LoadStatus.SUCCESS) {
            return state.listContractTasks!.length != 0
                ? RefreshIndicator(
                    color: AppColors.main,
                    onRefresh: _onRefreshData,
                    child: SlidableAutoCloseBehavior(
                      child: ListView.separated(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 25),
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: state.listContractTasks!.length,
                        shrinkWrap: true,
                        primary: false,
                        controller: _scrollController,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          ContractTask contractTask =
                              state.listContractTasks![index];
                          return _buildItem(
                              contractTask: contractTask,
                              onDelete: () async {
                                bool isDelete = await showDialog(
                                    context: context,
                                    builder: (context) => AppDeleteDialog(
                                          onConfirm: () {
                                            _cubit!.deleteContractTask(
                                                contractTask.id);
                                            Navigator.pop(context, true);
                                          },
                                        ));
                                if (isDelete) {
                                  _onRefreshData();
                                  showSnackBar('Đã xóa thành công!');
                                }
                              },
                              onPressed: () {
                                Application.router?.navigateTo(
                                  context,
                                  Routes.contractTaskDetailAdmin,
                                  routeSettings: RouteSettings(
                                    arguments: ContractTaskDetailArgument(
                                        contractTask_id: contractTask.id),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  )
                : /*Expanded(
                  child:*/
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: EmptyDataWidget(),
                      ),
                    ],
                    // ),
                  );
          } else {
            return Container();
          }
        });
  }

  _buildItem(
      {required ContractTask contractTask,
      String? avatarUrl,
      VoidCallback? onDelete,
      VoidCallback? onPressed,
      VoidCallback? onUpdate}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 85,
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
                const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: Row(
              children: [
                Image.asset(
                  avatarUrl ?? AppImages.icWorks,
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 18),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Công việc: ${contractTask.work!.title.toString()}",
                      style: TextStyle(
                          color: Color(0xFF5C5C5C),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.2,
                            child: Text("Vườn: ${contractTask.gardenName}",
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),

                        contractTask.end == null
                            ? Expanded(
                              flex:2 ,
                              child: Text(
                                  "Đang thực hiện",
                                  style: TextStyle(
                                      color: Color(0xFF5C5C5C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                            )
                            : Expanded(
                          flex: 2,
                              child: Text(
                                  "Đã hoàn thành",
                                  style: TextStyle(
                                      color: AppColors.main,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                            )
                      ],
                    ),
                    SizedBox(height: 3,),
                    Container(
                        // width: MediaQuery.of(context).size.width * 0.45,
                        child: Row(
                      children: [
                        Text(
                          'Ngày bắt đầu: ',
                        ),
                        Text(
                          //"${DateTime.parse(contractTask.start.toString()).toLocal()}".split(' ')[0],
                          "${dateFormat.format(DateTime.parse(contractTask.start.toString()))}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ))
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

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {}
  }

  Future<void> _onRefreshData() async {
    await _cubit!.fetchListContractTask();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: "success",
      message: message,
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

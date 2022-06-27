import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/router/application.dart';
import 'package:flutter_base/router/routers.dart';
import 'package:flutter_base/ui/pages/storage_manager/list_materials/storage_management_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_delete_dialog.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_emty_data_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/custome_slidable_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../main.dart';

class TabMaterialList extends StatelessWidget {
  const TabMaterialList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialListPage();
  }
}

class MaterialListPage extends StatefulWidget {
  @override
  _MaterialListPageState createState() {
    return _MaterialListPageState();
  }
}

class _MaterialListPageState extends State<MaterialListPage> {
  StorageManagementCubit? _cubit;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    _cubit = BlocProvider.of<StorageManagementCubit>(context);
    _cubit!.fetchListMaterials();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {}
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child:
              _buildBody(),
              // Padding(
              //   padding:
              //       EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 25),
              //   child: _buildItem(name: "Vật tư"),
              // ),


        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.main,
          onPressed: () async {
            bool isAdd = await Application.router!
                .navigateTo(context, Routes.addMaterial);

            if (isAdd) {
              _onRefreshData();
              // if (_cubit!.loadingStatus == LoadStatus.SUCCESS)
              //   showSnackBar('Thêm mới mùa vụ thành công!');
            }
          },
          child: Icon(
            Icons.add,
            size: 40,
          ),
        ));
  }

  Widget _buildBody() {
    return BlocBuilder<StorageManagementCubit, StorageManagementState>(
      bloc: _cubit,
      buildWhen: (previous, current) =>
          previous.loadingStatus != current.loadingStatus,
      builder: (context, state) {
        if (state.loadingStatus == LoadStatus.LOADING) {
          return Center(
              child: CircularProgressIndicator(
            color: AppColors.main,
          ));
        } else if (state.loadingStatus == LoadStatus.FAILURE) {
          return AppErrorListWidget(onRefresh: _onRefreshData);
        } else if (state.loadingStatus == LoadStatus.SUCCESS) {
          return state.listMaterials!.length != 0
              ? RefreshIndicator(
                  color: AppColors.main,
                  onRefresh: _onRefreshData,
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 25),
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: state.listMaterials!.length,
                    shrinkWrap: true,
                    primary: false,
                    controller: _scrollController,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 15);
                    },
                    itemBuilder: (context, index) {
                      String? name = state.listMaterials![index].name ?? "";
                      var material =
                          state.listMaterials![index];
                      return _buildItem(
                        name: name,
                        quantity: state.listMaterials![index].quantity,
                        unit: state.listMaterials![index].unit,
                        unitPrice: state.listMaterials![index].unitPrice,
                        onUpdate: () async {
                          bool isUpdate = await Application.router!.navigateTo(
                            appNavigatorKey.currentContext!,
                            Routes.updateMaterial,
                            routeSettings: RouteSettings(
                              arguments: state.listMaterials![index].materialId
                            ),
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
                                      await _cubit!.deleteMaterial(state.listMaterials![index].materialId!);
                                      Navigator.pop(context, true);
                                    },
                                  ));

                          if (isDelete) {
                            await _onRefreshData();
                            showSnackBar('Xóa vật tư thành công!');
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
    _cubit!.fetchListMaterials();
  }

  _buildItem(
      {required String name,
        int? quantity,
        int? unitPrice, String? unit,
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
                Image.asset(avatarUrl ?? AppImages.icMaterial),
                SizedBox(width: 18),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          color: Color(0xFF5C5C5C),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.2,
                      child:
                          Text("Số lượng: ${quantity.toString()}  Đơn vị: ${unitPrice.toString()} $unit", overflow: TextOverflow.ellipsis),
                    ),
                  ],
                )),

              ],
            ),
          ),
        ),
      ),
    );
  }
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: "success",
      message: message,
    ));
  }

}

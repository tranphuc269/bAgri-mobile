import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/generated/l10n.dart';
import 'package:flutter_base/main.dart';
import 'package:flutter_base/models/entities/garden/garden_detail.dart';
import 'package:flutter_base/models/entities/garden/garden_entity.dart';

import 'package:flutter_base/models/enums/load_status.dart';

import 'package:flutter_base/router/application.dart';
import 'package:flutter_base/router/routers.dart';
import 'package:flutter_base/ui/pages/auth/login/login_cubit.dart';
import 'package:flutter_base/ui/pages/garden_management/garden_create/garden_create_page.dart';
import 'package:flutter_base/ui/pages/garden_management/garden_detail/garden_detail.dart';

import 'package:flutter_base/ui/pages/garden_management/garden_update/garden_update.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_delete_dialog.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_emty_data_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/custome_slidable_widget.dart';

import 'package:flutter_base/ui/widgets/error_list_widget.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'garden_list_cubit.dart';

class GardenListPage extends StatefulWidget {
  final String? zone_id;
  final String? titleScreen;
  GardenDetailEntityResponse? gardenDetail;

  GardenListPage({this.zone_id, this.titleScreen});

  @override
  _GardenListState createState() => _GardenListState();
}

class _GardenListState extends State<GardenListPage> {
  GardenListCubit? _cubit;

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<GardenListCubit>(context);
    _cubit!.getListGardenByZone(widget.zone_id);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: widget.titleScreen!,
        context: context,
      ),
      body: Container(
        child: BlocBuilder<GardenListCubit, GardenListState>(
          bloc: _cubit,
          buildWhen: (previous, current) =>
              previous.getGardenStatus != current.getGardenStatus,
          builder: (context, state) {
            if (state.getGardenStatus == LoginStatusBagri.LOADING) {
              return Center(
                  child: CircularProgressIndicator(
                color: AppColors.main,
              ));
            } else if (state.getGardenStatus == LoginStatusBagri.FAILURE) {
              return AppErrorListWidget(
                onRefresh: _onRefreshData,
              );
            } else if (state.getGardenStatus == LoginStatusBagri.SUCCESS) {
              return state.listGarden!.length != 0
                  ? RefreshIndicator(
                      color: AppColors.main,
                      onRefresh: _onRefreshData,
                      child: ListView.separated(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 25),
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: state.listGarden!.length,
                        shrinkWrap: true,
                        primary: false,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          GardenEntityResponseFromZoneId garden =
                              state.listGarden![index];
                          return _buildItem(
                              gardenName: garden.name ?? "",
                              gardenId: garden.garden_id ?? "",
                              areaUnit: garden.areaUnit ?? "",
                              area: garden.area,
                              onPressed: () async {
                                print(garden.garden_id);
                                // await showDialog(
                                //     context: context,
                                //     builder: (context) =>  GardenDetailDialog(
                                //       gardenId: garden.garden_id,
                                //       onConfirm: () async {
                                //         Navigator.pop(context, true);
                                //       },
                                //     ));
                                Application.router!.navigateTo(
                                  appNavigatorKey.currentContext!,
                                  Routes.gardenDetail,
                                  routeSettings: RouteSettings(
                                    arguments: GardenArgument(
                                      titleScreen: garden.name,
                                      garden_id: garden.garden_id,
                                    ),
                                  ),
                                );
                              },
                              onUpdate: () async {
                                print(widget.titleScreen);
                                print(garden.garden_id);

                                bool isUpdate =
                                    await Application.router!.navigateTo(
                                  appNavigatorKey.currentContext!,
                                  Routes.gardenUpdate,
                                  routeSettings: RouteSettings(
                                    arguments: GardenUpdateArgument(
                                      garden_Id: garden.garden_id,
                                      gardenName: garden.name,
                                      zoneName: widget.titleScreen
                                    ),
                                  ),
                                );
                                if (isUpdate) {
                                  _onRefreshData();
                                }
                              },
                              onDelete: () async {
                                bool isDelete = await showDialog(
                                    context: context,
                                    builder: (context) =>  AppDeleteDialog(
                                          onConfirm: () async {
                                            await _cubit!
                                                .deleteGarden(garden.garden_id);
                                            Navigator.pop(context, true);
                                          },
                                        ));

                                if (isDelete) {
                                  _onRefreshData();
                                  showSnackBar('Xóa vườn thành công!');
                                }
                              });
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [EmptyDataWidget()],
                      ),
                    );
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool isAdd =
              await Application.router?.navigateTo(context, Routes.gardenCreate,
                  routeSettings: RouteSettings(
                      arguments: GardenCreateArgument(
                    zone_id: widget.zone_id,
                    zoneName: widget.titleScreen,
                  )));
          if (isAdd) {
            _onRefreshData();
          }
        },
        backgroundColor: AppColors.main,
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }

  _buildItem(
      {required String gardenName,
      required String gardenId,

      int? area,
      String? avatarUrl,
      String? areaUnit,
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
                const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
            child: Row(
              children: [
                Image.asset(avatarUrl ?? AppImages.icGardenNoColor),
                SizedBox(width: 18),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                        '$gardenName',
                        style: AppTextStyle.greyS16Bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5,),
                      Text(
                        "Diện tích: ${area} ${areaUnit}",
                        style: AppTextStyle.greyS16,
                        overflow: TextOverflow.ellipsis,
                      )
                    ])),
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
  Widget _buildEmptyList() {
    return ErrorListWidget(
      text: S.of(context).no_data_show,
      onRefresh: _onRefreshData,
    );
  }

  Widget _buildFailureList() {
    return ErrorListWidget(
      text: S.of(context).error_occurred,
      onRefresh: _onRefreshData,
    );
  }

  Future<void> _onRefreshData() async {
    _cubit!.getListGardenByZone(widget.zone_id);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: "success",
      message: message,
    ));
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      // _cubit!.fetchNextGardenData();
    }
  }
  @override
  bool get wantKeepAlive => true;
}

class GardenListArgument {
  String? zone_id;
  String? titleScreen;
  String? area;

  GardenListArgument({this.zone_id, this.titleScreen, this.area});
}

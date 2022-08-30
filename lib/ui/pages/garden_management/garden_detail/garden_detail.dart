import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/widgets/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'garden_detail_cubit.dart';

class GardenDetailPage extends StatefulWidget {
  final String? garden_id;
  final String? titleScreen;

  GardenDetailPage({this.garden_id, this.titleScreen});

  @override
  _GardenDetailPageState createState() => _GardenDetailPageState();
}

class _GardenDetailPageState extends State<GardenDetailPage>
    with WidgetsBindingObserver {
  GardenDetailCubit? _cubit;
  late StreamSubscription _showMessageSubscription;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<GardenDetailCubit>(context);
    _cubit!.fetchGardenDetail(widget.garden_id);
    _showMessageSubscription =
        _cubit!.showMessageController.stream.listen((event) {
      _showMessage(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: widget.titleScreen!,
        context: context,
      ),
      body: _buildBodyGardenWidget(),
    );
  }

  Widget _buildBodyGardenWidget() {
    return BlocBuilder<GardenDetailCubit, GardenDetailState>(
      bloc: _cubit,
      buildWhen: (previous, current) =>
          previous.getGardenStatus != current.getGardenStatus,
      builder: (context, state) {
        if (state.getGardenStatus == LoadStatus.LOADING) {
          return Center(
              child: CircularProgressIndicator(
            color: AppColors.main,
          ));
        } else if (state.getGardenStatus == LoadStatus.FAILURE) {
          return AppErrorListWidget(onRefresh: _onRefreshData);
        } else if (state.getGardenStatus == LoadStatus.SUCCESS) {
          return RefreshIndicator(
            color: AppColors.main,
            onRefresh: _onRefreshData,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    // Center(child: Image.asset(AppImages.icCrop, width: 50, height: 50,)),
                    Text(
                      'Thông tin chi tiết:',
                      style: AppTextStyle.blackS18Bold,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tên vườn:',
                          style: AppTextStyle.blackS16,
                        ),
                        Text(' ${state.gardenData!.gardenName}'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(color: Colors.grey),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Diện tích: ",
                          style: AppTextStyle.blackS16,
                        ),
                        Text('${state.gardenData!.area} ${state.gardenData!.areaUnit}'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(color: Colors.grey),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Số lượng bầu: ",
                          style: AppTextStyle.blackS16,
                        ),
                        Text('${state.gardenData!.treePlaceQuantity} bầu'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(color: Colors.grey),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Người quản lý: ',
                          style: AppTextStyle.blackS16,
                        ),
                        Text('${state.gardenData!.manager} '),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }


  @override
  void dispose() {
    _showMessageSubscription.cancel();
    super.dispose();
  }

  Future<void> _onRefreshData() async {
    _cubit!.fetchGardenDetail(widget.garden_id);
  }

  void _showMessage(SnackBarMessage message) {
    _scaffoldKey.currentState!.removeCurrentSnackBar();
    _scaffoldKey.currentState!.showSnackBar(AppSnackBar(message: message));
  }
}

class GardenArgument {
  String? garden_id;
  String? titleScreen;
  String? area;

  GardenArgument({this.garden_id, this.titleScreen, this.area});
}

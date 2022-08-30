import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/main.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/router/application.dart';
import 'package:flutter_base/router/routers.dart';
import 'package:flutter_base/ui/pages/turnover_management/season_list/season_list_turnover_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_emty_data_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class SeasonListTurnoverPage extends StatefulWidget {
  @override
  _SeasonListTurnoverState createState() {
    return _SeasonListTurnoverState();
  }
}

class _SeasonListTurnoverState extends State<SeasonListTurnoverPage> {
  SeasonListTurnoverCubit? _cubit;
  final _scrollController = ScrollController();
  DateFormat _dateFormat = DateFormat("dd-MM-yyyy");

  @override
  void initState() {
    _cubit = BlocProvider.of<SeasonListTurnoverCubit>(context);
    _cubit?.getListSeason();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Danh sách mùa vụ',
        context: context,
      ),
      body: Container(
        child: BlocBuilder<SeasonListTurnoverCubit, SeasonListTurnoverState>(
          bloc: _cubit,
          builder: (context, state) {
            return _buildBody();
          },
        ),
      ),
    );
  }

  Future<void> refreshData() async {
    await _cubit?.getListSeason();
  }

  Widget _buildBody() {
    return BlocBuilder<SeasonListTurnoverCubit, SeasonListTurnoverState>(
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
          return AppErrorListWidget(onRefresh: refreshData);
        } else if (state.loadStatus == LoadStatus.SUCCESS) {
          return state.seasonList!.length != 0
              ? RefreshIndicator(
            color: AppColors.main,
            onRefresh: refreshData,
            child: SlidableAutoCloseBehavior(
              child: ListView.separated(
                padding: EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 25),
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: state.seasonList!.length,
                shrinkWrap: true,
                primary: false,
                controller: _scrollController,
                separatorBuilder: (context, index) =>
                    SizedBox(height: 10),
                itemBuilder: (context, index) {
                  SeasonEntity seasonEntity = state.seasonList![index];
                  return _buildItem(
                      seasonEntity: seasonEntity,
                    onPressed: (){
                      Application.router!.navigateTo(
                        appNavigatorKey.currentContext!,
                        Routes.seasonDetailForTurnover,
                        routeSettings: RouteSettings(
                          arguments: seasonEntity,
                        ),
                      );
                    }
                  );
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
      },
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: "success",
      message: message,
    ));
  }

  _buildItem(
      {required SeasonEntity seasonEntity,
        VoidCallback? onPressed,}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: AppColors.grayEC,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
            padding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 5),
            child: Row(
              children: [
                SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(AppImages.icCropNoColor)),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seasonEntity.name ?? '',
                        style: AppTextStyle.greyS16Bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cây trồng: ${seasonEntity.tree}',
                            style: AppTextStyle.greyS14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 15),
                          seasonEntity.end_date == null
                              ? Expanded(
                            flex: 1,
                            child: Text(
                              "Đang diễn ra",
                              style: TextStyle(
                                  color: Color(0xFF5C5C5C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                              : Expanded(
                            flex: 1,
                            child: Text(
                              "Đã kết thúc",
                              style: TextStyle(
                                  color: AppColors.main,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                  size: 20,
                )
              ],
            ),
          ),
        ),
      );
  }
}

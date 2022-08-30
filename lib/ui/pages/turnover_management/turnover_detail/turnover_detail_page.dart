import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/entities/task/work.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/components/app_button.dart';
import 'package:flutter_base/ui/pages/seasons_management/seasons_detail/widgets/detail_fee_tab.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_circular_progress_indicator.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'turnover_detail_cubit.dart';

class TurnoverDetailPage extends StatefulWidget {
  SeasonEntity thisSeason;

  TurnoverDetailPage({Key? key, required this.thisSeason}) : super(key: key);
  @override
  _TurnoverDetailState createState() {
    return _TurnoverDetailState();
  }
}

class _TurnoverDetailState extends State<TurnoverDetailPage> {
  late TurnoverDetailCubit _cubit;
  DateFormat _dateFormat = DateFormat("dd-MM-yyyy");
  final formatCurrency = new NumberFormat.currency(locale: 'vi');
  final formatCurrencyNoSymbol =  new NumberFormat.currency(locale: 'vi',symbol:'');
  @override
  void initState() {
    _cubit = BlocProvider.of<TurnoverDetailCubit>(context);
    super.initState();
    _cubit.getSeasonDetail(widget.thisSeason.seasonId ?? "");
    if (widget.thisSeason.end_date != null) {
      _cubit.calculateFee(widget.thisSeason.seasonId ?? "");
    }
  }

  Future<void> refreshData() async {
    await _cubit.getSeasonDetail(widget.thisSeason.seasonId ?? "");
    await _cubit.calculateFee(widget.thisSeason.seasonId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "${widget.thisSeason.name}",
        context: context,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder <TurnoverDetailCubit, TurnoverDetailState>(
      builder: (context, state) {
        if (state.loadStatus == LoadStatus.LOADING) {
          return Center(
            child: AppCircularProgressIndicator(),
          );
        } else if (state.loadStatus == LoadStatus.FAILURE) {
          return AppErrorListWidget(onRefresh: () async {
            refreshData();
          });
        } else if(state.loadStatus == LoadStatus.SUCCESS){
          return Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          "${formatCurrencyNoSymbol.format(((state.fee ?? 0) + (state.feeWorker ?? 0) + (state.feeMaterial ?? 0)))}",
                          style: TextStyle(
                              color: AppColors.mainDarker,
                              fontFamily: 'Roboto',
                              fontSize: 30,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Chi phí sản xuất",
                          style: TextStyle(
                            color: Color(0XFF7F8487),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                color: Color(0xFFF6F6F6),
                                elevation: 5,
                                borderRadius: BorderRadius.circular(5),
                                child: InkWell(
                                  onTap: () async {
                                    showPopUpDetailFee(
                                        listWork: state.listWork,
                                        listMaterial: state.listMaterial,
                                        feeWorker: state.feeWorker,
                                        fee: state.fee,
                                        feeMaterial: state.feeMaterial,
                                        index: 0
                                    );
                                  },
                                  child: Container(
                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width - 80) / 2,
                                    height: 80,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${formatCurrencyNoSymbol.format(state.feeWorker ?? 0)}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.mainDarker),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Chi phí công việc",
                                          style: TextStyle(
                                            color: Color(0XFF7F8487),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xFFF6F6F6),
                                child: InkWell(
                                  onTap: ()async {
                                      showPopUpDetailFee(
                                          listWork: state.listWork,
                                          listMaterial: state.listMaterial,
                                          feeWorker: state.feeWorker,
                                          fee: state.fee,
                                          feeMaterial: state.feeMaterial,
                                          index: 1);
                                  },
                                  child: Container(
                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width - 80) / 2,
                                    height: 80,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${formatCurrencyNoSymbol.format(state.feeMaterial ?? 0)}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.mainDarker),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Chi phí vật tư",
                                          style: TextStyle(
                                            color: Color(0XFF7F8487),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ])
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xFFF6F6F6),
                    elevation: 5,
                    child: Container(
                      height: 55,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Doanh thu:",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF393E46),
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${formatCurrency.format(state.season?.turnover ?? 0)}",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.mainDarker,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Thông tin chi tiết:",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF444444),
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Loại cây trồng: "),
                            Text(state.season?.tree ?? "")
                          ],
                        ),
                        Divider(color: Colors.grey),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Vườn: "), Text(state.season?.gardenEntity?.name ?? "")],
                        ),
                        Divider(color: Colors.grey),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Số lượng cây: "), Text(
                              "${state.season?.treeQuantity.toString() ?? ""} cây")],
                        ),
                        Divider(color: Colors.grey),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Ngày bắt đầu: "), Text(_dateFormat.format(DateTime.parse((state.season?.start_date).toString())))],
                        ),
                        Divider(color: Colors.grey),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Ngày kết thúc: "), Text(_dateFormat.format(DateTime.parse((state.season?.start_date).toString())))],
                        ),
                        Divider(color: Colors.grey)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _buildUpdateRevenueButton()
                ],
              ),
            ),
          );
        }else{
         return Container();
        }
      }
      );
  }

  Widget _buildUpdateRevenueButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Expanded(
        flex: 1,
        child: AppGreenButton(
          title: 'Cập nhât doanh thu',
          onPressed: () {},
        ),)
      ]),
    );
  }
  void showPopUpDetailFee(
      {required List<MaterialUsedByTask>? listMaterial,
        required List<Work>? listWork,
        required int? feeMaterial,
        required int? fee,
        required int? feeWorker, required int? index}) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return DetailFeeTabPage(
            listMaterial: listMaterial,
            listWork: listWork,
            feeMaterial: feeMaterial,
            fee: fee,
            feeWorker: feeWorker,
            index: index,
          );
        });
  }

}

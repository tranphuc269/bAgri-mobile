import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/entities/turnover/turnover_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/seasons_management/end_season/end_season_cubit.dart';
import 'package:flutter_base/ui/pages/turnover_management/widgets/modal_add_turnover_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_delete_dialog.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EndSeasonPage extends StatefulWidget {
  String seasonId;

  EndSeasonPage({Key? key, required this.seasonId}) : super(key: key);

  @override
  _EndSeasonState createState() => _EndSeasonState();
}

class _EndSeasonState extends State<EndSeasonPage> {
  EndSeasonCubit? _cubit;
  List<TurnoverEntity> turnovers = [];

  final formatCurrency = new NumberFormat.currency(locale: 'vi');
  
  ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    _cubit = BlocProvider.of<EndSeasonCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'Kết thúc mùa vụ',
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  fit: FlexFit.tight, flex: 2, child: _buildTotalTurnover()),
              SizedBox(
                height: 20,
              ),
              Flexible(fit: FlexFit.tight, child: _buildAddTurnoverButton()),
              Flexible(flex: 7, child: _buildListTurnover()),
              SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 25),
        width: 200,
        height: 40,
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () async {
            // print(widget.seasonId);
           await _cubit!.endSeason(widget.seasonId, turnovers);
           if(_cubit!.state.loadStatus == LoadStatus.SUCCESS){
                showSnackBar("Kết thúc mùa thành công", "success");
           }else{
             showSnackBar("Đã có lỗi xảy ra11", "error");
           }
          },
          color: AppColors.main,
          child: Text(
            "Xác nhận doanh thu",
            style: TextStyle(color: Colors.white, fontFamily: "Roboto"),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildAddTurnoverButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sản lượng và doanh thu:",
                style: TextStyle(
                    color: AppColors.mainDarker,
                    fontFamily: "Roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              FlatButton(
                  color: AppColors.main,
                  onPressed: () {
                    // addTurnover();
                    setState(() {
                      addTurnover();
                      listScrollController.animateTo(
                        listScrollController.position.maxScrollExtent,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        "Thêm",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListTurnover() {
    return ListView.builder(
        controller: listScrollController,
        itemCount: turnovers.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _buildTurnoverItem(turnovers[index], index);
        });
  }

  Widget _buildTotalTurnover() {
    return Stack(
      children: [
        Align(
          alignment: AlignmentDirectional.topEnd, // <-- SEE HERE
          child: Container(
            width: double.infinity,
            height: 50,
            color: AppColors.main,
          ),
        ),
        Align(
          alignment: AlignmentDirectional.topCenter, // <-- SEE HER
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width - 100,
              height: 130,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Tổng doanh thu",
                        style: TextStyle(
                            color: AppColors.mainDarker,
                            fontFamily: "Roboto",
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("${formatCurrency.format(caculateTotalTurnover())}",
                        style: TextStyle(
                            color: AppColors.mainDarker,
                            fontFamily: "Roboto",
                            fontSize: 25,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tổng sản lượng:",
                            style: TextStyle(
                                color: AppColors.gray,
                                fontFamily: "Roboto",
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        Text("${caculateTotalQuantity()} ${turnovers.length > 0 ? turnovers[0].unit : ""}",
                            style: TextStyle(
                                color: AppColors.gray,
                                fontFamily: "Roboto",
                                fontSize: 16,
                                fontWeight: FontWeight.w500))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTurnoverItem(TurnoverEntity? turnoverEntity, int? index) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: InkWell(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) => AppDeleteDialog(
                    onConfirm: () {
                      setState(() {
                        turnovers.removeAt(index!);
                      });
                      Navigator.pop(context, true);
                    },
                  ));
        },
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: ListTile(
            title: Text(
              "${turnoverEntity?.name}",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  fontFamily: "Roboto"),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sản lượng"),
                    Text("${turnoverEntity?.quantity} ${turnoverEntity?.unit}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Đơn giá"), Text("${formatCurrency.format(turnoverEntity?.unitPrice)}")],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Doanh thu"),
                    Text(
                      "${formatCurrency.format((turnoverEntity?.unitPrice ?? 0) * (turnoverEntity?.quantity ?? 0))}",
                      style: TextStyle(
                          color: AppColors.mainDarker, fontFamily: "Roboto"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  addTurnover() {
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
            child: ModalAddTurnoverWidget(
              onPressed:
                  (String name, num quantity, String unit, int? unitPrice) {
                setState(() {
                  turnovers.add(TurnoverEntity(
                    name: name,
                    quantity: quantity,
                    unit: unit,
                    unitPrice: int.parse(unitPrice.toString().replaceAll(".", "")),
                  ));
                  caculateTotalTurnover();
                });
              },
            )));
  }

  void showSnackBar(String message, String type) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: type,
      message: message,
    ));
  }

  caculateTotalTurnover(){
    num total = 0;
    for(var turnover in turnovers){
      total += (turnover.quantity ?? 0) * (turnover.unitPrice ?? 0);
    }
    return total;
  }
  caculateTotalQuantity(){
    num total = 0;
    for(var turnover in turnovers){
      total += turnover.quantity ?? 0;
    }
    return total;
  }
}

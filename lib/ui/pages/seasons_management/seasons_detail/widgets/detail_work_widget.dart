import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/models/entities/task/work.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class DetailWorkWidget extends StatelessWidget {
  // final List<DailyTask>? listDailyTask;
  // final List<MaterialUsedByTask>? listMaterial;
  final List<Work>? listWork;
  final int? fee;
  final int? feeWorker;
  final formatCurrency = new NumberFormat.currency(locale: 'vi');
  // final int? feeMaterial;

  DetailWorkWidget(
      {/*this.listDailyTask,*/
        // required this.listMaterial,
        required this.fee,
        required this.feeWorker,
        required this.listWork,
       /* required this.feeMaterial*/});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(child: Text("Tổng chi phí: ${formatCurrency.format(((fee ?? 0) + (feeWorker ?? 0)))}"),
              padding: EdgeInsets.all(10),
            ),
            Divider(),
           listWork != null ?  Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: listWork!.length ,
                shrinkWrap: true,
                primary: false,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 15);
                },
                itemBuilder: (context, index) {
                  var material = listWork![index];
                  return _buildItem(
                    name: material.title ?? "Công",
                    quantity: material.quantity,
                    unit: material.unit,
                  );
                },
              ),
            ): Container(),
          ],
        ));
  }

  _buildItem({
    required String name,
    int? quantity,
    String? unit,
    String? avatarUrl,
  }) {
    return GestureDetector(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.grayEC,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Slidable(
          child: Padding(
            padding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
            child: Row(
              children: [
                Image.asset(avatarUrl ?? AppImages.icWorks),
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
                          child: Text("Số lượng: ${quantity.toString()} Đơn vị: $unit",
                              overflow: TextOverflow.ellipsis),
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
}

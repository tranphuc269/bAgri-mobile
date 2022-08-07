import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/models/entities/task/work.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/custome_slidable_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DetailFeeWidget extends StatelessWidget {
  // final List<DailyTask>? listDailyTask;
  final List<MaterialUsedByTask>? listMaterial;
  // final List<Work>? listWork;
  // final int? fee;
  // final int? feeWorker;
  final int? feeMaterial;

  DetailFeeWidget(
      {/*this.listDailyTask,*/
      required this.listMaterial,
      // required this.fee,
      // required this.feeWorker,
      // required this.listWork,
      required this.feeMaterial});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(child: Text("Tổng chi phí vật tư: ${feeMaterial.toString()}"),
              padding: EdgeInsets.all(10),
            ),
            Divider(),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: listMaterial!.length,
                shrinkWrap: true,
                primary: false,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 15);
                },
                itemBuilder: (context, index) {
                  var material = listMaterial![index];
                  return _buildItem(
                    name: material.name ?? "Vật tư",
                    quantity: material.quantity,
                    unit: material.unit,
                  );
                },
              ),
            ),
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
                      child: Text("Số lượng: ${quantity.toString()} Đơn vị: ${unit}",
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

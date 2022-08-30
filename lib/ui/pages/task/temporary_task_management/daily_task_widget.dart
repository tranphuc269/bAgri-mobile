import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/models/entities/material/material_task.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/widgets/modal_modify_material_widget.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_task_update/temporary_task_update_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_delete_dialog.dart';

class DailyTaskWidget extends StatefulWidget {
  int? index;
  DailyTask? dailyTask;
  Function()? onRemove;
  Function()? onAddMaterial;
  bool? isUpdate;
  TemporaryTaskUpdateCubit? cubit;

  DailyTaskWidget(
      {Key? key,
      this.index,
      this.dailyTask,
      this.onRemove,
      this.onAddMaterial,
      this.cubit,
      this.isUpdate = false})
      : super(key: key);

  @override
  _DailyTaskWidgetState createState() {
    return _DailyTaskWidgetState();
  }
}

class _DailyTaskWidgetState extends State<DailyTaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(children: [
            // Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            Container(
              height: 40,
              width: double.infinity,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.colors[widget.index! % 10],
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      'Nhiệm vụ ${widget.dailyTask?.title}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    fit: FlexFit.tight,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      widget.dailyTask?.date?.substring(0, 10) != null
                          ? 'Thời gian: ${widget.dailyTask?.date?.substring(0, 10)}'
                          : "",
                      style: TextStyle(
                        color: Color(0xFFBBB5D4),
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            if (widget.isUpdate == true)
              GestureDetector(
                onTap: widget.onRemove,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 30,
                    padding: EdgeInsets.only(top: 7, right: 5),
                    child: FittedBox(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            // ]),
          ]),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  // width: double.infinity,
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        // width: double.infinity,
                        // height: 60,
                        width: MediaQuery.of(context).size.width - 20,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Color(0xFFDDDAEA),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Số nhân công:  ${widget.dailyTask?.workerQuantity.toString()} người',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Chi phí:  ${widget.dailyTask?.fee.toString()}',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: List.generate(
                            widget.dailyTask!.materials?.length ?? 0, (index) {
                          return materialItem(widget.dailyTask!.materials![index].name,widget.dailyTask!.materials![index].quantity, widget.dailyTask!.materials![index].unit, index);
                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text(
                            //       "Tên vật tư: " +
                            //           (widget.dailyTask!.materials![index]
                            //                   .name ??
                            //               ''),
                            //       style: TextStyle(
                            //         color: Colors.black54,
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.w500,
                            //       ),
                            //     ),
                            //     Text(
                            //       "Số lượng: " +
                            //           (widget.dailyTask!.materials![index]
                            //                   .quantity
                            //                   ?.toString() ??
                            //               '') +
                            //           (widget.dailyTask!.materials![index].unit
                            //                   ?.toString() ??
                            //               ''),
                            //       style: TextStyle(
                            //         color: Colors.black54,
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.w500,
                            //       ),
                            //     ),
                            //   ],
                            // )
                        }),
                      ),
                      if (widget.isUpdate == true)
                        Container(
                          // padding: const EdgeInsets.only(left: 180),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: AppButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Thêm vật tư'),
                                    FittedBox(
                                        child: Icon(
                                      Icons.add,
                                      color: Color(0xFF373737),
                                    )),
                                  ],
                                ),
                                color: Color(0xFFF1F7E7),
                                height: 30,
                                // border: 10,
                                width: 150,
                                onPressed: widget.onAddMaterial,

                                // showModalBottomSheet(
                                //   isDismissible: false,
                                //   context: context,
                                //   isScrollControlled: true,
                                //   backgroundColor: Colors.transparent,
                                //   shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.only(
                                //           topLeft:
                                //           const Radius.circular(20),
                                //           topRight:
                                //           const Radius.circular(20))),
                                //   builder: (context) => ModalAddStepWidget(
                                //     phase: widget.phase ?? "",
                                //     onPressed:
                                //         (name, startDate, endDate, stepId) {
                                // StepEntity step = StepEntity(
                                //     name: name,
                                //     from_day: int.parse(startDate),
                                //     to_day: int.parse(endDate));
                                //
                                // widget.cubitProcess
                                //     .createStep(widget.index!, step);
                                //       },
                                //     ),
                                //   );
                                // }),
                                // },
                                ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            ]),
        SizedBox(
          height: 5,
        )
        // )
      ],
    );
  }
  Widget materialItem(String? name, int? quantity, String? unit, int? index) {
    return GestureDetector(
        onLongPress: (){
          showDialog(
              context: context,
              builder: (context) => AppDeleteDialog(
                onConfirm: () {
                  setState(() {
                    widget.dailyTask?.materials!.removeAt(index!);
                  });
                  Navigator.pop(context, true);
                },
              ));
        },
        onTap: () {
          modifyMaterial(name: name, unit: unit, quantity: quantity, index: index);
        },
        child: Container(
          height: 60,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Color(0xFFF1F7E7),
              // border: Border.all(color:Color(0xFF9D9D9D) ),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tên vật tư:  $name",
                // "Tên vật tư: Phân bón",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Text('Số lượng: $quantity $unit'),
                  SizedBox(
                    width: 3,
                  ),
                ],
              )
            ],
          ),
        ));
  }
  modifyMaterial({String? name, int? quantity, String? unit, int? index}) {
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
          child: ModalModifyMaterialWidget(
            materialEntity: MaterialEntity(name: name, quantity: quantity, unit: unit),
            onPressed: (String name, String quantity, String unit) {
              setState(() {
                widget.dailyTask?.materials!.removeAt(index!.toInt());
                widget.dailyTask?.materials!.insert(index!, MaterialTask(
                    name: name,
                    quantity: int.parse(quantity.toString()),
                    unit: unit));
              });
            },
          ),
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';

class DailyTaskWidget extends StatefulWidget{
  int? index;
  DailyTask? dailyTask;
  Function()? onRemove;
  DailyTaskWidget({Key? key, this.index, this.dailyTask, this.onRemove}):super(key: key);
  @override
  _DailyTaskWidgetState createState() {
    return _DailyTaskWidgetState();
  }

}
class _DailyTaskWidgetState extends State<DailyTaskWidget>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 2, right: 2, bottom: 30),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        Text(
                          'Nhiệm vụ ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Thời gian: ',
                          style: TextStyle(
                            color: Color(0xFFBBB5D4),
                            fontSize: 14,
                          ),
                        ),
                        // BlocBuilder<ProcessSeasonCubit, ProcessSeasonState>(
                        //     buildWhen: (prev, current) =>
                        //     prev.actionWithStepStatus !=
                        //         current.actionWithStepStatus,
                        //     builder: (context, state) {
                        //       return Text(
                        //         widget.phase!,
                        //         style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 14,
                        //         ),
                        //       );
                        //     }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //       flex: 3,
                  //       child: Container(
                          // child: Column(
                          //   children: [
                          //     SizedBox(
                          //       height: 5,
                          //     ),
                              // BlocBuilder<ProcessSeasonCubit,
                              //     ProcessSeasonState>(
                              //   buildWhen: (prev, current) =>
                              //   prev.actionWithStepStatus !=
                              //       current.actionWithStepStatus,
                              //   builder: (context, state) {
                              //     return Column(
                              //       children: List.generate(
                              //           state.stages![widget.index!].steps
                              //               ?.length ??
                              //               0, (index) {
                              //         return StepWidget(
                              //             index: index,
                              //             indexStages: widget.index!,
                              //             phase: widget.phase,
                              //             cubitProcess: widget.cubitProcess,
                              //             step: state.stages![widget.index!]
                              //                 .steps![index]);
                              //       }),
                              //     );
                              //   },
                              // ),
                      //         Padding(
                      //           padding: const EdgeInsets.only(left: 180),
                      //           child: AppButton(
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Text('Thêm bước'),
                      //                 FittedBox(
                      //                     child: Icon(
                      //                       Icons.add,
                      //                       color: Color(0xFF373737),
                      //                     )),
                      //               ],
                      //             ),
                      //             color: Color(0xFFDDDAEA),
                      //             height: 37,
                      //             border: 10,
                      //             width: double.infinity,
                      //             onPressed: () {
                      //               showModalBottomSheet(
                      //                 isDismissible: false,
                      //                 context: context,
                      //                 isScrollControlled: true,
                      //                 backgroundColor: Colors.transparent,
                      //                 shape: RoundedRectangleBorder(
                      //                     borderRadius: BorderRadius.only(
                      //                         topLeft:
                      //                         const Radius.circular(20),
                      //                         topRight:
                      //                         const Radius.circular(20))),
                      //                 builder: (context) => ModalAddStepWidget(
                      //                   phase: widget.phase ?? "",
                      //                   onPressed:
                      //                       (name, startDate, endDate, stepId) {
                      //                     StepSeason step = StepSeason(
                      //                         name: name,
                      //                         from_day: int.parse(startDate),
                      //                         to_day: int.parse(endDate));
                      //
                      //                     widget.cubitProcess
                      //                         .createStep(widget.index!, step);
                      //                   },
                      //                 ),
                      //               );
                      //             },
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // )
                    // ],
                //   )
                // ]),
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
          ]),
     ]   ),
        // SizedBox(
        //   height: 10
        )
      ],
    );
  }

}
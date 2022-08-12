import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/main.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/models/entities/process/list_process.dart';
import 'package:flutter_base/models/entities/process/stage_entity.dart';
import 'package:flutter_base/models/entities/process/step_entity.dart';
import 'package:flutter_base/models/entities/season/process_season.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/entities/season/stage_season.dart';
import 'package:flutter_base/models/entities/season/step_season.dart';
import 'package:flutter_base/models/entities/task/work.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/router/application.dart';
import 'package:flutter_base/router/routers.dart';
import 'package:flutter_base/ui/pages/process_management/process_season/process_season_page.dart';
import 'package:flutter_base/ui/pages/seasons_management/seasons_detail/season_detail_cubit.dart';
import 'package:flutter_base/ui/pages/seasons_management/seasons_detail/widgets/detail_fee_tab.dart';
import 'package:flutter_base/ui/pages/seasons_management/seasons_detail/widgets/detail_fee_widget.dart';
import 'package:flutter_base/ui/pages/seasons_management/seasons_detail/widgets/modal_show_stage_season.dart';
import 'package:flutter_base/ui/pages/seasons_management/seasons_detail/widgets/modal_show_step_season.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_circular_progress_indicator.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_confirmed_dialog.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base/utils/date_utils.dart' as Util;
import 'package:intl/intl.dart';

final careProcessNavigationKey = GlobalKey<NavigatorState>();

class SeasonDetailPage extends StatefulWidget {
  SeasonEntity thisSeason;

  SeasonDetailPage({Key? key, required this.thisSeason}) : super(key: key);

  @override
  _SeasonDetailPageState createState() => _SeasonDetailPageState();
}

class _SeasonDetailPageState extends State<SeasonDetailPage> {
  late SeasonDetailCubit _cubit;
  DateFormat _dateFormat = DateFormat("dd-MM-yyyy");
  TextEditingController _turnoverController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _turnoverController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _cubit = BlocProvider.of<SeasonDetailCubit>(context);
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

  String currentDayInProcess(String startDay) {
    DateTime startDateTime =
        Util.DateUtils.fromStringFormatStrikeThrough(startDay)!;
    Duration different = DateTime.now().difference(startDateTime);
    different = different + Duration(days: 1);
    return "${different.inDays}";
  }

  // String currentStageInProcess(ProcessSeason process) {
  //   int currentStage = 0;
  //   if (process.stages != null) {
  //     stageLoop:
  //     for (int i = 0; i < process.stages!.length; i++) {
  //       StageSeason thisStage = process.stages![i];
  //       if (thisStage.steps != null) {
  //         stepLoop:
  //         for (int j = 0; j < thisStage.steps!.length; j++) {
  //           StepSeason thisStep = thisStage.steps![j];
  //           if (thisStep.actual_day != null) {
  //             currentStage = i;
  //             continue;
  //           } else {
  //             break stageLoop;
  //           }
  //         }
  //       }
  //     }
  //   }
  //   currentStage += 1;
  //   return process.stages?[currentStage - 1].name ?? '$currentStage';
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(
          context: context,
          // title: 'Mùa vụ',
          title: "${widget.thisSeason.name}",
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: BlocBuilder<SeasonDetailCubit, SeasonDetailState>(
              builder: (context, state) {
                if (state.loadStatus == LoadStatus.LOADING) {
                  return Center(
                    child: AppCircularProgressIndicator(),
                  );
                } else if (state.loadStatus == LoadStatus.FAILURE) {
                  return AppErrorListWidget(onRefresh: () async {
                    refreshData();
                  });
                } else if (state.loadStatus == LoadStatus.SUCCESS) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RefreshIndicator(
                        color: AppColors.main,
                        onRefresh: () async {
                          refreshData();
                        },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15),
                                Text(
                                  'Thông tin chi tiết:',
                                  style: AppTextStyle.blackS18Bold,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Loại cây trồng: ${state.season?.tree ?? ""}',
                                  style: AppTextStyle.greyS16,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Vườn: ${state.season?.gardenEntity?.name ?? ""}',
                                  style: AppTextStyle.greyS16,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Số lượng: ${state.season?.treeQuantity.toString() ?? ""}',
                                  style: AppTextStyle.greyS16,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Ngày bắt đầu: ${_dateFormat.format(DateTime.parse((state.season?.start_date).toString()))}',
                                  // ${state.season?.start_date
                                  // ?.substring(0, 10) ?? ""

                                  style: AppTextStyle.greyS16,
                                ),
                                if (state.season?.end_date != null) ...[
                                  SizedBox(height: 5),
                                  Text(
                                    'Ngày kết thúc: ${_dateFormat.format(DateTime.parse((state.season?.start_date).toString()))}',
                                    style: AppTextStyle.greyS16,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Doanh thu: ${state.season?.turnover?.toString() ?? "0"}',
                                    style: AppTextStyle.greyS16,
                                  ),
                                  Text(
                                    'Chi phí: ${((state.fee ?? 0) + (state.feeWorker ?? 0) + (state.feeMaterial ?? 0)).toString()}',
                                    style: AppTextStyle.greyS16,
                                  ),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: AppButton(
                                        color: Color(0xFF01A560),
                                        title: 'Chi tiết chi phí',
                                        height: 30,
                                        width: 110,
                                        onPressed: () async {
                                          showPopUpDetailFee(
                                              listWork: state.listWork,
                                              listMaterial: state.listMaterial,
                                              feeWorker: state.feeWorker,
                                              fee: state.fee,
                                              feeMaterial: state.feeMaterial);
                                        },
                                      )),
                                ],
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Quy trình chăm sóc',
                                        style: AppTextStyle.blackS18Bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    (state.season?.end_date == null &&
                                            GlobalData.instance.role !=
                                                'GARDEN_MANAGER')
                                        ? GestureDetector(
                                            onTap: () async {
                                              bool isUpdate = await Application
                                                  .router!
                                                  .navigateTo(
                                                appNavigatorKey.currentContext!,
                                                Routes.processSeasonUpdate,
                                                routeSettings: RouteSettings(
                                                  arguments:
                                                      state.season?.seasonId,
                                                ),
                                              );
                                              if (isUpdate) {
                                                refreshData();
                                              }
                                            },
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: Image.asset(
                                                AppImages.icSlideEdit,
                                                color: AppColors.blue5B,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: Navigator(
                      //     key: careProcessNavigationKey,
                      //     initialRoute: '/',
                      //     onGenerateRoute: (RouteSettings settings) {
                      //       late Widget page;
                      //       switch (settings.name) {
                      //         case "/":
                      //           page = CareProcessDetail(
                      //             seasonId: widget.thisSeason.seasonId!,
                      //           );
                      //
                      //           break;
                      //       }
                      //       return MaterialPageRoute<dynamic>(
                      //         builder: (context) {
                      //           return page;
                      //         },
                      //         settings: settings,
                      //       );
                      //     },
                      //   ),
                      // ),
                      buildProcess(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (state.season!.end_date == null &&
                                  (GlobalData.instance.role == 'GARDEN_MANAGER' ||
                                      GlobalData.instance.role ==
                                          'SUPER_ADMIN' ||
                                      GlobalData.instance.role == 'ADMIN'))
                              ? AppButton(
                                  color: Color(0xFF01A560),
                                  title: 'Kết thúc mùa vụ',
                                  height: 40,
                                  width: 200,
                                  onPressed: () async {
                                    // bool isConfirmed = await showDialog(
                                    //     context: context,
                                    //     builder: (context) =>
                                    //         AppConfirmedDialog(
                                    //           onConfirm: () async {
                                    //             final result =
                                    //                 await _cubit.endSeason(
                                    //                     state.season
                                    //                             ?.seasonId ??
                                    //                         "",
                                    //                     1000000000);
                                    //
                                    //             Navigator.pop(context, true);
                                    //             refreshData();
                                    //           },
                                    //         ));
                                    bool isAddSuccess = await showDialog(
                                        context: context,
                                        builder: (context) => _dialogCreate(
                                              title: Text(
                                                  "Thêm doanh thu để kết thúc mùa"),
                                              hintText: "Doanh thu",
                                              spanText: "Doanh thu",
                                              textEditingController:
                                                  _turnoverController,
                                            ));
                                    if (isAddSuccess) {
                                      await _cubit.calculateFee(
                                          widget.thisSeason.seasonId ?? "");
                                      await refreshData();
                                      showSnackBar(
                                          "Kết thúc mùa thành công", "success");
                                    } else {
                                      showSnackBar("Có lỗi xảy ra", "error");
                                    }
                                  },
                                )
                              : SizedBox(),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                } else
                  return SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(String message, String typeSnackBar) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: typeSnackBar,
      message: message,
    ));
  }

  Widget _dialogCreate({
    Text? title,
    String? hintText,
    String? spanText,
    TextEditingController? textEditingController,
  }) {
    return StatefulBuilder(builder: (context, state) {
      return AlertDialog(
        scrollable: true,
        title: title,
        content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
            ),
            // height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Container(
              //   alignment: Alignment.centerLeft,
              //   // margin: EdgeInsets.symmetric(horizontal: 28),
              //   child: RichText(
              //     text: TextSpan(children: [
              //       TextSpan(
              //         text: spanText,
              //         style: AppTextStyle.blackS14,
              //       ),
              //     ]),
              //   ),
              // ),
              // SizedBox(height: 15,),
              Container(
                  // margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Form(
                    key: _formKey,
                    child: AppTextField(
                      labelText: 'Doanh thu',
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      hintText: 'Doanh thu',
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (Validator.validateNullOrEmpty(value!))
                          return "Chưa nhập doanh thu";
                        // else
                        //   return null;
                      },
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Expanded(
                  child: AppButton(
                    color: AppColors.redButton,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    title: 'Hủy',
                    textStyle: AppTextStyle.whiteS16Bold,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(child: _buildConfirmCreateButton())
              ])
            ])),
      );
    });
  }

  Widget _buildConfirmCreateButton() {
    return BlocBuilder<SeasonDetailCubit, SeasonDetailState>(
      bloc: _cubit,
      buildWhen: (prev, current) {
        return (prev.loadStatus != current.loadStatus);
      },
      builder: (context, state) {
        return AppButton(
          color: AppColors.main,
          title: "Kết thúc",
          textStyle: AppTextStyle.whiteS16Bold,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await _cubit.endSeason(widget.thisSeason.seasonId!,
                  int.parse(_turnoverController.text));
              if (state.loadStatus == LoadStatus.FAILURE) {
                Navigator.pop(context, false);
              } else {
                Navigator.pop(context, true);
              }
            }
          },
        );
      },
    );
  }

  Widget buildProcess() {
    return BlocBuilder<SeasonDetailCubit, SeasonDetailState>(
      builder: (context, state) {
        if (state.loadStatus == LoadStatus.LOADING) {
          return Center(
              child: CircularProgressIndicator(
            color: AppColors.main,
          ));
        } else if (state.loadStatus == LoadStatus.FAILURE) {
          return Container();
        } else if (state.loadStatus == LoadStatus.SUCCESS) {
          return state.season?.process?.stages!.length != 0
              ? Column(
                  children: List.generate(
                      state.season?.process?.stages!.length ?? 0,
                      (index) => PhaseProcess(
                            index: index,
                            stageSeason: state.season?.process?.stages![index],
                            cubit: _cubit,
                            startDate: state
                                .season?.process?.stages![index].start
                                ?.substring(0, 10),
                            phase: state.season?.process?.stages![index].name ??
                                '${index + 1}',
                            // onRemove: () {
                            //   // _cubit!.removeList(index);
                            // },
                          )),
                )
              : Container();
        } else {
          return Container();
        }
      },
    );
  }

  void showPopUpDetailFee(
      {required List<MaterialUsedByTask>? listMaterial,
      required List<Work>? listWork,
      required int? feeMaterial,
      required int? fee,
      required int? feeWorker}) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return DetailFeeTabPage(
            listMaterial: listMaterial,
            listWork: listWork,
            feeMaterial: feeMaterial,
            fee: fee,
            feeWorker: feeWorker,
          );
        });
  }
}

class PhaseProcess extends StatefulWidget {
  int? index;
  String? phase;
  StageSeason? stageSeason;
  String? startDate;
  VoidCallback? onRemove;
  SeasonDetailCubit cubit;

  PhaseProcess(
      {Key? key,
      this.index,
      this.stageSeason,
      this.phase,
      this.startDate,
      this.onRemove,
      required this.cubit})
      : super(key: key);

  @override
  State<PhaseProcess> createState() => _PhaseProcessState();
}

class _PhaseProcessState extends State<PhaseProcess> {
  DateFormat _dateFormat = DateFormat("dd-MM-yyyy");

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isDismissible: false,
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20),
                                    topRight: const Radius.circular(20))),
                            builder: (context) => ModalShowStageSeasonWidget(
                                name: widget.phase,
                                description: widget.stageSeason!.description,
                                start: widget.startDate,
                                end: widget.stageSeason!.end,
                                onEnd: () {
                                  widget.cubit.endStage(widget.index!,
                                      widget.stageSeason!.stage_id!);
                                }));
                      },
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.colors[widget.index!],
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 6,
                              fit: FlexFit.tight,
                              child: Text(
                                'Giai đoạn: ${widget.phase}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              fit: FlexFit.tight,
                              child: Row(
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(
                                      color: Color(0xFFBBB5D4),
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  BlocBuilder<SeasonDetailCubit,
                                          SeasonDetailState>(
                                      buildWhen: (prev, current) =>
                                          prev.loadStatus != current.loadStatus,
                                      builder: (context, state) {
                                        return Text(
                                          _dateFormat.format(DateTime.parse(
                                              widget.startDate.toString())),
                                          // 'Chưa có thời gian bắt đầu',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      }),
                                  Expanded(
                                    child: BlocBuilder<SeasonDetailCubit,
                                            SeasonDetailState>(
                                        buildWhen: (prev, current) =>
                                            prev.loadStatus !=
                                            current.loadStatus,
                                        builder: (context, state) {
                                          return Text(
                                            (state
                                                        .season
                                                        ?.process
                                                        ?.stages![widget.index!]
                                                        .end !=
                                                    null)
                                                ? '-${_dateFormat.format(DateTime.parse(state.season!.process!.stages![widget.index!].end!))}'
                                                : '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                          );
                                        }),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                BlocBuilder<SeasonDetailCubit,
                                    SeasonDetailState>(
                                  buildWhen: (prev, current) =>
                                      prev.loadStatus != current.loadStatus,
                                  builder: (context, state) {
                                    return Column(
                                      children: List.generate(
                                          state
                                                  .season
                                                  ?.process
                                                  ?.stages![widget.index!]
                                                  .steps
                                                  ?.length ??
                                              0, (index) {
                                        return StepWidget(
                                            cubit: widget.cubit,
                                            index: index,
                                            indexStages: widget.index!,
                                            phase: widget.phase,
                                            // cubitProcess: widget.cubitProcess,
                                            step: state
                                                .season
                                                ?.process
                                                ?.stages![widget.index!]
                                                .steps![index]);
                                      }),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ]),
              // GestureDetector(
              //   onTap: widget.onRemove,
              //   child: Align(
              //     alignment: Alignment.topRight,
              //     child: Container(
              //       height: 30,
              //       padding: EdgeInsets.only(top: 7, right: 5),
              //       child: FittedBox(
              //         child: Icon(
              //           Icons.close,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ]),
          ),
          // SizedBox(
          //   height: 10,
          // )
        ],
      ),
    );
  }
}

class StepWidget extends StatefulWidget {
  final int? index;
  final StepSeason? step;
  final String? phase;
  final int? indexStages;
  final SeasonDetailCubit cubit;

  const StepWidget({
    Key? key,
    required this.index,
    this.indexStages,
    this.step,
    this.phase,
    required this.cubit,
  }) : super(key: key);

  @override
  State<StepWidget> createState() => _StepWidgetState();
}

class _StepWidgetState extends State<StepWidget> {
  DateFormat _dateFormat = DateFormat("dd-MM-yyyy");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          isDismissible: false,
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20))),
          builder: (context) => ModalShowStepSeasonWidget(
            name: widget.step!.name,
            description: widget.step!.description,
            start: widget.step!.start,
            end: widget.step!.end,
            from_day: widget.step!.from_day,
            to_day: widget.step!.to_day,
            onEnd: () {
              widget.cubit.endStep(widget.index!, widget.indexStages!);
            },
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Color(0xFFDDDAEA),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.step!.name ?? '',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Text('Từ'),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      '${widget.step?.from_day}',
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text('-'),
                    SizedBox(
                      width: 2,
                    ),
                    Text('${widget.step?.to_day}'),
                    SizedBox(
                      width: 3,
                    ),
                    Text('ngày'),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  (widget.step?.start != null)
                      ? 'Thời gian bắt đầu ${_dateFormat.format(DateTime.parse(widget.step!.start.toString()))}'
                      : 'Chưa có thời gian bắt đầu',
                  style: TextStyle(
                    color: Color(0xFF9E7F2F),
                  ),
                )
              ],
            ),
            if ((widget.step?.end != null))
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Thời gian kết thúc ${_dateFormat.format(DateTime.parse(widget.step!.end.toString()))}',
                    style: TextStyle(
                      color: Color(0xFF9E7F2F),
                    ),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}

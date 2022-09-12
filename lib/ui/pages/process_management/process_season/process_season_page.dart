import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/configs/app_config.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/models/entities/season/stage_season.dart';
import 'package:flutter_base/models/entities/season/step_season.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/process_management/process_season/process_season_cubit.dart';
import 'package:flutter_base/ui/pages/process_management/widget/modal_add_stage_season_widget.dart';
import 'package:flutter_base/ui/pages/process_management/widget/modal_add_step_season_widget.dart';
import 'package:flutter_base/ui/pages/process_management/widget/modal_edit_phase_season_widget.dart';
import 'package:flutter_base/ui/pages/process_management/widget/modal_edit_step_season_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/multiple_tree_picker/app_tree_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UpdateProcessSeasonPage extends StatefulWidget {
  final String? seasonId;

  UpdateProcessSeasonPage({Key? key, this.seasonId}) : super(key: key);

  @override
  _UpdateProcessSeasonPageState createState() =>
      _UpdateProcessSeasonPageState();
}

class _UpdateProcessSeasonPageState extends State<UpdateProcessSeasonPage> {
  final _formKey = GlobalKey<FormState>();
  List<PhaseProcess> listPhase = [];
  TreePickerController treeController = TreePickerController();
  TextEditingController nameController = TextEditingController(text: '');

  ProcessSeasonCubit? _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<ProcessSeasonCubit>(context);

    // Set initial cubit
    _cubit!.changeName(nameController.text);
    nameController.addListener(() {
      _cubit!.changeName(nameController.text);
    });

    _cubit!.getProcessDetail(widget.seasonId!);
  }

  @override
  void dispose() {
    _cubit!.close();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(
        onBackPressed: () {
          Navigator.of(context).pop(true);
        },
        context: context,
        title: 'Sửa quy trình',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Cây trồng áp dụng',
                          style: AppTextStyle.greyS14,
                        ),
                        SizedBox(height: 10),
                        BlocBuilder<ProcessSeasonCubit, ProcessSeasonState>(
                            builder: (context, state) {
                          return AppTextField(
                            enable: false,
                            hintText: state.trees?.name ?? "",
                          );
                        }),
                        SizedBox(height: 20),
                        Text(
                          'Các giai đoạn chăm sóc',
                          style: AppTextStyle.greyS14,
                        ),
                        SizedBox(height: 10),
                        // if (GlobalData.instance.role == "ADMIN" ||
                        //     GlobalData.instance.role == "SUPER_ADMIN")
                          BlocBuilder<ProcessSeasonCubit, ProcessSeasonState>(
                            // buildWhen: (prev, current) {
                            //   return prev.updateProcessSeasonStatus !=
                            //       current.updateProcessSeasonStatus;
                            // },
                            builder: (context, state) {
                              return Visibility(
                                visible: state.stages!.length >=
                                        AppConfig.stagesLength
                                    ? false
                                    : true,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 140),
                                  child: AppButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Thêm giai đoạn'),
                                        FittedBox(
                                            child: Icon(
                                          Icons.add,
                                          color: Color(0xFF373737),
                                        )),
                                      ],
                                    ),
                                    color: Color(0xFF8FE192),
                                    height: 30,
                                    width: double.infinity,
                                    onPressed: () async{
                                      bool isBool = await changeNameDesStage();
                                      print(isBool);
                                      if(isBool){
                                        await _cubit!.getProcessDetail(widget.seasonId!);
                                      }

                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        SizedBox(height: 20),
                        BlocBuilder<ProcessSeasonCubit, ProcessSeasonState>(
                          // buildWhen:  (prev, current) {
                          //   return prev.updateProcessSeasonStatus !=
                          //       current.updateProcessSeasonStatus;
                          // },
                          builder: (context, state) {
                            if (state.loadDetailStatus == LoadStatus.LOADING) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: AppColors.main,
                              ));
                            } else if (state.loadDetailStatus ==
                                LoadStatus.FAILURE) {
                              return Container();
                            } else if (state.loadDetailStatus ==
                                LoadStatus.SUCCESS) {
                              return state.stages!.length != 0
                                  ? Column(
                                      children: List.generate(
                                          state.stages!.length,
                                          (index) => PhaseProcess(
                                                stage: state.stages![index],
                                                index: index,
                                                cubitProcess: _cubit!,
                                                startDate:
                                                    state.stages![index].start,
                                                phase:
                                                    state.stages![index].name ??
                                                        '${index + 1}',
                                                onRemove: () async{
                                                  await _cubit!.removeList(
                                                      index,
                                                      state.stages![index]
                                                          .stage_id);
                                                }, seasonId: widget.seasonId!,
                                            endDate: state.stages![index].end,
                                              )),
                                    )
                                  : Container();
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                buildActionCreate(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  changeNameDesStage() async{
    bool isAddSuccess = await showModalBottomSheet(
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
              child: ModalAddStageSeasonWidget(
                onDelete: () {},
                onPressed: (String name, String description, String start) async {
                  await _cubit!.addList(
                      StageSeason(
                          name: name, description: description, start: start),
                      widget.seasonId);
                },
              ),
            ));
    return isAddSuccess;
  }

  Widget buildActionCreate(BuildContext context) {
    return BlocConsumer<ProcessSeasonCubit, ProcessSeasonState>(
      bloc: _cubit,
      listenWhen: (prev, current) {
        return prev.updateProcessSeasonStatus !=
            current.updateProcessSeasonStatus;
      },
      listener: (context, state) {
        if (state.updateProcessSeasonStatus == LoadStatus.SUCCESS) {
          _showCreateSuccess();
        }
        if (state.updateProcessSeasonStatus == LoadStatus.FAILURE) {
          showSnackBar('Có lỗi xảy ra!');
        }
      },
      builder: (context, state) {
        final isLoading =
            (state.loadDetailStatus == LoadStatus.LOADING);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AppButton(
                width: 100,
                color: AppColors.main,
                title: 'Hoàn tất chỉnh sửa',
                onPressed: () {
                  // _cubit?.updateProcess();
                  Navigator.of(context).pop(true);
                },
                isLoading: isLoading,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCreateSuccess() async {
    showSnackBar('Cập nhật thành công!');
    Navigator.of(context).pop(true);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      message: message,
      typeSnackBar: '',
    ));
  }
}

class PhaseProcess extends StatefulWidget {
  String seasonId;
  int? index;
  String? phase;
  StageSeason? stage;
  String? startDate;
  String? endDate;
  VoidCallback? onRemove;
  ProcessSeasonCubit cubitProcess;

  PhaseProcess(
      {Key? key,
        required this.seasonId,
      this.index,
      this.phase,
      this.stage,
      this.startDate,
      this.onRemove,
      this.endDate,
      required this.cubitProcess})
      : super(key: key);

  @override
  State<PhaseProcess> createState() => _PhaseProcessState();
}

class _PhaseProcessState extends State<PhaseProcess> {
  DateFormat _dateFormat = DateFormat("dd-MM-yyyy");
  @override
  Widget build(BuildContext context) {
    int sumStart = 0;
    int sumEnd = 0;
    if (widget.cubitProcess.state.stages![widget.index!].steps != null) {
      for (int i = 0;
          i < widget.cubitProcess.state.stages![widget.index!].steps!.length;
          i++) {
        var a = widget.cubitProcess.state.stages![widget.index!].steps;
        sumStart += a![i].from_day!;
        sumEnd += a[i].to_day!;
      }
    }

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
                  GestureDetector(
                    onTap: () {
                      if (widget.endDate == null) {
                        showModalBottomSheet(
                            isDismissible: false,
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return ModalEditStageSeasonWidget(
                                name: widget.phase,
                                onEnd: () {
                                  widget.cubitProcess.endStage(
                                      widget.index!, widget.stage?.stage_id);
                                },
                                end: widget.stage?.end,
                                start: widget.startDate,
                                onPressed: (String name, String description,
                                    String start) {
                                  widget.cubitProcess.editStage(
                                      widget.index!,
                                      widget.stage?.stage_id,
                                      name,
                                      description,
                                      start);
                                },
                                description: widget.stage?.description,
                              );
                            });
                      }
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      // padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.colors[widget.index!],
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 5,
                              child: Text(
                                    'Giai đoạn:  ${widget.phase}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                              ),
                            fit: FlexFit.tight,
                          ),
                         Flexible(
                           flex: 5,
                           // fit: FlexFit.tight,
                           child:Row(
                             children: [
                               Text(
                                 'Thời gian: ',
                                 style: TextStyle(
                                   color: Color(0xFFBBB5D4),
                                   fontSize: 14,
                                 ),
                               ),
                               BlocBuilder<ProcessSeasonCubit, ProcessSeasonState>(
                                   buildWhen: (prev, current) =>
                                   prev.actionWithStepStatus !=
                                       current.actionWithStepStatus,
                                   builder: (context, state) {
                                     if (widget.startDate != null) {
                                       return Text(
                                         _dateFormat.format(DateTime.parse(widget.startDate.toString())),
                                         // widget.startDate!.substring(0, 10),
                                         style: TextStyle(
                                           color: Colors.white,
                                           fontSize: 14,
                                         ),
                                       );
                                     }
                                     return Text("");
                                   }),
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
                              BlocBuilder<ProcessSeasonCubit,
                                  ProcessSeasonState>(
                                buildWhen: (prev, current) =>
                                    prev.actionWithStepStatus !=
                                    current.actionWithStepStatus,
                                builder: (context, state) {
                                  return Column(
                                    children: List.generate(
                                        state.stages![widget.index!].steps
                                                ?.length ??
                                            0, (index) {
                                      return StepWidget(
                                          index: index,
                                          indexStages: widget.index!,
                                          phase: widget.phase,
                                          cubitProcess: widget.cubitProcess,
                                          step: state.stages![widget.index!]
                                              .steps![index]);
                                    }),
                                  );
                                },
                              ),
                              if (widget.endDate == null &&(GlobalData.instance.role == "ADMIN" ||
                                  GlobalData.instance.role == "SUPER_ADMIN"))
                                Padding(
                                  padding: const EdgeInsets.only(left: 180),
                                  child: AppButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Thêm bước'),
                                        FittedBox(
                                            child: Icon(
                                          Icons.add,
                                          color: Color(0xFF373737),
                                        )),
                                      ],
                                    ),
                                    color: Color(0xFFDDDAEA),
                                    height: 37,
                                    border: 10,
                                    width: double.infinity,
                                    onPressed: () async{
                                      bool isAddStep = await showModalBottomSheet(
                                        isDismissible: false,
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(20),
                                                topRight:
                                                    const Radius.circular(20))),
                                        builder: (context) =>
                                            ModalAddStepSeasonWidget(
                                          phase: widget.phase ?? "",
                                          onPressed: (name, fromDay, toDay,
                                              startTime, description) async {
                                            StepSeason step = StepSeason(
                                                name: name,
                                                description: description,
                                                start: startTime,
                                                from_day:
                                                    int.tryParse(fromDay),
                                                to_day: int.tryParse(toDay));

                                            await widget.cubitProcess.createStep(
                                                widget.index!, step);
                                          },
                                        ),
                                      );
                                      if(isAddStep){
                                        await widget.cubitProcess.getProcessDetail(widget.seasonId);
                                      }
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ]),
            GestureDetector(
              onTap:
                 widget.onRemove,
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
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class StepWidget extends StatefulWidget {
  final int? index;
  final StepSeason? step;
  final String? phase;
  final int? indexStages;
  final ProcessSeasonCubit cubitProcess;

  const StepWidget({
    Key? key,
    required this.index,
    this.indexStages,
    this.step,
    this.phase,
    required this.cubitProcess,
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
          builder: (context) => ModalEditStepSeasonWidget(
            onEnd: () {
              widget.cubitProcess.endStep(widget.index!, widget.indexStages!);
            },
            name: widget.step!.name,
            description: widget.step!.description,
            from_day: widget.step!.from_day,
            to_day: widget.step!.to_day,
            end: widget.step!.end,
            start: widget.step!.start!,
            onPressed: (name, description, startTime, fromDay, toDay) async{
              StepSeason step = StepSeason(
                  step_id: widget.step!.step_id,
                  name: name,
                  from_day: int.parse(fromDay),
                  to_day: int.parse(toDay),
                  start: startTime,
                  description: description);
              //
              await widget.cubitProcess
                  .editSteps(widget.index!, widget.indexStages!, step);
            },
            onDelete: () async{
              await widget.cubitProcess
                  .removeStep(widget.index!, widget.indexStages!);
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
                      '${widget.step!.from_day}',
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text('-'),
                    SizedBox(
                      width: 2,
                    ),
                    Text('${widget.step!.to_day}'),
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
                  (widget.step!.start) != null
                      ? 'Thời gian bắt đầu ${ _dateFormat.format(DateTime.parse( widget.step!.start.toString()))}'
                      : 'Chưa có thời gian bắt đầu',
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
  Future<void> deleteStep() async{
    await widget.cubitProcess
        .removeStep(widget.index!, widget.indexStages!);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/configs/app_config.dart';
import 'package:flutter_base/models/entities/process/stage_entity.dart';
import 'package:flutter_base/models/entities/process/step_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/process_management/add_process/add_process_cubit.dart';
import 'package:flutter_base/ui/pages/process_management/widget/modal_add_stage_widget.dart';
import 'package:flutter_base/ui/pages/process_management/widget/modal_add_step_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/multiple_tree_picker/app_tree_picker.dart';

import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProcessAddingPage extends StatefulWidget {
  const ProcessAddingPage({Key? key}) : super(key: key);

  @override
  _ProcessAddingPageState createState() => _ProcessAddingPageState();
}

class _ProcessAddingPageState extends State<ProcessAddingPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  List<PhaseProcess> listPhase = [];

  late AddProcessCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<AddProcessCubit>(context);

    //Set initial cubit
    _cubit.changeName(nameController.text);
    nameController.addListener(() {
      _cubit.changeName(nameController.text);
    });
  }

  @override
  void dispose() {
    _cubit.close();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(
        context: context,
        title: 'Th??m quy tr??nh m???i',
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
                        'T??n quy tr??nh',
                        style: AppTextStyle.greyS14,
                      ),
                      SizedBox(height: 10),
                      AppTextField(
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        hintText: 'Nh???p v??o t??n quy tr??nh',
                        controller: nameController,
                        onChanged: (value){
                          _cubit.changeName(value);
                        },
                        validator: (value) {
                          if (Validator.validateNullOrEmpty(value!))
                            return "Ch??a nh???p t??n quy tr??nh";
                          else
                            return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'C??c lo???i c??y tr???ng ??p d???ng',
                        style: AppTextStyle.greyS14,
                      ),
                      SizedBox(height: 10),
                      AppPageTreePicker(
                        controller: TreePickerController(),
                        onChanged: (value) {
                          _cubit.changeTree(value);
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'C??c giai ??o???n ch??m s??c',
                        style: AppTextStyle.greyS14,
                      ),
                      SizedBox(height: 10),
                      BlocBuilder<AddProcessCubit, AddProcessState>(
                        builder: (context, state) {
                          return Visibility(
                            visible:
                                state.stages!.length >= AppConfig.stagesLength
                                    ? false
                                    : true,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 140),
                              child: AppButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Th??m giai ??o???n'),
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
                                onPressed: () {
                                  changeNameDesStage();
                                  // _cubit.addList(StageEntity());
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      BlocBuilder<AddProcessCubit, AddProcessState>(
                        builder: (context, state) {
                          return Column(
                            children: List.generate(
                                state.stages!.length,
                                (index) => PhaseProcess(
                                      index: index,
                                      cubitProcess: _cubit,
                                      phase: state.stages![index].name ?? '${index + 1}',
                                      onRemove: () {
                                        _cubit.removeList(index);
                                      },
                                    )),
                          );
                        },
                      ),
                    ],
                  ),
                )),
                SizedBox(
                  height: 20,
                ),
                buildActionCreate(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
  changeNameDesStage(){
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
          child: ModalAddStageWidget( onDelete: (){}, onPressed: (String name, String description) { _cubit.addList(StageEntity(name: name, description: description)); },),
        )
    );
  }
  Widget buildActionCreate(BuildContext context) {
    return BlocConsumer<AddProcessCubit, AddProcessState>(
      bloc: _cubit,
      listenWhen: (prev, current) {
        return prev.addProcessStatus != current.addProcessStatus;
      },
      listener: (context, state) {
        if (state.addProcessStatus == LoadStatus.SUCCESS) {
          _showCreateSuccess();
        }
        if (state.addProcessStatus == LoadStatus.FAILURE) {
          showSnackBar('C?? l???i x???y ra!');
        }
      },
      builder: (context, state) {
        final isLoading = (state.addProcessStatus == LoadStatus.LOADING);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AppButton(
                color: AppColors.redButton,
                title: 'H???y b???',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(width: 40),
            Expanded(
              child: AppButton(
                width: 100,
                color: AppColors.main,
                title: 'X??c nh???n',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _cubit.createProcess();
                    print("tao thanh cong");
                  }
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
    showSnackBar('T???o m???i th??nh c??ng!');
    Navigator.of(context).pop(true);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      message: message, typeSnackBar: '',
    ));
  }
}

class PhaseProcess extends StatefulWidget {
  int? index;
  String? phase;
  VoidCallback? onRemove;
  AddProcessCubit cubitProcess;

  PhaseProcess(
      {Key? key,
      this.index,
      this.phase,
      this.onRemove,
      required this.cubitProcess})
      : super(key: key);

  @override
  State<PhaseProcess> createState() => _PhaseProcessState();
}

class _PhaseProcessState extends State<PhaseProcess> {
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
                  Container(
                    height: 40,
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.colors[widget.index!],
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: GestureDetector(
                      onTap: (){
                        showModalBottomSheet(
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
                          builder: (context) => ModalAddStageWidget(
                            name: widget.cubitProcess.state.stages![widget.index!].name ?? '',
                            onPressed:
                                (name, description ) {
                                  // widget.cubitProcess.state.stages![widget.index!].name = name;
                                  // widget.cubitProcess.state.stages![widget.index!].description = description;
                                  widget.cubitProcess.editStage(widget.index!, name, description);
                                  },
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                              child: Text(
                                'Giai ??o???n ${widget.phase}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),),
                          Flexible(
                            fit: FlexFit.tight,
                              child:  Text(
                                'Th???i gian:$sumStart - $sumEnd ng??y ',
                                style: TextStyle(
                                  color: Color(0xFFBBB5D4),
                                  fontSize: 14,
                                ),
                              ),),
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
                              BlocBuilder<AddProcessCubit, AddProcessState>(
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
                              Padding(
                                padding: const EdgeInsets.only(left: 180),
                                child: AppButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Th??m b?????c'),
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
                                  onPressed: () {
                                    showModalBottomSheet(
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
                                      builder: (context) => ModalAddStepWidget(
                                        phase: widget.phase ?? "",
                                        onPressed:
                                            (name, startDate, endDate, stepId) {
                                          StepEntity step = StepEntity(
                                              name: name,
                                              from_day: int.parse(startDate),
                                              to_day: int.parse(endDate));

                                          widget.cubitProcess
                                              .createStep(widget.index!, step);
                                        },
                                      ),
                                    );
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
  final StepEntity? step;
  final String? phase;
  final int? indexStages;
  final AddProcessCubit cubitProcess;

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
          builder: (context) => ModalAddStepWidget(
            phase: widget.phase ?? "",
            name: widget.step!.name,
            startDate: widget.step!.from_day!.toString(),
            endDate: widget.step!.to_day!.toString(),
            onPressed: (name, startDate, endDate, stepId) {
              StepEntity step = StepEntity(
                  name: name,
                  from_day: int.parse(startDate),
                  to_day: int.parse(endDate));

              widget.cubitProcess
                  .editSteps(widget.index!, widget.indexStages!, step);
            },
            onDelete: () {
              widget.cubitProcess
                  .removeStep(widget.index!, widget.indexStages!);
            },
          ),
        );
      },
      child: Container(
        height: 40,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Color(0xFFDDDAEA),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
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
                Text('T???'),
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
                Text('ng??y'),
              ],
            )
          ],
        ),
      ),
    );
  }
}

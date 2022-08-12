import 'package:bloc/bloc.dart';
import 'package:flutter_base/models/entities/season/process_season.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/entities/season/stage_season.dart';
import 'package:flutter_base/models/entities/season/step_season.dart';
import 'package:flutter_base/models/entities/tree/list_tree_response.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/season_repository.dart';
import 'package:flutter_base/ui/widgets/app_snackbar.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'process_season_state.dart';

class ProcessSeasonCubit extends Cubit<ProcessSeasonState> {
  SeasonRepository? seasonRepository;

  ProcessSeasonCubit({
    this.seasonRepository,
  }) : super(ProcessSeasonState(stages: [], actionWithStepStatus: 0));

  final showMessageController = PublishSubject<SnackBarMessage>();

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }

  Future<void> addList(StageSeason value, String? seasonId) async{
    emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.LOADING));
    try {
      var result = await seasonRepository?.addPhase(value, seasonId!);
      if (result == null) {
        emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
      } else {
        emit(
            state.copyWith(updateProcessSeasonStatus: LoadStatus.LOADING_MORE));
        // List<StageSeason> stages = state.stages!;
        // stages.add(result.process?.stages?.firstWhere((element) => element.name == value.name) ?? value) ;
        // List<StageSeason> newList = stages;
        emit(state.copyWith(
            stages: result.process?.stages,
            updateProcessSeasonStatus: LoadStatus.FORMAT_EXTENSION_FILE));
      }
      // emit(state.copyWith(loadDetailStatus: LoadStatus.SUCCESS));
    } catch (e) {
      emit(state.copyWith(loadDetailStatus: LoadStatus.FAILURE));
    }
  }

  Future<void> endStage(int index, String? phaseId) async{
    try {
      var result = await seasonRepository?.endPhase(phaseId!);
      if (result != null) {
        // List<StageSeason> stages = state.stages!;
        // stages[index].end = DateTime.now().toString();
        // List<StageSeason> newList = stages;
        emit(state.copyWith(
            stages: result.process?.stages,
            actionWithStepStatus: state.actionWithStepStatus++));
      }
    } catch (e) {
      emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
    }
    emit(state.copyWith(actionWithStepStatus: state.actionWithStepStatus++));
  }

  Future<void> removeList(int index, String? phaseId) async{
    // try {
      var result = await seasonRepository?.deletePhase(phaseId!).then((value) {
        if (value != null) {
          emit(
              state.copyWith(updateProcessSeasonStatus: LoadStatus.LOADING_MORE));
          // List<StageSeason> stages = state.stages!;
          // stages.removeAt(index);
          // List<StageSeason> newList = stages;
          emit(state.copyWith(
              stages:value.process?.stages,
              updateProcessSeasonStatus: LoadStatus.FORMAT_EXTENSION_FILE));
        } else {
          emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
        }
      });
      // if(result == null){
      //   emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
      // }
      // emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.SUCCESS));
    // } catch (e) {
    //   emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
    // }

    // emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.LOADING));
  }

  void changeName(String name) {
    emit(state.copyWith(name: name));
  }

  void changeTree(TreeEntity? value) {
    emit(state.copyWith(trees: value));
  }

  Future<void> editSteps(int index, int indexStages, StepSeason value) async{
    List<StageSeason> stages = state.stages!;
    emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.LOADING));
    var result = await seasonRepository!.putStep(value.step_id!, stages[indexStages].stage_id!, value);
    // stages[indexStages].steps![index] = value;
    // List<StageSeason> newList = stages;
    emit(state.copyWith(
        stages: result.process?.stages, actionWithStepStatus: state.actionWithStepStatus++));
    emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.SUCCESS, actionWithStepStatus: state.actionWithStepStatus++));
  }

  Future<void> createStep(int index, StepSeason value) async{
    print("Create step");
    List<StageSeason> stages = state.stages!;
    // try {
      var result =await seasonRepository?.addStep(stages[index].stage_id!, value);
      if(result != null){
        emit(state.copyWith(stages: result.process?.stages, updateProcessSeasonStatus: LoadStatus.SUCCESS, /*actionWithStepStatus: state.actionWithStepStatus++*/));
      } else{
        print("error");
        emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE, /*actionWithStepStatus: state.actionWithStepStatus++*/));
      }
      // if (stages[index].steps == null) {
      //   stages[index].steps = [];
      // }
      // stages[index].steps!.add(result!.process!.stages![index].steps!.firstWhere((element) => element.name == value.name));
      // List<StageSeason> newList = stages;
      // emit(state.copyWith(
      //     stages: newList, actionWithStepStatus: state.actionWithStepStatus++));
    // } catch (e) {
    //   emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE, /*actionWithStepStatus: state.actionWithStepStatus++*/));
    // }

  }

  void endStep(int index, int indexStage) async{
    List<StageSeason> stages = state.stages!;
    try {
      var result = await seasonRepository?.endStep(
          stages[indexStage].stage_id!,stages[indexStage].steps![index].step_id!);
      // final stage = stages[indexStage];
      // stage.steps?[index].end = DateTime.now().toString().substring(0, 10);
      // List<StageSeason> newList = stages;
      emit(state.copyWith(
          stages: result?.process?.stages, actionWithStepStatus: state.actionWithStepStatus++));
    } catch (e) {
      emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE, actionWithStepStatus: state.actionWithStepStatus++));
    }
  }

  Future<void> removeStep(int index, int indexStages) async{
    print("remove");
    List<StageSeason> stages = state.stages!;
    emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.LOADING));
    try {
      var result = await seasonRepository!.deleteStep(stages[indexStages].steps![index].step_id!,
          stages[indexStages].stage_id!);
      // stages[indexStages].steps?.removeAt(index);
      // List<StageSeason> newList = stages;
      emit(state.copyWith(
          stages: result.process?.stages, actionWithStepStatus: state.actionWithStepStatus++));
      emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.SUCCESS, actionWithStepStatus: state.actionWithStepStatus++));
    } catch (e) {
      emit(state.copyWith(loadDetailStatus: LoadStatus.FAILURE, actionWithStepStatus: state.actionWithStepStatus++));
    }
  }

  Future<void> editStage(int index, String? phaseId, String? name, String? description,
      String? start) async{
    emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.LOADING));
    try {
      var result =await seasonRepository?.putPhase(
          StageSeason(name: name, description: description, start: start),
          phaseId!);
      if (result == null) {
        emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
      } else {
        // List<StageSeason> stages = state.stages!;
        // stages[index].name = name;
        // stages[index].description = description;
        // stages[index].start = start;
        // List<StageSeason> newList = stages;
        emit(state.copyWith(
            stages: result.process?.stages,
            actionWithStepStatus: state.actionWithStepStatus++));
        emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.SUCCESS));
      }
    } catch (e) {
      emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
    }
  }

  void updateProcess() async {
    // emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.SUCCESS));
    // emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.LOADING));
    // try {
    //   List<StageSeason> listStages = [];
    //   if (state.stages != null) {
    //     for (int i = 0; i < state.stages!.length; i++) {
    //       List<StepSeason> steps = [];
    //       state.stages![i].steps!.forEach((ele) {
    //         steps.add(ele);
    //       });
    // listStages.add(StagesParamsEntity(
    //     name: 'Giai đoạn ${i + 1}',
    //     stage_id: state.stages![i].stage_id,
    //     steps: steps));
    //   }
    // }

    // final param = ProcessEntity(
    //   name: state.name,
    //   trees: state.trees,
    //   stages: state.stages,
    // );

    // final response = await processRepository!
    //     .updateProcess(processId: processId, param: param);

    // if (response != null) {
    //   emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.SUCCESS));
    // } else {
    //   emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
    // }
    // } catch (e) {
    //   emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
    //   return;
    // }
  }

  Future<void> getProcessDetail(String seasonId) async {
    emit(state.copyWith(loadDetailStatus: LoadStatus.LOADING));
    try {
      // final ProcessSeason result =
      //     await processRepository!.getProcessById(seasonId);
      final SeasonEntity response =
          await seasonRepository!.getSeasonById(seasonId);
      final ProcessSeason? result = response.process;
      emit(state.copyWith(
          loadDetailStatus: LoadStatus.SUCCESS,
          name: result?.name,
          trees: TreeEntity(name: response.tree),
          stages: result?.stages));
    } catch (e) {
      emit(state.copyWith(loadDetailStatus: LoadStatus.FAILURE));
    }
  }
}

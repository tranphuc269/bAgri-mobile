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

  void addList(StageSeason value, String? seasonId) async{
    // emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.LOADING));
    try {
      var result =await seasonRepository?.addPhase(value, seasonId!);
      print(result?.process?.stages?.firstWhere((element) => element.name == value.name).name?? "");
      if (result == null) {
        emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
      } else {
        emit(
            state.copyWith(updateProcessSeasonStatus: LoadStatus.LOADING_MORE));
        List<StageSeason> stages = state.stages!;
        stages.add(result.process?.stages?.firstWhere((element) => element.name == value.name) ?? value) ;
        List<StageSeason> newList = stages;
        emit(state.copyWith(
            stages: newList,
            updateProcessSeasonStatus: LoadStatus.FORMAT_EXTENSION_FILE));
      }
      // emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.SUCCESS));
    } catch (e) {
      emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
    }
  }

  void endStage(int index, String? phaseId) {
    try {
      var result = seasonRepository?.endPhase(phaseId!);
      if (result != null) {
        List<StageSeason> stages = state.stages!;
        stages[index].end = DateTime.now().toString();
        List<StageSeason> newList = stages;
        emit(state.copyWith(
            stages: newList,
            actionWithStepStatus: state.actionWithStepStatus++));
      }
    } catch (e) {
      emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
    }
    emit(state.copyWith(actionWithStepStatus: state.actionWithStepStatus++));
  }

  void removeList(int index, String? phaseId) {
    try {
      var result = seasonRepository?.deletePhase(phaseId!);
      if (result != null) {
        emit(
            state.copyWith(updateProcessSeasonStatus: LoadStatus.LOADING_MORE));
        List<StageSeason> stages = state.stages!;
        stages.removeAt(index);
        List<StageSeason> newList = stages;
        emit(state.copyWith(
            stages: newList,
            updateProcessSeasonStatus: LoadStatus.FORMAT_EXTENSION_FILE));
      } else {
        emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
      }
      // emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.SUCCESS));
    } catch (e) {
      emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
    }

    // emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.LOADING));
  }

  void changeName(String name) {
    emit(state.copyWith(name: name));
  }

  void changeTree(TreeEntity? value) {
    emit(state.copyWith(trees: value));
  }

  void editSteps(int index, int indexStages, StepSeason value) {
    List<StageSeason> stages = state.stages!;
    seasonRepository?.putStep(value.step_id!, stages[indexStages].stage_id!, value);
    stages[indexStages].steps![index] = value;
    List<StageSeason> newList = stages;
    emit(state.copyWith(
        stages: newList, actionWithStepStatus: state.actionWithStepStatus++));
  }

  void createStep(int index, StepSeason value) async{
    List<StageSeason> stages = state.stages!;
    try {
      var result =await seasonRepository?.addStep(stages[index].stage_id!, value);
      if (stages[index].steps == null) {
        stages[index].steps = [];
      }
      stages[index].steps!.add(result!.process!.stages![index].steps!.firstWhere((element) => element.name == value.name));
      List<StageSeason> newList = stages;
      emit(state.copyWith(
          stages: newList, actionWithStepStatus: state.actionWithStepStatus++));
    } catch (e) {
      emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
    }

  }

  void endStep(int index, int indexStage) async{
    List<StageSeason> stages = state.stages!;
    try {
      var result = await seasonRepository?.endStep(
          stages[indexStage].steps![index].step_id!,
          stages[indexStage].stage_id!);


      final stage = stages[indexStage];
      stage.steps?[index].end = DateTime.now().toString().substring(0, 10);
      List<StageSeason> newList = stages;
      emit(state.copyWith(
          stages: newList, actionWithStepStatus: state.actionWithStepStatus++));
    } catch (e) {
      emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
    }
  }

  void removeStep(int index, int indexStages) {
    print("remove");
    List<StageSeason> stages = state.stages!;
    try {
      seasonRepository!.deleteStep(stages[indexStages].steps![index].step_id!,
          stages[indexStages].stage_id!);
      stages[indexStages].steps?.removeAt(index);
      List<StageSeason> newList = stages;
      emit(state.copyWith(
          stages: newList, actionWithStepStatus: state.actionWithStepStatus++));
    } catch (e) {
      emit(state.copyWith(loadDetailStatus: LoadStatus.FAILURE));
    }
  }

  void editStage(int index, String? phaseId, String? name, String? description,
      String? start) {
    try {
      var result = seasonRepository?.putPhase(
          StageSeason(name: name, description: description, start: start),
          phaseId!);
      if (result == null) {
        emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
      } else {
        List<StageSeason> stages = state.stages!;
        stages[index].name = name;
        stages[index].description = description;
        stages[index].start = start;
        List<StageSeason> newList = stages;
        emit(state.copyWith(
            stages: newList,
            actionWithStepStatus: state.actionWithStepStatus++));
      }
    } catch (e) {
      emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.FAILURE));
    }
  }

  void updateProcess() async {
    emit(state.copyWith(updateProcessSeasonStatus: LoadStatus.SUCCESS));
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
          // name: result./*data?.*/process?.name!,
          name: result?.name,
          trees: response.tree,
          stages: result?.stages));
      // trees: result.data?.process?.trees!,
      // stages: result./*data?.process?.*/stages!));
    } catch (e) {
      emit(state.copyWith(loadDetailStatus: LoadStatus.FAILURE));
    }
  }
}

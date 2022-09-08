import 'package:flutter_base/models/entities/garden/garden_entity.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/entities/season/stage_season.dart';
import 'package:flutter_base/models/entities/season/step_season.dart';
import 'package:flutter_base/models/entities/tree/list_tree_response.dart';
import 'package:flutter_base/models/entities/tree/tree_delete_response.dart';
import 'package:flutter_base/models/entities/turnover/turnover_entity.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class SeasonRepository {
  Future<List<SeasonEntity>> getListSeasonData();

  Future<SeasonEntity> getSeasonById(String seasonId);

  Future createSeason(
     SeasonEntity param);

  Future<TreeDeleteResponse> deleteSeason(String seasonId);
  Future<OtherSeasonEntity> addPhase(StageSeason phaseSeason, String seasonId);
  Future<OtherSeasonEntity> putPhase(StageSeason phageSeason, String phaseId);
  Future<OtherSeasonEntity> putStep(String stepSeasonId, String phaseId, StepSeason stepSeason);
  Future<OtherSeasonEntity> addStep(String phaseId, StepSeason stepSeason);
  Future<OtherSeasonEntity> deletePhase(String phaseId);
  Future<OtherSeasonEntity> deleteStep(String stepId, String phaseId);
  Future<OtherSeasonEntity> endStep(String phaseId, String stepId);
  Future<OtherSeasonEntity> endPhase(String phaseId);
  Future<dynamic> endSeason(String seasonId, List<TurnoverEntity> turnovers);
  Future<GardenEntity> getGardenById(String gardenId);
  Future<TreeEntity> getTreeById(String treeId);


// Future<SeasonEntity> updateSeason(
//     String seasonId, SeasonEntity param);

// Future<ObjectResponse<SeasonTaskResponse>> getSeasonTaskByDay(
//     String seasonId, String date);
//
// Future<ObjectResponse<SeasonTaskDetailResponse>> getSeasonTaskDetail(
//     String taskId);
//
// Future<ObjectResponse<SeasonStepsResponse>> getListSeasonSteps(
//     String seasonId);

// Future<ObjectResponse<QREntity>> generateQRCode(String seasonId);
}

class SeasonRepositoryImpl extends SeasonRepository {
  ApiClient? _apiClientBagri;

  SeasonRepositoryImpl(ApiClient? client) {
    _apiClientBagri = client;
  }

  @override
  Future<List<SeasonEntity>> getListSeasonData() async {
    return await _apiClientBagri!.getListSeasonData();
  }

  @override
  Future<SeasonEntity> getSeasonById(
      String seasonId) async {
    return await _apiClientBagri!.getSeasonById(seasonId);
  }

  @override
  Future createSeason(
      SeasonEntity param) async {
    return await _apiClientBagri!.createSeason(param.toJson());
  }

  @override
  Future<TreeDeleteResponse> deleteSeason(String seasonId) async {
    return await _apiClientBagri!.deleteSeason(seasonId);
  }

  @override
  Future<OtherSeasonEntity> addPhase(StageSeason phaseSeason, String seasonId) async{
    return await _apiClientBagri!.createPhase(phaseSeason.toJson(), seasonId);
  }

  @override
  Future<OtherSeasonEntity> addStep(String phaseId, StepSeason stepSeason) async{
    return await _apiClientBagri!.addStep(stepSeason.toJson(), phaseId);
  }

  @override
  Future<OtherSeasonEntity> putPhase(StageSeason phaseSeason, String phaseId) async{
    var data = {
      'name': phaseSeason.name,
      'descriptiton': phaseSeason.description,
      'start': phaseSeason.start
    };
    return await _apiClientBagri!.putPhase(data, phaseId);
  }

  @override
  Future<OtherSeasonEntity> putStep(String stepId, String phaseId, StepSeason stepSeason) async{
    var data = {
      "start": stepSeason.start,
      "name": stepSeason.name,
      "aboutFrom": stepSeason.from_day,
      "aboutTo": stepSeason.to_day,
      "description": stepSeason.description
    };
    return await _apiClientBagri!.putStep(phaseId, stepId, data);
  }

  @override
  Future<OtherSeasonEntity> deletePhase(String phaseId) async {
    return await _apiClientBagri!.deletePhase(phaseId);
  }

  @override
  Future<OtherSeasonEntity> deleteStep(String stepId, String phaseId) async{
    return await _apiClientBagri!.deleteStep(phaseId, stepId);
  }

  @override
  Future<OtherSeasonEntity> endPhase(String phaseId) async{
    return await _apiClientBagri!.endPhase(phaseId);
  }

  @override
  Future<OtherSeasonEntity> endStep(String phaseId, String stepId) async{
    return await _apiClientBagri!.endStep(phaseId, stepId);
  }

  @override
  Future endSeason(String seasonId, List<TurnoverEntity> turnovers) async{
    final data = {
      "turnovers": turnovers
    };
    return await _apiClientBagri!.endSeason(seasonId, data);
  }

  @override
  Future<GardenEntity> getGardenById(String gardenId) async{
    return await _apiClientBagri!.getGardenById(gardenId);
  }

  @override
  Future<TreeEntity> getTreeById(String treeId) {
    return _apiClientBagri!.getTreeById(treeId);
  }






// @override
// Future<SeasonEntity> updateSeason(
//     String seasonId, SeasonEntity param) async {
//   return await _apiClientBagri!.updateSeason(seasonId, param.toJson());
// }

// @override
// Future<ObjectResponse<SeasonTaskResponse>> getSeasonTaskByDay(
//     String seasonId, String date) async {
//   return await _apiClientBagri!.getSeasonTaskByDay(seasonId, date);
// }
//
// @override
// Future<ObjectResponse<SeasonTaskDetailResponse>> getSeasonTaskDetail(
//     String taskId) async {
//   return await _apiClientBagri!.getSeasonTaskDetail(taskId);
// }
//
// @override
// Future<ObjectResponse<SeasonStepsResponse>> getListSeasonSteps(
//     String seasonId) async {
//   return await _apiClientBagri!.getListSeasonSteps(seasonId);
// }

// @override
// Future<ObjectResponse<QREntity>> generateQRCode(String seasonId) async {
//   return await _apiClientBagri!.generateQRCode(seasonId);
// }


}
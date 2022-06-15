import 'package:flutter_base/models/entities/season/qr_entity.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/entities/season/season_steps_response.dart';
import 'package:flutter_base/models/entities/season/season_task_detail_entity.dart';
import 'package:flutter_base/models/entities/season/season_task_entity.dart';
import 'package:flutter_base/models/entities/tree/tree_delete_response.dart';
import 'package:flutter_base/models/response/object_response.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class SeasonRepository {
  Future<List<SeasonEntity>> getListSeasonData();

  Future<SeasonEntity> getSeasonById(String seasonId);

  Future createSeason(
      SeasonEntity param);

  Future<TreeDeleteResponse> deleteSeason(String seasonId);

  Future<SeasonEntity> updateSeason(
      String seasonId, SeasonEntity param);

  Future<ObjectResponse<SeasonTaskResponse>> getSeasonTaskByDay(
      String seasonId, String date);

  Future<ObjectResponse<SeasonTaskDetailResponse>> getSeasonTaskDetail(
      String taskId);

  Future<ObjectResponse<SeasonStepsResponse>> getListSeasonSteps(
      String seasonId);

  Future<ObjectResponse<QREntity>> generateQRCode(String seasonId);
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
  Future<SeasonEntity> updateSeason(
      String seasonId, SeasonEntity param) async {
    return await _apiClientBagri!.updateSeason(seasonId, param.toJson());
  }

  @override
  Future<ObjectResponse<SeasonTaskResponse>> getSeasonTaskByDay(
      String seasonId, String date) async {
    return await _apiClientBagri!.getSeasonTaskByDay(seasonId, date);
  }

  @override
  Future<ObjectResponse<SeasonTaskDetailResponse>> getSeasonTaskDetail(
      String taskId) async {
    return await _apiClientBagri!.getSeasonTaskDetail(taskId);
  }

  @override
  Future<ObjectResponse<SeasonStepsResponse>> getListSeasonSteps(
      String seasonId) async {
    return await _apiClientBagri!.getListSeasonSteps(seasonId);
  }

  @override
  Future<ObjectResponse<QREntity>> generateQRCode(String seasonId) async {
    return await _apiClientBagri!.generateQRCode(seasonId);
  }
}

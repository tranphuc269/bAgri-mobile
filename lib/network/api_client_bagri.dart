import 'package:dio/dio.dart';
import 'package:flutter_base/configs/app_config.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/models/entities/contract_work/contract_work.dart';
import 'package:flutter_base/models/entities/file/file_entity.dart';
import 'package:flutter_base/models/entities/garden/garden_delete.dart';

import 'package:flutter_base/models/entities/garden/garden_detail.dart';
import 'package:flutter_base/models/entities/garden/garden_entity.dart';
import 'package:flutter_base/models/entities/garden_task/garden_task_detail.dart';
import 'package:flutter_base/models/entities/garden_task/task_delete_entity.dart';
import 'package:flutter_base/models/entities/manager/manager_entity.dart';
import 'package:flutter_base/models/entities/garden_task/garden_task.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/models/entities/notification/notification.dart';
import 'package:flutter_base/models/entities/notification/notification_detail.dart';
import 'package:flutter_base/models/entities/process/list_process.dart';
import 'package:flutter_base/models/entities/process/process_delete.dart';
import 'package:flutter_base/models/entities/process/process_detail.dart';
import 'package:flutter_base/models/entities/process/step_entity.dart';
import 'package:flutter_base/models/entities/season/qr_entity.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/entities/season/season_steps_response.dart';
import 'package:flutter_base/models/entities/season/season_task_detail_entity.dart';
import 'package:flutter_base/models/entities/season/season_task_entity.dart';
import 'package:flutter_base/models/entities/season/season_update_entity.dart';
import 'package:flutter_base/models/entities/season/stage_season.dart';
import 'package:flutter_base/models/entities/task/contract_task.dart';
import 'package:flutter_base/models/entities/task/task.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/models/entities/token/login_model.dart';
import 'package:flutter_base/models/entities/tree/list_tree_response.dart';
import 'package:flutter_base/models/entities/tree/tree_delete_response.dart';
import 'package:flutter_base/models/entities/tree/tree_detail_response.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';
import 'package:flutter_base/models/entities/zone/zone_entity.dart';
import 'package:flutter_base/models/response/object_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client_bagri.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST("/auth")
  Future<TokenEntity> authLogin(@Body() Map<String, dynamic> body);

  @GET("/auth")
  Future<UserEntity> getUserData(
      @Header('accept') String content, @Header("Authorization") String token);

  @POST("/accounts")
  Future<dynamic> authRegistty(@Body() Map<String, dynamic> body);

  @GET("/accounts")
  Future<List<UserEntity>> getListAccounts(
      @Header('accept') String content, @Header("Authorization") String token);

  @PUT("/accounts/{id}")
  Future<dynamic> setRoleAccount(
      @Header('accept') String accept,
      @Header("Authorization") String auth,
      @Header("Content-Type") String content_type,
      @Path("id") String? id,
      @Body() Map<String, dynamic> body);

  @PATCH("/accounts/password")
  Future<dynamic> changePassword(
      @Header("accept") String? accept,
      @Header("Authorization") String auth,
      @Header("Content-Type") String content_type,
      @Body() Map<String, dynamic> body);

  /// reset-password
  @POST("/accounts/reset-password/init?email={email}")
  Future<dynamic> forgotPassword(
      @Header("accept") String? accept,
      @Path("email") String? email);

  @POST("/accounts/reset-password/finish")
  Future<dynamic> AuthOtp(
      @Header("accept") String? accept,
      @Header("Content-Type") String content_type,
      @Body() Map<String, dynamic> body);

  /// Zone
  @POST("/zones")
  Future<dynamic> createZone(
      @Header('accept') String accept,
      @Header('Content-Type') String content_type,
      @Body() Map<String, dynamic> body);

  @GET("/zones")
  Future<List<ZoneEntity>> getListZone(
      @Header('accept') String accept, @Header("Authorization") String auth);

  @PUT("/zones/{zone_id}")
  Future<ZoneEntity> modifyZone(
      @Header('accept') String accept,
      @Header('Content-Type') String content_type,
      @Path("zone_id") String? zoneId,
      @Body() Map<String, dynamic> body);

  @DELETE("/zones/{zone_id}")
  Future<dynamic> deleteZone(@Header('accept') String? accept,
      @Header("Authorization") String? auth, @Path("zone_id") String? zoneId);

  @GET("/gardens?zone={zone_id}")
  Future<List<GardenEntity>> getListGardenByZone(
      @Header('accept') String? accept,
      @Header("Authorization") String? auth,
      @Path("zone_id") String? zone_id);

  /// Garden
  @GET("/gardens")
  Future<List<GardenEntity>> getGardenData();

  @GET("/gardens")
  Future<ObjectResponse<GardenListResponse>> getGardensByManagerId(
      @Query('manager_id') String managerId);

  @POST("/gardens")
  Future<dynamic> createGarden(
      @Header("accept") String? accept,
      @Header("Authorization") String? auth,
      @Header('Content-Type') String content_type,
      @Body() Map<String, dynamic> body);

  @GET("/gardens/{garden_id}")
  Future<GardenDetailEntityResponse> getGardenDataById(
      {@Header("accept") String? accept,
      @Header("Authorization") String? auth,
      @Path("garden_id") String? gardenId});

  @PUT("/gardens/{garden_id}")
  Future<dynamic> updateGarden(
      @Header("accept") String? accept,
      @Header("Authorization") String? auth,
      @Header("Content-Type") String? content_type,
      @Path("garden_id") String? gardenId,
      @Body() Map<String, dynamic> body);

  @DELETE("/gardens/{garden_id}")
  Future<GardenDeleteResponse> deleteGarden(
      {@Path("garden_id") String? gardenId});

  @GET('/gardens/{garden_id}')
  Future<GardenEntity> getGardenById(@Path('garden_id') String? gardenId);

  /// Process

  @DELETE("/processes/{process_id}")
  Future<ProcessDeleteResponse> deleteProcess(
      {@Path("process_id") String? processId});

  @POST("/processes")
  Future<dynamic> createProcess(@Body() Map<String, dynamic> body);

  @PUT("/processes/{process_id}")
  Future<dynamic> updateProcess(
      @Path("process_id") String? processId, @Body() Map<String, dynamic> body);

  @GET("/processes/{process_id}")
  Future<ProcessEntity> getProcessById(@Path('process_id') String processId);

  @GET("/processes_by_tree?tree_id={tree_id}")
  Future<ProcessDataEntity> getProcessOfTree(@Path("tree_id") String treeId);

  /// Tree

  @DELETE("/trees/{tree_id}")
  Future<TreeDeleteResponse> deleteTree({@Path("tree_id") String? treeId});

  @POST("/trees")
  Future<dynamic> createTree(@Body() Map<String, dynamic> body);

  @PUT("/trees/{tree_id}")
  Future<dynamic> updateTree(
      @Path("tree_id") String? treeId, @Body() Map<String, dynamic> body);

  @GET("/trees/{tree_id}")
  Future<TreeEntity> getTreeById(
      @Path('tree_id') String treeId);

  /// Notification
  @GET("/notifications")
  Future<ObjectResponse<NotificationListData>> getListNotification();

  @GET("/notifications/{notification_id}")
  Future<ObjectResponse<NotificationDetailEntity>> getNotificationDataById(
      {@Path('notification_id') String? notifiId});

  /// Season
  @GET("/seasons")
  Future<List<SeasonEntity>> getListSeasonData();

  @GET("/seasons/{seasonId}")
  Future<SeasonEntity> getSeasonById(@Path('seasonId') String seasonId);

  @POST("/seasons")
  Future<dynamic> createSeason(@Body() Map<String, dynamic> body);

  @DELETE("/seasons/{season_id}")
  Future<TreeDeleteResponse> deleteSeason(@Path("season_id") String seasonId);

  @PUT("/seasons/{season_id}")
  Future<SeasonEntity> updateSeason(
      @Path("season_id") String seasonId, @Body() Map<String, dynamic> param);

  @PATCH("/seasons/{season_id}/end")
  Future<dynamic> endSeason(@Path('season_id') String seasonId, @Body() Map<String, dynamic> param);

  ///phase-season
  @POST("/phases/{season_id}")
  Future<SeasonEntity> createPhase(
      @Body() Map<String, dynamic> body, @Path('season_id') String seasonId);

  @PUT("/phases/{phase_id}")
  Future<SeasonEntity> putPhase(
      @Body() Map<String, dynamic> body, @Path('phase_id') String phaseId);

  @PATCH("/phases/{phase_id}/end")
  Future<SeasonEntity> endPhase(@Path('phase_id') String phaseId);

  @DELETE("/phases/{phase_id}")
  Future<OtherSeasonEntity> deletePhase(@Path('phase_id') String phaseId);

  ///step-season
  @POST('/steps/{phase_id}')
  Future<OtherSeasonEntity> addStep(
      @Body() Map<String, dynamic> body, @Path('phase_id') String phaseId);

  @PUT('/steps/{phase_id}/{step_id}')
  Future<OtherSeasonEntity> putStep(@Path('phase_id') String phaseId,
      @Path('step_id') String stepId, @Body() Map<String, dynamic> body);

  @PATCH('/steps/{phase_id}/{step_id}/end')
  Future<SeasonEntity> endStep(
      @Path('phase_id') String phaseId, @Path('step_id') String stepId);

  @DELETE('/steps/{phase_id}/{step_id}')
  Future<OtherSeasonEntity> deleteStep(
      @Path('phase_id') String phaseId, @Path('step_id') String stepId);

  ///Task
  @GET("/tasks")
  Future<ObjectResponse<TaskListData>> getListTask();

  @GET("/tasks")
  Future<ObjectResponse<GardenTaskList>> getGardenTask(
      @Query('season_id') String seasonId, @Query('date') String date);

  @POST("/tasks")
  Future<dynamic> createTask(@Body() Map<String, dynamic> body);

  @PUT("/tasks/{task_id}")
  Future<dynamic> updateTask(
      @Path("task_id") String? taskId, @Body() Map<String, dynamic> body);

  @GET("/tasks/{task_id}")
  Future<ObjectResponse<GardenTaskDetailResponse>> getTaskById(
      @Path('task_id') String taskId);

  @DELETE("/tasks/{task_id}")
  Future<ObjectResponse<TaskDeleteEntity>> deleteTask(
      @Path("task_id") String taskId);

  ///get Step by day for garden manager

  @GET("/steps?day={day}")
  Future<List<StepEntityResponseByDay>> getStepsByDay(
      @Header('accept') String accept,
      @Header("Authorization") String? auth,
      @Path("day") String? day);

  ///user
  @GET("/me")
  Future<ObjectResponse<UserEntity>> getProfile();

  ///Manager
  @GET("/managers")
  Future<ObjectResponse<ManagerListResponse>> getListManager();

  ///Contract Work
  @GET("/works")
  Future<List<ContractWorkEntity>> getListContractWork(
      @Header("accept") String? accept, @Header("Authorization") String? auth);

  @POST("/works")
  Future<dynamic> createContractWork(
      @Header('accept') String accept,
      @Header("Authorization") String? auth,
      @Header('Content-Type') String content_type,
      @Body() Map<String, dynamic> body);

  @GET("/contract-tasks")
  Future<List<ContractTask>> getListContractTask(
      @Header('accept') String accept, @Header("Authorization") String? auth);

  @GET("/contract-tasks?seasonId={season_id}")
  Future <List<ContractTask>> getListContractTaskBySeason(
      @Header('accept') String accept, @Header("Authorization") String? auth, @Path("season_id") String? seasonId);


  @DELETE("/works/{work_id}")
  Future<dynamic> deleteContractWork(
    @Header("accept") String? accept,
    @Header("Authorization") String? auth,
    @Path("work_id") String? workId,
  );

  @PUT("/works/{work_id}")
  Future<dynamic> modifyContractWork(
      @Header('accept') String accept,
      @Header("Authorization") String? auth,
      @Header('Content-Type') String content_type,
      @Path("work_id") String? workId,
      @Body() Map<String, dynamic> body);

  /// Create Contract task
  @POST("/contract-tasks")
  Future<dynamic> createContractTask(
      @Header('accept') String accept,
      @Header("Authorization") String? auth,
      @Header('Content-Type') String content_type,
      @Body() Map<String, dynamic> body);

  @GET("/contract-tasks/{contract_task_id}")
  Future <ContractTask> getContractTaskDetail(
      @Header('accept') String accept,
      @Header("Authorization") String? auth,
      @Path("contract_task_id") String? contractTaskId,);


  @DELETE("/contract-tasks/{contract_task_id}")
  Future<dynamic> deleteContractTask(
      @Header('accept') String accept,
      @Header("Authorization") String? auth,
      @Path("contract_task_id") String? contractTaskId);
  @PUT("/contract-tasks/{contract_task_id}")
  Future<dynamic> updateContractTask(
      @Header('accept') String accept,
      @Header("Authorization") String? auth,
      @Path("contract_task_id") String? contractTaskId,
      @Header('Content-Type')String content_type,
      @Body() Map<String, dynamic> body);
  @PATCH("/contract-tasks/{contract_task_id}/end")
  Future <dynamic> finishContractTask(
      @Header('accept') String accept,
      @Header("Authorization") String? auth,
      @Path("contract_task_id") String? contractTaskId,
      @Header('Content-Type')String content_type,
      @Body() Map<String, dynamic> body);

  /// Upload File
  @POST("/files")
  Future<ObjectResponse<FileEntity>> uploadFile(@Body() dynamic body);

  @POST("/seasons/{season_id}/qr_code")
  Future<ObjectResponse<QREntity>> generateQRCode(
      @Path("season_id") String seasonId);

  ///temporary task
  @GET("/temporary-tasks")
  Future<List<TemporaryTask>> getListTemporaryTasks();

  @GET("/temporary-tasks?seasonId={season_id}")
  Future<List<TemporaryTask>> getListTemporaryTasksBySeason(
      @Header('accept') String accept,
      @Header("Authorization") String? auth,
      @Path("season_id") String? seasonId);


  @POST("/temporary-tasks")
  Future<dynamic> createTemporaryTask(@Body() Map<String, dynamic> body);

  @PUT("/temporary-tasks/{temporary_task_id}")
  Future<dynamic> updateTemporaryTask(@Body() Map<String, dynamic> body,
      @Path('temporary_task_id') String? temporaryTaskId);

  @GET("/temporary-tasks/{temporary_task_id}")
  Future<TemporaryTask> getTemporaryTaskById(
      @Path('temporary_task_id') String? temporaryTaskId);

  @DELETE("//temporary-tasks/{temporary_task_id}")
  Future<dynamic> deleteTemporaryTask(@Path('temporary_task_id') String? id);

  ///material
  @GET("/materials")
  Future<List<MaterialEntity>> getListMaterials();

  @GET("/materials/{material_id}")
  Future<MaterialEntity> getMaterialById(
      @Path("material_id") String? materialId);

  @POST("/materials")
  Future<dynamic> createMaterial(@Body() Map<String, dynamic> body);

  @PUT("/materials/{material_id}")
  Future<dynamic> updateMaterial(@Body() Map<String, dynamic> body,
      @Path("material_id") String? materialId);

  @DELETE("/materials/{material_id}")
  Future<dynamic> deleteMaterial(@Path("material_id") String? materialId);
}

class AppApi {
  static AppApi instance = AppApi();
  Dio _dio = Dio();

  Future<TreeDataEntity> getListTreeData() async {
    final response = await _dio.get("${AppConfig.baseUrl}/trees",
        options: Options(
            headers: {'Authorization': 'Bearer ${GlobalData.instance.token}'}));
    return TreeDataEntity.fromJson(response.data);
  }

  Future<ProcessDataEntity> getListProcessData() async {
    final response = await _dio.get("${AppConfig.baseUrl}/processes",
        options: Options(
            headers: {'Authorization': 'Bearer ${GlobalData.instance.token}'}));
    return ProcessDataEntity.fromJson(response.data);
  }
}

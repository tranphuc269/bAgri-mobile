import 'package:dio/dio.dart';
import 'package:flutter_base/configs/app_config.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/models/entities/contract_work/contract_work.dart';
import 'package:flutter_base/models/entities/farmer/farmer.dart';
import 'package:flutter_base/models/entities/farmer/farmer_detail_entity.dart';
import 'package:flutter_base/models/entities/file/file_entity.dart';
import 'package:flutter_base/models/entities/garden/garden_delete.dart';

import 'package:flutter_base/models/entities/garden/garden_detail.dart';
import 'package:flutter_base/models/entities/garden/garden_entity.dart';
import 'package:flutter_base/models/entities/garden_task/garden_task_detail.dart';
import 'package:flutter_base/models/entities/garden_task/task_delete_entity.dart';
import 'package:flutter_base/models/entities/manager/manager_entity.dart';
import 'package:flutter_base/models/entities/garden_task/garden_task.dart';
import 'package:flutter_base/models/entities/notification/notification.dart';
import 'package:flutter_base/models/entities/notification/notification_detail.dart';
import 'package:flutter_base/models/entities/process/list_process.dart';
import 'package:flutter_base/models/entities/process/process_delete.dart';
import 'package:flutter_base/models/entities/process/process_detail.dart';
import 'package:flutter_base/models/entities/season/qr_entity.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/entities/season/season_steps_response.dart';
import 'package:flutter_base/models/entities/season/season_task_detail_entity.dart';
import 'package:flutter_base/models/entities/season/season_task_entity.dart';
import 'package:flutter_base/models/entities/season/season_update_entity.dart';
import 'package:flutter_base/models/entities/task/task.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/models/entities/task/work.dart';
import 'package:flutter_base/models/entities/token/login_model.dart';
import 'package:flutter_base/models/entities/tree/list_tree_response.dart';
import 'package:flutter_base/models/entities/tree/tree_delete_response.dart';
import 'package:flutter_base/models/entities/tree/tree_detail_response.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';
import 'package:flutter_base/models/entities/zone/zone_entity.dart';
import 'package:flutter_base/models/params/farmer/create_farmer_param.dart';
import 'package:flutter_base/models/params/season/create_season_param.dart';
import 'package:flutter_base/models/response/object_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client_bagri.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST("/auth")
  Future<TokenEntity> authLogin(@Body() Map<String, dynamic> body);

  @GET("/auth")
  Future<UserEntity> getUserData(@Header('accept') String content, @Header("Authorization") String token);

  @POST("/accounts")
  Future<dynamic> authRegistty(@Body() Map<String, dynamic> body);

  @GET("/accounts")
  Future<List<UserEntity>> getListAccounts(
      @Header('accept') String content, @Header("Authorization") String token);

  @PUT("/accounts/{id}")
  Future<dynamic> setRoleAccount(@Header('accept') String accept, @Header("Authorization") String auth,@Header("Content-Type")String content_type, @Path("id") String? id, @Body() Map<String, dynamic> body );

  @PUT("/change-password")
  Future<dynamic> changePassword(@Body() Map<String, dynamic> body);

  @POST("/reset-password")
  Future<dynamic> forgotPassword(@Body() Map<String, dynamic> body);

/// Zone
  @POST("/zones")
  Future<dynamic> createZone(
      @Header('accept') String accept,
      @Header('Content-Type')String content_type,
      @Body() Map<String, dynamic> body);

  @GET("/zones")
  Future<List<ZoneEntity>> getListZone(@Header('accept') String accept,
      @Header("Authorization") String auth);
  @PUT("/zones/{zone_id}")
  Future<ZoneEntity> modifyZone(
      @Header('accept') String accept,
      @Header('Content-Type')String content_type,
      @Path("zone_id") String? zoneId,
      @Body() Map<String, dynamic> body);

  @DELETE("/zones/{zone_id}")
  Future<dynamic> deleteZone(
      @Header('accept') String? accept,
      @Header("Authorization") String? auth,
      @Path("zone_id") String? zoneId);

  @GET("/gardens?zone={zone_id}")
  Future<List<GardenEntityResponseFromZoneId>> getListGardenByZone(
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
      @Header('Content-Type')String content_type,
      @Body() Map<String, dynamic> body);

  @GET("/gardens/{garden_id}")
  Future<GardenDetailEntityResponse> getGardenDataById(
      {@Header("accept") String? accept, @Header("Authorization") String? auth, @Path("garden_id") String? gardenId});

  @PUT("/gardens/{garden_id}")
  Future<dynamic> updateGarden(@Header("accept") String? accept, @Header("Authorization") String? auth, @Header("Content-Type") String? content_type,
      @Path("garden_id") String? gardenId, @Body() Map<String, dynamic> body);

  @DELETE("/gardens/{garden_id}")
  Future<GardenDeleteResponse> deleteGarden(
      {@Path("garden_id") String? gardenId});

  /// Process
  // @GET("/processes")
  // Future<ProcessDataEntity> getListProcessData(
  //     @Body() Map<String, dynamic> body);

  @DELETE("/processes/{process_id}")
  Future<ProcessDeleteResponse> deleteProcess(
      {@Path("process_id") String? processId});

  @POST("/processes")
  Future<dynamic> createProcess(@Body() Map<String, dynamic> body);

  @PUT("/processes/{process_id}")
  Future<dynamic> updateProcess(
      @Path("process_id") String? processId, @Body() Map<String, dynamic> body);

  @GET("/processes/{process_id}")
  Future<ProcessEntity> getProcessById(
      @Path('process_id') String processId);

  @GET("/processes_by_tree?tree_id={tree_id}")
  Future<ProcessDataEntity> getProcessOfTree(@Path("tree_id") String treeId);

  /// Tree
  // @GET("/trees")
  // Future<TreeDataEntity> getListTreeData();

  @DELETE("/trees/{tree_id}")
  Future<TreeDeleteResponse> deleteTree({@Path("tree_id") String? treeId});

  @POST("/trees")
  Future<dynamic> createTree(@Body() Map<String, dynamic> body);

  @PUT("/trees/{tree_id}")
  Future<dynamic> updateTree(
      @Path("tree_id") String? treeId, @Body() Map<String, dynamic> body);

  @GET("/trees/{tree_id}")
  Future<ObjectResponse<TreeDetailResponse>> getTreeById(
      @Path('tree_id') String treeId);

  /// Employee/Farmer
  @GET("/farmers")
  Future<FarmerList> getListFarmerData();

  @GET("/farmers")
  Future<FarmerList> getListFarmerByManager(
      @Query('manager_id') String managerId);

  @GET("/farmers/{farmerId}")
  Future<ObjectResponse<FarmerDetailResponse>> getFarmerById(
      @Path('farmerId') String farmerId);

  @DELETE("/farmers/{farmerId}")
  Future<TreeDeleteResponse> deleteFarmer(@Path("farmerId") String farmerId);

  @POST("/farmers")
  Future<ObjectResponse<FarmerCreateResponse>> createFarmer(
      @Body() CreateFarmerParam param);

  @PUT("/farmers/{farmer_id}")
  Future<ObjectResponse<FarmerUpdateResponse>> updateFarmer(
      @Path("farmer_id") String farmerId, @Body() CreateFarmerParam param);

  /// Notification
  @GET("/notifications")
  Future<ObjectResponse<NotificationListData>> getListNotification();

  @GET("/notifications/{notification_id}")
  Future<ObjectResponse<NotificationDetailEntity>> getNotificationDataById(
      {@Path('notification_id') String? notifiId});

  /// Season
  @GET("/seasons")
  Future<List<SeasonEntity>> getListSeasonData(
      );

  @GET("/seasons/{seasonId}")
  Future<SeasonEntity> getSeasonById(
      @Path('seasonId') String seasonId);

  @POST("/seasons")
  Future<dynamic> createSeason(
      @Body() Map<String, dynamic> body);

  @DELETE("/seasons/{season_id}")
  Future<TreeDeleteResponse> deleteSeason(@Path("season_id") String seasonId);

  @PUT("/seasons/{season_id}")
  Future<SeasonEntity> updateSeason(
      @Path("season_id") String seasonId, @Body() Map<String, dynamic> param);

  @GET("/tasks")
  Future<ObjectResponse<SeasonTaskResponse>> getSeasonTaskByDay(
      @Query('season_id') String seasonId, @Query('date') String date);

  @GET("/tasks/{task_id}")
  Future<ObjectResponse<SeasonTaskDetailResponse>> getSeasonTaskDetail(
      @Path('task_id') String taskId);

  @GET("/seasons/{season_id}/steps")
  Future<ObjectResponse<SeasonStepsResponse>> getListSeasonSteps(
      @Path('season_id') String seasonId);

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

  ///user
  @GET("/me")
  Future<ObjectResponse<UserEntity>> getProfile();

  ///Manager
  @GET("/managers")
  Future<ObjectResponse<ManagerListResponse>> getListManager();

  ///Contract Work
  @GET("/works")
  Future<List<ContractWorkEntity>> getListContractWork(@Header("accept") String? accept, @Header("Authorization") String? auth);
  @POST("/works")
  Future<dynamic> createContractWork(
      @Header('accept') String accept,
      @Header("Authorization") String? auth,
      @Header('Content-Type')String content_type,
      @Body() Map<String, dynamic> body);
  @DELETE("/works/{work_id}")
  Future <dynamic> deleteContractWork (
      @Header("accept") String? accept,
      @Header("Authorization") String? auth,
      @Path("work_id") String? workId,);
  @PUT("/works/{work_id}")
  Future <dynamic> modifyContractWork(@Header('accept') String accept,@Header("Authorization") String? auth,@Header('Content-Type')String content_type,@Path("work_id") String? workId,@Body() Map<String, dynamic> body);


  /// Upload File
  @POST("/files")
  Future<ObjectResponse<FileEntity>> uploadFile(@Body() dynamic body);

  @POST("/seasons/{season_id}/qr_code")
  Future<ObjectResponse<QREntity>> generateQRCode(
      @Path("season_id") String seasonId);

  //temporary task
  @GET("/temporary-tasks")
  Future<List<TemporaryTask>> getListTemporaryTasks();

  @POST("/temporary-tasks")
  Future<dynamic> createTemporaryTask(@Body() Map<String, dynamic> body);
}

class AppApi {
  static AppApi instance = AppApi();
  Dio _dio = Dio();
  Future<TreeDataEntity> getListTreeData() async {
    final response = await _dio.get("${AppConfig.baseUrl}/trees",
        options: Options(headers: {
          'Authorization': 'Bearer ${GlobalData.instance.token}'
        }));
    return TreeDataEntity.fromJson(response.data);
  }
  Future<ProcessDataEntity> getListProcessData() async {
    final response = await _dio.get("${AppConfig.baseUrl}/processes",
        options: Options(headers: {
          'Authorization': 'Bearer ${GlobalData.instance.token}'
        }));
    return ProcessDataEntity.fromJson(response.data);
  }
}

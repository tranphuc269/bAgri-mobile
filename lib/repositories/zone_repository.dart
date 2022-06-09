import 'package:flutter_base/models/entities/garden/garden_delete.dart';
import 'package:flutter_base/models/entities/garden/garden_detail.dart';
import 'package:flutter_base/models/entities/garden/garden_entity.dart';
import 'package:flutter_base/models/entities/zone/zone_entity.dart';
import 'package:flutter_base/models/params/garden/create_garden_params.dart';
import 'package:flutter_base/models/params/zone/create_zone_params.dart';
import 'package:flutter_base/models/response/object_response.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class ZoneRepository {
  Future<dynamic> getZoneData(String? accessToken);

  Future<dynamic> createZone({CreateZoneParam? param});

  Future<dynamic> deleteZone(String? accessToken, String? zoneId);

  Future<dynamic> modifyZone(String? accessToken, String? zoneID, CreateZoneParam? param);

  Future<dynamic> getAmountOfGardenOfZone(String? accessToken, String? zoneId);
}

class ZoneRepositoryImpl extends ZoneRepository {
  ApiClient? _apiClientBagri;

  ZoneRepositoryImpl(ApiClient? client) {
    _apiClientBagri = client;
  }

  @override
  Future<List<ZoneEntity>> getZoneData(String? accessToken) async {
    return await _apiClientBagri!.getListZone("application/json", accessToken!);
  }

  Future<dynamic> createZone({CreateZoneParam? param}) {
    final body = {
      "name": param?.name ?? "",
    };
    return _apiClientBagri!.createZone("application/json","application/json",body);
  }

  Future<dynamic> deleteZone(String? token, String? zoneId) async {
    return await _apiClientBagri!.deleteZone("application/json", token, zoneId);
  }

  Future<ZoneEntity> modifyZone(String? token, String? zoneId, CreateZoneParam? param){
    final body = {
      "name": param?.name ?? "",
    };
    return _apiClientBagri!.modifyZone("application/json","application/json", zoneId, body);
  }


  Future<List<GardenEntityResponseFromZoneId>> getAmountOfGardenOfZone(String? accessToken, String? zoneId) async {
   return _apiClientBagri!.getListGardenByZone("application/json", accessToken!, zoneId);
  }

  //
  // Future<GardenDetailResponse> getGardenDataById({String? gardenId}) async {
  //   return await _apiClientBagri!.getGardenDataById(gardenId: gardenId);
  // }
  //
  // Future<dynamic> updateGarden({String? gardenId, CreateGardenParam? param}) {
  //   final body = {
  //     "name": param?.name ?? "",
  //     "area": param?.area ?? "",
  //     "manager_id": param?.manager_id ?? "",
  //   };
  //
  //   return _apiClientBagri!.updateGarden(gardenId, body);
  // }
  //
  // Future<GardenDeleteResponse> deleteGarden({String? gardenId}) async {
  //   return await _apiClientBagri!.deleteGarden(gardenId: gardenId);
  // }
  //
  // @override
  // Future<ObjectResponse<GardenListResponse>> getGardensByManagerId(
  //     String managerId) async {
  //   return await _apiClientBagri!.getGardensByManagerId(managerId);
  // }
}

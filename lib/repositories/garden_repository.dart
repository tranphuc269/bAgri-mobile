import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/entities/garden/garden_delete.dart';
import 'package:flutter_base/models/entities/garden/garden_detail.dart';
import 'package:flutter_base/models/entities/garden/garden_entity.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';
import 'package:flutter_base/models/params/garden/create_garden_params.dart';
import 'package:flutter_base/models/params/garden/update_garden_params.dart';
import 'package:flutter_base/models/response/object_response.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class GardenRepository {
  Future<ObjectResponse<GardenListResponse>> getGardenData();

  Future<dynamic> createGarden({CreateGardenParam? param});

  Future<GardenDetailEntityResponse> getGardenDataById({String? gardenId});

  Future<dynamic> updateGarden({String? gardenId, UpdateGardenParam? param});

  Future<GardenDeleteResponse> deleteGarden({String? gardenId});

  Future<ObjectResponse<GardenListResponse>> getGardensByManagerId(
      String managerId);
  Future<List<GardenEntityResponseFromZoneId>> getListGardenByZone(String? accessToken, String? zoneId);

  Future<List<UserEntity>> getListAcounts();
}

class GardenRepositoryImpl extends GardenRepository {
  ApiClient? _apiClientBagri;
  final accessToken = SharedPreferencesHelper.getToken().toString();
  GardenRepositoryImpl(ApiClient? client) {
    _apiClientBagri = client;
  }

  @override
  Future<ObjectResponse<GardenListResponse>> getGardenData() async {
    return await _apiClientBagri!.getGardenData({});
  }

  Future<dynamic> createGarden({CreateGardenParam? param}) {
    final body = {
      "managerUsername": param?.managerUsername ?? "",
      "name": param?.name ?? "",
      "area": param?.area ?? "",
      "areaUnit": param?.areaUnit ?? "",
      "treePlaceQuantity": param?.treePlaceQuantity ?? "",
      "zone" : {
        "name" : param!.zoneName
      }
    };
    return _apiClientBagri!.createGarden("*/*", accessToken, "application/json", body);
  }

  Future<GardenDetailEntityResponse> getGardenDataById({String? gardenId}) async {
    return await _apiClientBagri!.getGardenDataById(accept: "application/json",auth:"Bearer ${accessToken}",gardenId: gardenId);
  }

  Future<dynamic> updateGarden({String? gardenId, UpdateGardenParam? param}) {
    final body = {
      "managerUsername": param?.managerUsername ?? "",
      "name": param?.name ?? "",
      "area": param?.area ?? "",
      "areaUnit": param?.areaUnit ?? "",
      "treePlaceQuantity": param?.treePlaceQuantity ?? "",
      "zone" : {
        "name" : param!.zoneName
      }
    };
    return _apiClientBagri!.updateGarden("application/json", "Bearer ${accessToken}", "application/json", gardenId, body);
  }

  Future<GardenDeleteResponse> deleteGarden({String? gardenId}) async {
    return await _apiClientBagri!.deleteGarden(gardenId: gardenId);
  }

  @override
  Future<ObjectResponse<GardenListResponse>> getGardensByManagerId(
      String managerId) async {
    return await _apiClientBagri!.getGardensByManagerId(managerId);
  }

  Future<List<GardenEntityResponseFromZoneId>> getListGardenByZone(String? accessToken, String? zoneId) async {
    return _apiClientBagri!.getListGardenByZone("application/json", accessToken, zoneId);
  }
  Future <List<UserEntity>>getListAcounts()  async {
    return _apiClientBagri!.getListAccounts("application/json", "Bearer ${accessToken}");
  }
}

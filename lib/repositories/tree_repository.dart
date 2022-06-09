import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/entities/tree/list_tree_response.dart';
import 'package:flutter_base/models/entities/tree/tree_delete_response.dart';
import 'package:flutter_base/models/entities/tree/tree_detail_response.dart';
import 'package:flutter_base/models/params/trees/create_tree_params.dart';
import 'package:flutter_base/models/response/object_response.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class TreeRepository {
  Future<List<TreeEntity>> getListTreeData();

  Future<List<TreeEntity>> deleteTree({String? treeId});

  Future<dynamic> createTree({String? name});

  Future<dynamic> updateTree({String? treeId, CreateTreeParam? param});

  Future<ObjectResponse<TreeDetailResponse>> getTreeById(String treeId);
}

class TreeRepositoryImpl extends TreeRepository {
  ApiClient? _apiClient;
  final accessToken = SharedPreferencesHelper.getToken().toString();
  TreeRepositoryImpl(ApiClient? client) {
    _apiClient = client;
  }

  @override
  Future<List<TreeEntity>> getListTreeData() async {
    return await _apiClient!.getListTreeData({});
  }

  Future<List<TreeEntity>> deleteTree({String? treeId}) async {
    return await _apiClient!.deleteTree("application/json","Beaer ${accessToken}",treeId);
  }

  Future<dynamic> createTree({String? name}) {
    final body = {
      "name": name ?? "",
    };

    return _apiClient!.createTree("application/json","Beaer ${accessToken}", body);
  }

  Future<dynamic> updateTree({String? treeId, CreateTreeParam? param}) {
    final body = {
      "name": param?.name ?? "",
      "description": param?.description ?? "",
    };
    return _apiClient!.updateTree(treeId, body);
  }

  @override
  Future<ObjectResponse<TreeDetailResponse>> getTreeById(String treeId) async {
    return await _apiClient!.getTreeById(treeId);
  }
}

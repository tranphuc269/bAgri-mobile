import 'package:flutter_base/models/entities/tree/list_tree_response.dart';
import 'package:flutter_base/models/entities/tree/tree_delete_response.dart';
import 'package:flutter_base/models/params/trees/create_tree_params.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class TreeRepository {
  Future<TreeDataEntity> getListTreeData();

  Future<TreeDeleteResponse> deleteTree({String? treeId});

  Future<dynamic> createTree({CreateTreeParam? param});

  Future<dynamic> updateTree({String? treeId, CreateTreeParam? param});

  Future<TreeEntity> getTreeById(String treeId);
}

class TreeRepositoryImpl extends TreeRepository {
  ApiClient? _apiClient;

  TreeRepositoryImpl(ApiClient? client) {
    _apiClient = client;
  }

  @override
  Future<TreeDataEntity> getListTreeData() async {
    // return await _apiClient!.getListTreeData();
    return await AppApi.instance.getListTreeData();
  }

  Future<TreeDeleteResponse> deleteTree({String? treeId}) async {
    return await _apiClient!.deleteTree(treeId: treeId);
  }

  Future<dynamic> createTree({CreateTreeParam? param}) {
    final body = {
      "name": param?.name ?? "",
    };

    return _apiClient!.createTree(body);
  }

  Future<dynamic> updateTree({String? treeId, CreateTreeParam? param}) {
    final body = {
      "name": param?.name ?? "",
    };
    return _apiClient!.updateTree(treeId, body);
  }

  @override
  Future<TreeEntity> getTreeById(String treeId) async {
    return await _apiClient!.getTreeById(treeId);
  }
}

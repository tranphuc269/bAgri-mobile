import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class MaterialRepository{
  Future<List<Material>> getListMaterial();
  Future<dynamic> createMaterial(Material material);
  Future<dynamic> deleteMaterial (String? materialId);
  Future<dynamic> updateMaterial (String? materialId, Map<String, dynamic> body);
}

class MaterialRepositoryImpl extends MaterialRepository{
  ApiClient? apiClientBagri;

  MaterialRepositoryImpl(ApiClient? apiClient){
    apiClientBagri = apiClient;
  }

  @override
  Future<List<Material>> getListMaterial() async{
    return await apiClientBagri!.getListMaterials();
  }

  @override
  Future createMaterial(Material material) async{
    return await apiClientBagri!.createMaterial(material.toJson());
  }

  @override
  Future deleteMaterial(String? materialId) async{
    return await apiClientBagri!.deleteMaterial(materialId);
  }

  @override
  Future updateMaterial(String? materialId, Map<String, dynamic> body) async{
    return await apiClientBagri!.updateMaterial(body, materialId);
  }

}
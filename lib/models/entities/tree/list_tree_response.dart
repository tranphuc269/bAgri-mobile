
// part 'list_tree_response.g.dart';

// @JsonSerializable()
// class ListTreeResponse {
//   @JsonKey()
//   String? status;
//   @JsonKey()
//   TreeDataEntity? data;
//
//   ListTreeResponse({
//     this.status,
//     this.data,
//   });
//
//   ListTreeResponse copyWith({
//     String? status,
//     TreeDataEntity? data,
//   }) {
//     return ListTreeResponse(
//       status: status ?? this.status,
//       data: data ?? this.data,
//     );
//   }

  // factory ListTreeResponse.fromJson(Map<String, dynamic> json) =>
  //     _$ListTreeResponseFromJson(json);
  // Map<String, dynamic> toJson() => _$ListTreeResponseToJson(this);
  // factory ListTreeResponse.fromJson(Map<String, dynamic> json) =>
  //     ListTreeResponse(
  //       status: json['status'] as String?,
  //       data: (json['data'] as List<dynamic>?)
  //           ?.map((e) => TreeEntity.fromJson(e as Map<String, dynamic>))
  //           .toList(),
  //     );
  //
  // Map<String, dynamic> toJson() =>
  //     <String, dynamic>{
  //       'status': this.status,
  //       'data': this.data!.map((e) => e.toJson()).toList(),
  //     };
// }

class TreeDataEntity {
  List<TreeEntity>? trees;

  TreeDataEntity({
    this.trees,
  });

  TreeDataEntity copyWith({
    List<TreeEntity>? trees,
  }) {
    return TreeDataEntity(
      trees: trees ?? this.trees,
    );
  }

  factory TreeDataEntity.fromJson(dynamic json){
    List<TreeEntity> listTrees =[];
    for(var item in json){
      TreeEntity treeEntity = TreeEntity.fromJson(item);
      listTrees.add(treeEntity);
    }
    return TreeDataEntity(trees: listTrees);
  }
  // Map<String, dynamic> toJson() => _$TreeDataEntityToJson(this);


}


class TreeEntity {
  int? id;
  String? tree_id;
  String? name;

  factory TreeEntity.fromJson(Map<String, dynamic> json){
    return TreeEntity(
      tree_id: json['_id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        '_id': this.tree_id,
        'name': this.name,
      };

  TreeEntity({
    this.id,
    this.tree_id,
    this.name,
  });

  TreeEntity copyWith({
    int? id,
    String? tree_id,
    String? name,
  }) {
    return TreeEntity(
      id: id ?? this.id,
      tree_id: tree_id ?? this.tree_id,
      name: name ?? this.name,
    );
  }
}





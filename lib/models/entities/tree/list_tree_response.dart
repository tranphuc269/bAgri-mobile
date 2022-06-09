import 'package:json_annotation/json_annotation.dart';

part 'list_tree_response.g.dart';

@JsonSerializable()
class TreeEntity {

  String?  tree_id;
  String? name;


  TreeEntity({
    this.tree_id,
    this.name,
  });

  TreeEntity copyWith({
    String? tree_id,
    String? name,
  }) {
    return TreeEntity(
      tree_id: tree_id ?? this.tree_id,
      name: name ?? this.name,
    );
  }

  factory TreeEntity.fromJson(Map<String, dynamic> json) =>
      _$TreeEntityFromJson(json);
  Map<String, dynamic> toJson() => _$TreeEntityToJson(this);


}





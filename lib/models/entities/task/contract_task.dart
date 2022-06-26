import 'package:flutter_base/models/entities/contract_work/contract_work.dart';

import 'package:json_annotation/json_annotation.dart';
part 'contract_task.g.dart';

@JsonSerializable()
class ContractTask{
  @JsonKey(name: "_id")
  String? id;
  @JsonKey()
  ContractWorkEntity? work;
  @JsonKey(name: 'garden')
  String? gardenName;
  num? treeQuantity;
  String? start;

  ContractTask({this.id, this.work, this.gardenName, this.treeQuantity, this.start});
  ContractTask copyWith({
    String? id,
    ContractWorkEntity? work,
    String? gardenName,
    num? treeQuantity,
    String? start
  }){
    return ContractTask(
      id: id ?? this.id,
      work: work ?? this.work,
      gardenName: gardenName ?? gardenName,
      treeQuantity: treeQuantity ?? this.treeQuantity,
      start: start ?? this.start
    );
  }
  factory ContractTask.fromJson(Map<String, dynamic> json) =>
      _$ContractTaskFromJson(json);

  Map<String, dynamic> toJson() => _$ContractTaskToJson(this);
}
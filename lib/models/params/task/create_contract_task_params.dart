import 'package:flutter_base/models/entities/contract_work/contract_work.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'create_contract_task_params.g.dart';
@JsonSerializable()
class CreateContractTaskParam {
  ContractWorkEntity ? work;
  String? gardenName;
  num? treeQuantity;
  String? description;

  CreateContractTaskParam({
    this.work,
    this.gardenName,
    this.treeQuantity,
    this.description
  });

  CreateContractTaskParam copyWith({
    ContractWorkEntity? work,
    String? gardenName,
    num? treeQuantity,
    String? description
  }) {
    return CreateContractTaskParam(
      work: work ?? this.work,
      gardenName: gardenName ?? this.gardenName,
      treeQuantity: treeQuantity ?? this.treeQuantity,
      description: description ?? this.description
    );
  }

  factory CreateContractTaskParam.fromJson(Map<String, dynamic> json) =>
      _$CreateContractTaskParamFromJson(json);

  Map<String, dynamic> toJson() => _$CreateContractTaskParamToJson(this);
}

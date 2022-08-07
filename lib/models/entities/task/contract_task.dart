import 'package:flutter_base/models/entities/contract_work/contract_work.dart';
import 'package:flutter_base/models/entities/material/material.dart';

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
  String? season;
  int? quantity;
  String? start;
  String? end;
  String? description;
  List<MaterialUsedByTask>? materials;

  ContractTask({this.id, this.work, this.gardenName, this.quantity, this.start, this.end, this.description, this.materials, this.season});
  ContractTask copyWith({
    String? id,
    ContractWorkEntity? work,
    String? gardenName,
    String? season,
    int? quantity,
    String? start,
    String? end,
    String? description,
    List<MaterialUsedByTask>? materials
  }){
    return ContractTask(
      id: id ?? this.id,
      work: work ?? this.work,
      gardenName: gardenName ?? gardenName,
      quantity: quantity ?? this.quantity,
      season: season ?? this.season,
      start: start ?? this.start,
      description:  description ?? this.description,
        materials: materials ?? this.materials
    );
  }
  factory ContractTask.fromJson(Map<String, dynamic> json) =>
      _$ContractTaskFromJson(json);

  Map<String, dynamic> toJson() => _$ContractTaskToJson(this);
}
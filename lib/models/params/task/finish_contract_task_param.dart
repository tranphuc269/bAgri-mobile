
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'finish_contract_task_param.g.dart';


@JsonSerializable()
class FinishContractTaskParam {
  List<MaterialUsedByTask>? materials;
  FinishContractTaskParam({
     this.materials
  });

  FinishContractTaskParam copyWith({
    List<MaterialUsedByTask>? materials,
  }) {
    return FinishContractTaskParam(
        materials: materials?? this.materials
    );
  }

  factory FinishContractTaskParam.fromJson(Map<String, dynamic> json) =>
      _$FinishContractTaskParamFromJson(json);

  Map<String, dynamic> toJson() => _$FinishContractTaskParamToJson(this);
}

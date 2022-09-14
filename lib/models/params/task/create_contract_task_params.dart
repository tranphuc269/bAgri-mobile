import 'package:flutter_base/models/entities/contract_work/contract_work.dart';
import 'package:flutter_base/models/entities/garden/garden_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'create_contract_task_params.g.dart';
@JsonSerializable()
class CreateContractTaskParam {
  ContractWorkEntity ? work;
  String? seasonId;
  GardenEntity? garden;
  int? quantity;
  String? description;

  CreateContractTaskParam({
    this.work,
    this.seasonId,
    this.garden,
    this.quantity,
    this.description
  });

  CreateContractTaskParam copyWith({
    ContractWorkEntity? work,
    String? seasonId,
    GardenEntity? garden,
    int? quantity,
    String? description
  }) {
    return CreateContractTaskParam(
      work: work ?? this.work,
      seasonId: seasonId ?? this.seasonId,
      garden: garden ?? this.garden,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description
    );
  }

  factory CreateContractTaskParam.fromJson(Map<String, dynamic> json) =>
      _$CreateContractTaskParamFromJson(json);

  Map<String, dynamic> toJson() => _$CreateContractTaskParamToJson(this);
}

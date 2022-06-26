import 'package:flutter_base/models/entities/process/stage_entity.dart';
import 'package:flutter_base/models/entities/tree/list_tree_response.dart';
import 'package:json_annotation/json_annotation.dart';

// part 'list_process.g.dart';

// @JsonSerializable()
// class ListProcessResponse {
//   @JsonKey()
//   String? status;
//   @JsonKey()
//   ProcessDataEntity? data;
//
//   ListProcessResponse({
//     this.status,
//     this.data,
//   });
//
//   ListProcessResponse copyWith({
//     String? status,
//     ProcessDataEntity? data,
//   }) {
//     return ListProcessResponse(
//       status: status ?? this.status,
//       data: data ?? this.data,
//     );
//   }
//
//   factory ListProcessResponse.fromJson(json) =>
//       _$ListProcessResponseFromJson(json);
//   Map<String, dynamic> toJson() => _$ListProcessResponseToJson(this);
// }

// @JsonSerializable()
class ProcessDataEntity {
  // @JsonKey()
  List<ProcessEntity>? processes;

  ProcessDataEntity({
    this.processes,
  });

  ProcessDataEntity copyWith({
    List<ProcessEntity>? processes,
  }) {
    return ProcessDataEntity(
      processes: processes ?? this.processes,
    );
  }

  factory ProcessDataEntity.fromJson(dynamic json) {
    List<ProcessEntity> list = [];
    for(var item in json){
      ProcessEntity processEntity = ProcessEntity.fromJson(item);
      list.add(processEntity);
    }
    return ProcessDataEntity(processes: list);
  }
}

// @JsonSerializable()
class ProcessEntity {
  // @JsonKey()
  String? process_id;

  // @JsonKey()
  String? name;

  // @JsonKey()
  List<TreeEntity>? trees;

  // @JsonKey()
  List<StageEntity>? stages;

  factory ProcessEntity.fromJson(Map<String, dynamic> json) {
    ProcessEntity processEntity = ProcessEntity(
      process_id: json['_id'] as String?,
      name: json['name'] as String?,
      trees: (json['trees'] as List<dynamic>?)
          ?.map((e) => TreeEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      stages: (json['phases'] as List<dynamic>?)
          ?.map((e) => StageEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    return processEntity;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': this.process_id,
        'name': this.name,
        'trees': this.trees!.map((e) => e.toJson()).toList(),
        'phases': this.stages!.map((e) => e.toJson()).toList(),
      };

  ProcessEntity({
    this.process_id,
    this.name,
    this.trees,
    this.stages,
  });

  ProcessEntity copyWith({
    String? process_id,
    String? name,
    List<TreeEntity>? trees,
    List<StageEntity>? stages,
  }) {
    return ProcessEntity(
      process_id: process_id ?? this.process_id,
      name: name ?? this.name,
      trees: trees ?? this.trees,
      stages: stages ?? this.stages,
    );
  }
}

import 'package:flutter_base/models/entities/process/stage_entity.dart';
import 'package:flutter_base/models/entities/season/stage_season.dart';
import 'package:flutter_base/models/entities/tree/list_tree_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'process_season.g.dart';
@JsonSerializable()
class ProcessSeason {
  @JsonKey(name: '_id')
  String? process_id;
  String? name;
  @JsonKey(name: 'phases')
  List<StageSeason>? stages;


  ProcessSeason({
    this.process_id,
    this.name,
    this.stages,
  });

  ProcessSeason copyWith({
    String? process_id,
    String? name,
    List<StageSeason>? stages,
  }) {
    return ProcessSeason(
        process_id: process_id ?? this.process_id,
        name: name ?? this.name,
        stages: stages ?? this.stages,
    );
  }
  factory ProcessSeason.fromJson(Map<String, dynamic> json) => _$ProcessSeasonFromJson(json);

  Map<String, dynamic> toJson() =><String, dynamic>{
    if (this.process_id != null)  '_id': this.process_id,
    'name': this.name,
    'phases': this.stages,
  };
}

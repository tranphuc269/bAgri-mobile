import 'package:flutter_base/models/entities/garden/garden_entity.dart';
import 'package:flutter_base/models/entities/season/process_season.dart';
import 'package:flutter_base/models/entities/tree/list_tree_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'season_entity.g.dart';

@JsonSerializable()
class SeasonEntity {
  @JsonKey(name: '_id')
  String? seasonId;
  String? name;
  @JsonKey(name: 'garden')
  GardenEntityResponseFromZoneId? gardenEntity;
  String? gardenId;
  ProcessSeason? process;
  String? tree;
  @JsonKey(name: 'start')
  String? start_date;
  @JsonKey(name: 'end')
  String? end_date;
  int? treeQuantity;
  String? startUrl;
  String? endUrl;
  int? turnover;

  factory SeasonEntity.fromJson(Map<String, dynamic> json) =>
      SeasonEntity(
        seasonId: json['_id'] as String?,
        name: json['name'] as String?,
        gardenId: json['gardenId'] as String?,
        gardenEntity: json['garden'] == null
            ? null
            : GardenEntityResponseFromZoneId.fromJson(json['garden'] as Map<String, dynamic>),
        process: json['process'] == null
            ? null
            : ProcessSeason.fromJson(json['process'] as Map<String, dynamic>),
        tree:json['tree'] as String?,
        start_date: json['start'] as String?,
        end_date: json['end'] as String?,
        treeQuantity: json['treeQuantity'] as int?,
        turnover: json['turnover'] as int?
      );
  Map<String, dynamic> toJson() => <String, dynamic>{
    if(this.seasonId != null) '_id': this.seasonId,
    'name': this.name,
    'gardenId': this.gardenId ?? this.gardenEntity?.garden_id,
    'process': this.process,
    'tree': this.tree,
    'start': this.start_date,
    'end': this.end_date,
    'treeQuantity': this.treeQuantity,
    if(this.turnover != null) 'turnover': this.turnover
  };

  SeasonEntity copyWith({
    String? seasonId,
    String? name,
    GardenEntityResponseFromZoneId? gardenEntity,
    String? gardenId,
    ProcessSeason? process,
    String? tree,
    String? start_date,
    String? end_date,
    int? treeQuantity,
    int? turnover,
  }) {
    return SeasonEntity(
      seasonId: seasonId ?? this.seasonId,
      name: name ?? this.name,
      gardenEntity: gardenEntity ?? this.gardenEntity,
      gardenId: gardenId ?? this.gardenId,
      process: process ?? this.process,
      tree: tree ?? this.tree,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      treeQuantity: treeQuantity ?? this.treeQuantity,
      turnover:turnover?? this.turnover
    );
  }

  SeasonEntity({
    this.seasonId,
    this.name,
    this.gardenEntity,
    this.gardenId,
    this.process,
    this.tree,
    this.start_date,
    this.end_date,
    this.treeQuantity,
    this.turnover
  });
}

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
  int? turnover;
  GardenEntityInSeason? garden;
  ProcessSeason? process;
  TreeEntity? tree;
  @JsonKey(name: 'start')
  String? start_date;
  @JsonKey(name: 'end')
  String? end_date;
  int? treeQuantity;

  factory SeasonEntity.fromJson(Map<String, dynamic> json) =>
      SeasonEntity(
        seasonId: json['_id'] as String?,
        name: json['name'] as String?,
        garden: json['garden'] == null
            ? null
            : GardenEntityInSeason.fromJson(json['garden'] as Map<String, dynamic>),
        process: json['process'] == null
            ? null
            : ProcessSeason.fromJson(json['process'] as Map<String, dynamic>),
        tree:TreeEntity(name: json['tree']),
        start_date: json['start'] as String?,
        end_date: json['end'] as String?,
        treeQuantity: json['treeQuantity'] as int?,
        turnover : json['turnover'] as int?
      );
  Map<String, dynamic> toJson() => <String, dynamic>{
    if(this.seasonId != null) '_id': this.seasonId,
    'name': this.name,
    'gardenId': this.garden?.garden_id,
    'process': this.process,
    'tree': this.tree?.name,
    'start': this.start_date,
    'end': this.end_date,
    'treeQuantity': this.treeQuantity,
    'turnover': this.turnover,
  };

  SeasonEntity copyWith({
    String? seasonId,
    String? name,
    int? turnover,
    GardenEntityInSeason? garden,
    ProcessSeason? process,
    TreeEntity? tree,
    String? start_date,
    String? end_date,
    int? treeQuantity,
  }) {
    return SeasonEntity(
      turnover: turnover ?? this.turnover,
      seasonId: seasonId ?? this.seasonId,
      name: name ?? this.name,
      garden: garden ?? this.garden,
      process: process ?? this.process,
      tree: tree ?? this.tree,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      treeQuantity: treeQuantity ?? this.treeQuantity,
    );
  }

  SeasonEntity({
    this.seasonId,
    this.name,
    this.garden,
    this.process,
    this.tree,
    this.turnover,
    this.start_date,
    this.end_date,
    this.treeQuantity,
  });
}

@JsonSerializable()
class NewSeasonEntity {
  @JsonKey(name: '_id')
  String? seasonId;
  String? name;
  String? gardenId;
  ProcessSeason? process;
  TreeEntity? tree;
  @JsonKey(name: 'start')
  String? start_date;
  @JsonKey(name: 'end')
  String? end_date;
  int? treeQuantity;

  factory NewSeasonEntity.fromJson(Map<String, dynamic> json) =>
      NewSeasonEntity(
        seasonId: json['_id'] as String?,
        name: json['name'] as String?,
        gardenId: json['gardenId'] as String?,
        process: json['process'] == null
            ? null
            : ProcessSeason.fromJson(json['process'] as Map<String, dynamic>),
        tree:TreeEntity(name: json['tree']),
        start_date: json['start'] as String?,
        end_date: json['end'] as String?,
        treeQuantity: json['treeQuantity'] as int?,
      );
  Map<String, dynamic> toJson() => <String, dynamic>{
    if(this.seasonId != null) '_id': this.seasonId,
    'name': this.name,
    'gardenId': this.gardenId,
    'process': this.process,
    'tree': this.tree?.name,
    'start': this.start_date,
    'end': this.end_date,
    'treeQuantity': this.treeQuantity,
  };

  NewSeasonEntity copyWith({
    String? seasonId,
    String? name,
    String? gardenId,
    ProcessSeason? process,
    TreeEntity? tree,
    String? start_date,
    String? end_date,
    int? treeQuantity,
  }) {
    return NewSeasonEntity(
      seasonId: seasonId ?? this.seasonId,
      name: name ?? this.name,
      gardenId: gardenId ?? this.gardenId,
      process: process ?? this.process,
      tree: tree ?? this.tree,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      treeQuantity: treeQuantity ?? this.treeQuantity,
    );
  }

  NewSeasonEntity({
    this.seasonId,
    this.name,
    this.gardenId,
    this.process,
    this.tree,
    this.start_date,
    this.end_date,
    this.treeQuantity,
  });
}


import 'package:flutter_base/models/entities/season/process_season.dart';
import 'package:flutter_base/models/entities/tree/list_tree_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'season_entity.g.dart';

@JsonSerializable()
class SeasonEntity {
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

  factory SeasonEntity.fromJson(Map<String, dynamic> json) =>
      _$SeasonEntityFromJson(json);
  Map<String, dynamic> toJson() => _$SeasonEntityToJson(this);

  SeasonEntity copyWith({
    String? seasonId,
    String? name,
    String? gardenId,
    ProcessSeason? process,
    TreeEntity? tree,
    String? start_date,
    String? end_date,
    int? treeQuantity,
  }) {
    return SeasonEntity(
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

  SeasonEntity({
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

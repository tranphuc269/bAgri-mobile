import 'package:flutter_base/models/entities/material/material_task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'temporary_task.g.dart';

// @JsonSerializable()
class TemporaryTask {
  // @JsonKey(name: '_id')
  String? temporaryTaskId;
  // String? seasonId;
  String? season;
  String? description;
  String? title;
  List<DailyTask>? dailyTasks;

  TemporaryTask(
      {this.season,
      /*  this.seasonId,*/
      this.title,
      this.description,
      this.temporaryTaskId,
      this.dailyTasks});

  TemporaryTask copyWith(
      {String? temporaryTaskId,
      // String? season,
        String? seasonId,
      String? title,
      String? description,
      List<DailyTask>? dailyTasks}) {
    return TemporaryTask(
        temporaryTaskId: temporaryTaskId ?? this.temporaryTaskId,
        // season: season ?? this.season,
        title: title ?? this.title,
        season: season ?? this.season,
        description: description ?? this.description,
        dailyTasks: dailyTasks ?? this.dailyTasks,
      );
  }

  factory TemporaryTask.fromJson(Map<String, dynamic> json) =>
      TemporaryTask(
        // season: json['season'] as String?,
        season: json['season'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        temporaryTaskId: json['_id'] as String?,
        dailyTasks: (json['dailyTasks'] as List<dynamic>?)
            ?.map((e) => DailyTask.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() =>  <String, dynamic>{
    '_id': this.temporaryTaskId,
    'seasonId': this.season,
    'description': this.description,
    'title': this.title,
    'dailyTasks': this.dailyTasks,
  };
}

@JsonSerializable()
class TemporaryTaskUpdate{
  @JsonKey(name: '_id')
  String? temporaryTaskId;
  @JsonKey(name: 'seasonId')
  String? season;
  String? description;
  String? title;
  List<DailyTask>? dailyTasks;

  TemporaryTaskUpdate(
      {this.season,
        this.title,
        this.description,
        this.temporaryTaskId,
        this.dailyTasks});

  TemporaryTaskUpdate copyWith(
      {String? temporaryTaskId,
        String? season,
        String? title,

        String? description,
        List<DailyTask>? dailyTasks}) {
    return TemporaryTaskUpdate(
      temporaryTaskId: temporaryTaskId ?? this.temporaryTaskId,
      season: season ?? this.season,
      title: title ?? this.title,
      description: description ?? this.description,
      dailyTasks: dailyTasks ?? this.dailyTasks,
    );
  }

  factory TemporaryTaskUpdate.fromJson(Map<String, dynamic> json) =>
      _$TemporaryTaskUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$TemporaryTaskUpdateToJson(this);
}

@JsonSerializable()
class DailyTask {
  @JsonKey(name: '_id')
  String? dailyTaskId;
  String? date;
  String? title;
  int? fee;
  int? workerQuantity;
  List<MaterialTask>? materials;

  DailyTask(
      {this.title,
      this.dailyTaskId,
      this.date,
      this.fee,
      this.workerQuantity,
      this.materials});

  DailyTask copyWith(
      {String? dailyTaskId,
      String? date,
      String? title,
      int? fee,
      int? workerQuantity,
      List<MaterialTask>? material}) {
    return DailyTask(
        dailyTaskId: dailyTaskId,
        date: date,
        title: title,
        fee: fee,
        workerQuantity: workerQuantity,
        materials: material);
  }

  factory DailyTask.fromJson(Map<String, dynamic> json) =>
      _$DailyTaskFromJson(json);

  Map<String, dynamic> toJson() => _$DailyTaskToJson(this);
}

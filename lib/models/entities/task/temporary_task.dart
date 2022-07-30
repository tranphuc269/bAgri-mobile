import 'package:flutter_base/models/entities/material/material_task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'temporary_task.g.dart';

@JsonSerializable()
class TemporaryTask {
  @JsonKey(name: '_id')
  String? temporaryTaskId;
  String? garden;
  String? description;
  String? seasonId;
  String? title;
  List<DailyTask>? dailyTasks;

  TemporaryTask(
      {this.garden,
      this.title,
        this.seasonId,
      this.description,
      this.temporaryTaskId,
      this.dailyTasks});

  TemporaryTask copyWith(
      {String? temporaryTaskId,
      String? garden,
      String? title,
      String? seasonId,
      String? description,
      List<DailyTask>? dailyTasks}) {
    return TemporaryTask(
        temporaryTaskId: temporaryTaskId ?? this.temporaryTaskId,
        garden: garden ?? this.garden,
        title: title ?? this.title,
        seasonId: seasonId ?? this.seasonId,
        description: description ?? this.description,
        dailyTasks: dailyTasks ?? this.dailyTasks,
      );
  }

  factory TemporaryTask.fromJson(Map<String, dynamic> json) =>
      TemporaryTask(
        garden: json['garden'] as String?,
        title: json['title'] as String?,
        seasonId: json['season'] as String?,
        description: json['description'] as String?,
        temporaryTaskId: json['_id'] as String?,
        dailyTasks: (json['dailyTasks'] as List<dynamic>?)
            ?.map((e) => DailyTask.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => _$TemporaryTaskToJson(this);
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

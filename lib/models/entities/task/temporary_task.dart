import 'package:flutter_base/models/entities/material/material_task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'temporary_task.g.dart';

@JsonSerializable()
class TemporaryTask {
  @JsonKey(name: '_id')
  String? temporaryTaskId;
  String? garden;
  String? description;
  String? title;
  List<DailyTask>? dailyTasks;

  TemporaryTask(
      {this.garden,
      this.title,
      this.description,
      this.temporaryTaskId,
      this.dailyTasks});

  TemporaryTask copyWith(
      {String? temporaryTaskId,
      String? garden,
      String? title,

      String? description,
      List<DailyTask>? dailyTasks}) {
    return TemporaryTask(
        temporaryTaskId: temporaryTaskId ?? this.temporaryTaskId,
        garden: garden ?? this.garden,
        title: title ?? this.title,

        description: description ?? this.description,
        dailyTasks: dailyTasks ?? this.dailyTasks,
      );
  }

  factory TemporaryTask.fromJson(Map<String, dynamic> json) =>
      _$TemporaryTaskFromJson(json);

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
  List<MaterialTask>? material;

  DailyTask(
      {this.title,
      this.dailyTaskId,
      this.date,
      this.fee,
      this.workerQuantity,
      this.material});

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
        material: material);
  }

  factory DailyTask.fromJson(Map<String, dynamic> json) =>
      _$DailyTaskFromJson(json);

  Map<String, dynamic> toJson() => _$DailyTaskToJson(this);
}

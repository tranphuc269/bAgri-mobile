import 'package:flutter_base/models/entities/material/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'temporary_task.g.dart';

@JsonSerializable()
class TemporaryTask {
  @JsonKey(name: '_id')
  String? temporaryTaskId;
  String? gardenName;
  String? from;
  String? to;
  String? title;
  List<DailyTask>? dailyTasks;

  TemporaryTask(
      {this.gardenName, this.title, this.from, this.to, this.temporaryTaskId, this.dailyTasks});

  TemporaryTask copyWith({
    String? temporaryTaskId,
    String? gardenName,
    String? title,
    String? to,
    String? from,
    List<DailyTask>? dailyTasks
  }) {
    return TemporaryTask(
        temporaryTaskId: temporaryTaskId ?? this.temporaryTaskId,
        gardenName: gardenName ?? this.gardenName,
        title: title ?? this.title,
        from: from ?? this.from,
        dailyTasks: dailyTasks ?? this.dailyTasks,
        to: to ?? this.to);
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
  List<Material>? material;


  DailyTask(
      {this.title, this.dailyTaskId, this.date, this.fee, this.workerQuantity, this.material});

  DailyTask copyWith(
      {String? dailyTaskId,
      String? date,
      String? title,
      int? fee,
      int? workerQuantity,
      List<Material>? material}) {
    return DailyTask(
        date: date, title: title, fee: fee, workerQuantity: workerQuantity, material: material);
  }
  factory DailyTask.fromJson(Map<String, dynamic> json) => _$DailyTaskFromJson(json);
  Map<String, dynamic> toJson() => _$DailyTaskToJson(this);
}

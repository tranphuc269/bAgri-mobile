import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/enums/load_status.dart';

class TemporaryTaskListState extends Equatable {
  LoadStatus? loadStatus;
  List<dynamic>? temporaryTaskList;
  @override
  List<dynamic> get props => [
    loadStatus,
    temporaryTaskList
  ];
}
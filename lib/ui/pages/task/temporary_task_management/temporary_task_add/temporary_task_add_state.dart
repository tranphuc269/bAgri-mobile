part of 'temporary_task_add_cubit.dart';
class TemporaryTaskAddState extends Equatable{

  LoadStatus? loadStatus;
  TemporaryTask? temporaryTask;
  String? treePlaceQuantityMax;
  GardenEntity? gardenEntity;
  String? startTime;

  bool get buttonEnabled {
    if (startTime == null ||
        gardenEntity == null )
      return false;
    else
      return true;
  }

  @override
  List<Object?> get props => [
    loadStatus,

  ];

}
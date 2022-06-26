part of 'home_garden_manager_cubit.dart';


class HomeGardenManagerState extends Equatable {
  LoadStatus? getEventStatus;
  List<StepEntityResponseByDay>? eventsOfDays;

  HomeGardenManagerState({this.getEventStatus, this.eventsOfDays});

  HomeGardenManagerState copyWith({
    LoadStatus? getEventStatus,
    List<StepEntityResponseByDay>? eventsOfDays,
}){
    return HomeGardenManagerState(
      getEventStatus: getEventStatus ?? this.getEventStatus,
      eventsOfDays: eventsOfDays ?? this.eventsOfDays
    );
  }

  @override
  List<Object?> get props => [this.getEventStatus, this.eventsOfDays];
}

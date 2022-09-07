part of "end_season_cubit.dart";

class EndSeasonState extends Equatable {
  LoadStatus? loadStatus;
  List<TurnoverEntity>? listTurnover;

  @override
  List<Object?> get props => [loadStatus, listTurnover];

  EndSeasonState({this.loadStatus, this.listTurnover});

  EndSeasonState copyWith(
      {LoadStatus? loadStatus, List<TurnoverEntity>? listTurnover}) {
    return EndSeasonState(
        loadStatus: loadStatus ?? this.loadStatus,
        listTurnover: listTurnover ?? this.listTurnover);
  }
}

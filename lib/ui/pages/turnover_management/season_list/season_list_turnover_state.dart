part of 'season_list_turnover_cubit.dart';

class SeasonListTurnoverState extends Equatable {
  LoadStatus? loadStatus;
  List<SeasonEntity>? seasonList;

  @override
  List<dynamic> get props => [
    loadStatus,
    seasonList,
  ];

  SeasonListTurnoverState({
    this.loadStatus,
    this.seasonList,
  });

  SeasonListTurnoverState copyWith({
    LoadStatus? loadStatus,
    List<SeasonEntity>? seasonList,
  }) {
    return SeasonListTurnoverState(
      loadStatus: loadStatus ?? this.loadStatus,
      seasonList: seasonList ?? this.seasonList,
    );
  }
}

part of 'season_list_management_cubit.dart';

class SeasonListForTaskState extends Equatable {
  LoadStatus? loadStatus;
  List<SeasonEntity>? seasonList;

  @override
  List<dynamic> get props => [
        loadStatus,
        seasonList,
      ];

  SeasonListForTaskState({
    this.loadStatus,
    this.seasonList,
  });

  SeasonListForTaskState copyWith({
    LoadStatus? loadStatus,
    List<SeasonEntity>? seasonList,
  }) {
    return SeasonListForTaskState(
      loadStatus: loadStatus ?? this.loadStatus,
      seasonList: seasonList ?? this.seasonList,
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/season_repository.dart';

part 'season_list_management_state.dart';

class SeasonListForTaskCubit extends Cubit<SeasonListForTaskState> {
  SeasonRepository seasonRepository;
  SeasonListForTaskCubit({required this.seasonRepository})
      : super(SeasonListForTaskState());

  Future<void> getListSeason() async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      final  result =
          await seasonRepository.getListSeasonData();

      emit(state.copyWith(
          seasonList: result/*.data!.seasons*/, loadStatus: LoadStatus.SUCCESS));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      print(e);
    }
  }

  Future<bool> deleteSeason(String seasonId) async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      final result = await seasonRepository.deleteSeason(seasonId);
      emit(state.copyWith(loadStatus: LoadStatus.SUCCESS));
      return true;
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      return false;
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/season_repository.dart';

part 'season_list_turnover_state.dart';

class SeasonListTurnoverCubit extends Cubit<SeasonListTurnoverState> {
  SeasonRepository seasonRepository;
  SeasonListTurnoverCubit({required this.seasonRepository})
      : super(SeasonListTurnoverState());

  Future<void> getListSeason() async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      final result = await seasonRepository.getListSeasonData();
      if(result != null){
        emit(state.copyWith(
            seasonList: result/*.data!.seasons*/, loadStatus: LoadStatus.SUCCESS));
      }
      else{
        emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      }
    } catch (e) {
      print("error");
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      print(e);
    }
  }

}

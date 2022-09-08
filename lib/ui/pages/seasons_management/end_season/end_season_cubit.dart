import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/models/entities/turnover/turnover_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/season_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'end_season_state.dart';
class EndSeasonCubit extends Cubit<EndSeasonState>{
  SeasonRepository seasonRepository;
  EndSeasonCubit({required this.seasonRepository})
      : super(EndSeasonState());

  Future<void> endSeason(String seasonId, List<TurnoverEntity> turnovers) async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      var result = await seasonRepository.endSeason(seasonId, turnovers);
      emit(state.copyWith(
        loadStatus: LoadStatus.SUCCESS, /*season: result*/ /*.data!.season!*/
      ));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
    }
  }
  void addTurnover({TurnoverEntity? turnoverEntity}){
    state.listTurnover!.add(turnoverEntity!);
  }
}

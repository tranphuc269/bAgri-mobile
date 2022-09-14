import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/season_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../widgets/app_snackbar.dart';

part 'season_management_state.dart';

class SeasonManagementCubit extends Cubit<SeasonManagementState> {
  SeasonRepository seasonRepository;
  SeasonManagementCubit({required this.seasonRepository})
      : super(SeasonManagementState());

  final showMessageController = PublishSubject<SnackBarMessage>();

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }


  Future<void> getListSeason() async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      final result = await seasonRepository.getListSeasonData();
        emit(state.copyWith(seasonList: result, loadStatus: LoadStatus.SUCCESS));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      showMessageController.sink.add(SnackBarMessage(
          message: 'Đã có lỗi xảy ra',
          type: SnackBarType.ERROR
      ));
    }
  }

  Future<void> deleteSeason(String seasonId) async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
     await seasonRepository.deleteSeason(seasonId);
      emit(state.copyWith(loadStatus: LoadStatus.SUCCESS));
      showMessageController.sink.add(SnackBarMessage(
          message: 'Xóa mùa vụ thành công',
          type: SnackBarType.SUCCESS
      ));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      showMessageController.sink.add(SnackBarMessage(
          message: 'Đã có lỗi xảy ra',
          type: SnackBarType.ERROR
      ));
    }
  }
}

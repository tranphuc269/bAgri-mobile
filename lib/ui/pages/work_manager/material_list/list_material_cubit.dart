import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/generated/l10n.dart';
import 'package:flutter_base/models/entities/process/list_process.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/process_repository.dart';
import 'package:flutter_base/ui/widgets/app_snackbar.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:rxdart/rxdart.dart';

part 'list_material_state.dart';

class MaterialListCubit extends Cubit<ListMaterialState> {
  ProcessRepository? processRepository;

  MaterialListCubit({this.processRepository}) : super(ListMaterialState());

  final showMessageController = PublishSubject<SnackBarMessage>();

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }

  void fetchListProcess() async {
    emit(state.copyWith(getProcessStatus: LoadStatus.LOADING));
    try {
      final response = await processRepository!.getListProcessData();
      if (response != null) {
        emit(state.copyWith(
          getProcessStatus: LoadStatus.SUCCESS,
          listData: response./*data!.*/processes,
        ));
      } else {
        emit(state.copyWith(getProcessStatus: LoadStatus.FAILURE));
      }
      emit(state.copyWith(getProcessStatus: LoadStatus.SUCCESS));
    } catch (error) {
      emit(state.copyWith(getProcessStatus: LoadStatus.FAILURE));
    }
  }

  Future<void> deleteProcess(String? processId) async {
    emit(state.copyWith(deleteMaterialStatus: LoadStatus.LOADING));
    try {
      final response =
      await processRepository!.deleteProcess(processId: processId);
      emit(state.copyWith(deleteMaterialStatus: LoadStatus.SUCCESS));
    } catch (e) {
      emit(state.copyWith(deleteMaterialStatus: LoadStatus.FAILURE));
      showMessageController.sink.add(SnackBarMessage(
        message: S.current.error_occurred,
        type: SnackBarType.ERROR,
      ));
      return;
    }
  }
}

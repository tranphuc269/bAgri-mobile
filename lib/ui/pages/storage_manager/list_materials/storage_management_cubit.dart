import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/material_repository.dart';
import 'package:flutter_base/ui/widgets/app_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'storage_management_state.dart';

class StorageManagementCubit extends Cubit<StorageManagementState> {
  MaterialRepository? materialRepository;

  StorageManagementCubit({
    this.materialRepository,
    storageManagement,
  }) : super(StorageManagementState());

  final showMessageController = PublishSubject<SnackBarMessage>();

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }

  void fetchListMaterials() async {
    emit(state.copyWith(loadingStatus: LoadStatus.LOADING));
    try {
      final response = await materialRepository!.getListMaterial();
      if (response != null) {
        emit(state.copyWith(
          loadingStatus: LoadStatus.SUCCESS,
          listMaterials: response,
        ));
      } else {
        emit(state.copyWith(loadingStatus: LoadStatus.FAILURE));
      }
      emit(state.copyWith(loadingStatus: LoadStatus.SUCCESS));
    } catch (error) {
      emit(state.copyWith(loadingStatus: LoadStatus.FAILURE));
    }
  }

  deleteMaterial(String materialId) async {
    emit(state.copyWith(loadingStatus: LoadStatus.LOADING));
    try {
      final response = await materialRepository!.deleteMaterial(materialId);
      emit(state.copyWith(loadingStatus: LoadStatus.SUCCESS));
    } catch (e) {
      emit(state.copyWith(loadingStatus: LoadStatus.FAILURE));
      return;
    }
  }
}

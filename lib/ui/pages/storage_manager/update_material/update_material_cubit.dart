import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/material_repository.dart';
import 'package:flutter_base/ui/widgets/app_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'update_material_state.dart';
class UpdateMaterialCubit extends Cubit<UpdateMaterialState>{
  MaterialRepository? materialRepository;

  final showMessageController = PublishSubject<SnackBarMessage>();

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }

  UpdateMaterialCubit({
    this.materialRepository
  }) : super(UpdateMaterialState());

  void changeName(String name) {
    emit(state.copyWith(name: name));
  }
  void changeUnit(String unit) {
    emit(state.copyWith(unit: unit));
  }
  void changeUnitPrice(int unitPrice) {
    emit(state.copyWith(unitPrice: unitPrice));
  }
  void changeQuantity(int quantity) {
    emit(state.copyWith(quantity: quantity));
  }

  void updateMaterial(String materialId) async{
    var material = {
      'name': state.name,
      'unitPrice': state.unitPrice,
      'unit': state.unit,
      'quantity': state.quantity
    };
    emit(state.copyWith(loadingStatus: LoadStatus.LOADING));
    try {
      final response = await materialRepository!.updateMaterial(materialId, material);
      if (response != null) {
        emit(state.copyWith(loadingStatus: LoadStatus.SUCCESS));
      } else {
        emit(state.copyWith(loadingStatus: LoadStatus.FAILURE));
      }
    } catch (e) {
      emit(state.copyWith(loadingStatus: LoadStatus.FAILURE));
      return;
    }
  }
}
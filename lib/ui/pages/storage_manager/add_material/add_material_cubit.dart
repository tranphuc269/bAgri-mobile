import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/material_repository.dart';
import 'package:flutter_base/ui/widgets/app_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';


part 'add_material_state.dart';

class AddMaterialCubit extends Cubit<AddMaterialState>{
  MaterialRepository? materialRepository;

  final showMessageController = PublishSubject<SnackBarMessage>();

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }

  AddMaterialCubit({
    this.materialRepository
  }) : super(AddMaterialState());

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

  void createMaterial() async{
    MaterialEntity material = MaterialEntity(
      name: state.name,
      unitPrice: state.unitPrice,
      unit: state.unit,
      quantity: state.quantity
    );
    emit(state.copyWith(loadingStatus: LoadStatus.LOADING));
    try {
      final response = await materialRepository!.createMaterial(material);
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
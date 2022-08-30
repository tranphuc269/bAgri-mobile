import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/garden/garden_detail.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/models/params/garden/update_garden_params.dart';
import 'package:flutter_base/repositories/garden_repository.dart';

import 'package:flutter_base/ui/widgets/app_snackbar.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

part 'garden_update_state.dart';

class GardenUpdateCubit extends Cubit<GardenUpdateState> {
  GardenRepository? gardenRepository;

  GardenUpdateCubit({
    this.gardenRepository,
  }) : super(GardenUpdateState());

  final showMessageController = PublishSubject<SnackBarMessage>();

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }

  void changeName(String name) {
    emit(state.copyWith(name: name));
  }

  void changeArea(String area) {
    emit(state.copyWith(area: area));
  }
  void changeTreePlaceQuantity(String treePlaceQuantity){
    emit(state.copyWith(treePlaceQuantity: treePlaceQuantity));
  }
  void changeAreaUnit(String areaUnit){
    emit(state.copyWith(areaUnit: areaUnit ));
  }
  void changeManagerUsername(String managerUsername){
    emit(state.copyWith(managerUsername: managerUsername));
  }
  void changeManagerPhone(String managerPhone){
    emit(state.copyWith(managerPhone: managerPhone));
  }


  void changeManagerId(String value) {
    emit(state.copyWith(managerUsername: value));
  }

  // void createGarden(String areaUnit, String zoneName, String treePlaceQuantity) async {
  //   emit(state.copyWith(createGardenStatus: LoadStatus.LOADING));
  //   try {
  //     final param = CreateGardenParam(
  //         name: state.name,
  //         area: num.parse(state.area.toString()),
  //         areaUnit: areaUnit,
  //         treePlaceQuantity: num.parse(treePlaceQuantity),
  //         managerUsername: state.managerUsername,
  //         zoneName: zoneName
  //     );
  //     final response = await gardenRepository!.createGarden(param: param);
  //
  //     if (response != null) {
  //       emit(state.copyWith(createGardenStatus: LoadStatus.SUCCESS));
  //     } else {
  //       emit(state.copyWith(createGardenStatus: LoadStatus.FAILURE));
  //     }
  //   } catch (e) {
  //     logger.e(e);
  //     emit(state.copyWith(createGardenStatus: LoadStatus.FAILURE));
  //     return;
  //   }
  // }
  void updateGarden(String? gardenId, String? unit, String? gardenArea, String? treePlaceQuantity, String? zoneName ) async{
    emit(state.copyWith(updateGardenStatus: LoadStatus.LOADING));
    final param = UpdateGardenParam(
      name: state.name,
      areaUnit: unit,
      area: num.parse(gardenArea!),
      treePlaceQuantity: num.parse(treePlaceQuantity!),
      managerPhone: state.managerPhone,
      zoneName: zoneName,
    );
      try{
        final response = await gardenRepository!.updateGarden(gardenId: gardenId, param: param);
        print(response);
        if(response != null){
          emit(state.copyWith(updateGardenStatus: LoadStatus.SUCCESS));
        }else{
          emit(state.copyWith(updateGardenStatus: LoadStatus.FAILURE));
        }
    }catch (e){
        emit(state.copyWith(updateGardenStatus: LoadStatus.FAILURE));
      throw e;
    }
  }
  void getGardenData(String? gardenId) async{
    emit(state.copyWith(getGardenDataStatus: LoadStatus.LOADING));
    try {
      final response = await gardenRepository!.getGardenDataById(
          gardenId: gardenId);
      print(response);
      if(response !=  null ){
       print(response);
        emit(state.copyWith(getGardenDataStatus: LoadStatus.SUCCESS,
            gardenData: response));
      }else{
        emit(state.copyWith(getGardenDataStatus: LoadStatus.FAILURE));
      }
    }catch (e){
      emit(state.copyWith(getGardenDataStatus: LoadStatus.FAILURE));
      throw e;
    }
  }
  Future <void> getListManager() async{
    emit(state.copyWith(getListManagerStatus: LoadStatus.LOADING));
    try {
      final response = await gardenRepository!.getListAcounts();
      List<UserEntity> managers = [];
      response.forEach((element) {
        if(element.role == "GARDEN_MANAGER"){
          managers.add(element);
          print(element.name);
        }
      });
      if (response != null) {
        emit(state.copyWith(getListManagerStatus: LoadStatus.SUCCESS, listManager: managers));
      } else {
        emit(state.copyWith(getListManagerStatus: LoadStatus.FAILURE));
      }
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(getListManagerStatus: LoadStatus.FAILURE));
      return;
    }
  }
}

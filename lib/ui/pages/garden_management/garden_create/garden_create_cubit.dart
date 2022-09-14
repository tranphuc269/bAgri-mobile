import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/models/params/garden/create_garden_params.dart';
import 'package:flutter_base/repositories/garden_repository.dart';

import 'package:flutter_base/ui/widgets/app_snackbar.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

part 'garden_create_state.dart';

class GardenCreateCubit extends Cubit<GardenCreateState> {
  GardenRepository? gardenRepository;

  GardenCreateCubit({
    this.gardenRepository,
  }) : super(GardenCreateState());

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
  void changeManagerPhone(String managerPhone){
    emit(state.copyWith(managerPhone: managerPhone));
  }


  void changeManagerId(String value) {
    emit(state.copyWith(managerPhone: value));
  }

  void createGarden(String areaUnit, String zoneName, String treePlaceQuantity) async {
    emit(state.copyWith(createGardenStatus: LoadStatus.LOADING));
    try {
      final param = CreateGardenParam(
        name: state.name,
        area: num.parse(state.area.toString()),
        areaUnit: areaUnit,
        treePlaceQuantity: num.parse(treePlaceQuantity),
        managerPhone: state.managerPhone,
        zoneName: zoneName
      );
      final response = await gardenRepository!.createGarden(param: param);

      if (response != null) {
        emit(state.copyWith(createGardenStatus: LoadStatus.SUCCESS));
        showMessageController.sink.add(SnackBarMessage(
            message: 'Tạo vườn mới thành công',
            type: SnackBarType.SUCCESS
        ));
      } else {
        emit(state.copyWith(createGardenStatus: LoadStatus.FAILURE));
      }
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(createGardenStatus: LoadStatus.FAILURE));
      showMessageController.sink.add(SnackBarMessage(
          message: 'Đã có lỗi xảy ra',
          type: SnackBarType.ERROR
      ));
      return;
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

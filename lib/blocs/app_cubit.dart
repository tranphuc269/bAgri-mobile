import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/configs/app_config.dart';
import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/models/entities/contract_work/contract_work.dart';
import 'package:flutter_base/models/entities/garden/garden_entity.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/models/entities/process/list_process.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/entities/tree/list_tree_response.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';
import 'package:flutter_base/models/entities/weather/weather_response.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/auth_repository.dart';
import 'package:flutter_base/repositories/contract_work_reponsitory.dart';
import 'package:flutter_base/repositories/garden_repository.dart';
import 'package:flutter_base/repositories/material_repository.dart';
import 'package:flutter_base/repositories/process_repository.dart';
import 'package:flutter_base/repositories/season_repository.dart';
import 'package:flutter_base/repositories/temporary_task_repository.dart';
import 'package:flutter_base/repositories/tree_repository.dart';
import 'package:flutter_base/repositories/user_repository.dart';
import 'package:flutter_base/repositories/weather_repository.dart';
import 'package:flutter_base/repositories/zone_repository.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  TreeRepository treeRepository;
  GardenRepository gardenRepository;
  ProcessRepository processRepository;
  AuthRepository authRepository;
  UserRepository userRepository;
  MaterialRepository materialRepository;
  ContractWorkRepositoy contractWorkRepository;
  TemporaryTaskRepository temporaryTaskRepository;
  WeatherRepository weatherRepository;
  ZoneRepository zoneRepository;
  ContractWorkRepositoy contractWorkRepositoy;
  SeasonRepository seasonRepository;

  AppCubit({
    required this.treeRepository,
    required this.authRepository,
    required this.processRepository,
    required this.gardenRepository,
    required this.userRepository,
    required this.weatherRepository,
    required this.zoneRepository,
    required this.contractWorkRepository,
    required this.materialRepository,
    required this.temporaryTaskRepository,
    required this.contractWorkRepositoy,
    required this.seasonRepository,
  }) : super(AppState());


  void getData() async {
    // await LoadJsonHelper.shared.load();
    // fetchListGarden();
    // fetchListProcess();
    // fetchListTree();
    // fetchListTask();
    // fetchListManager();
    getWeather();
  }


  Future<void> fetchListManager() async {
    emit(state.copyWith(getManagersStatus: LoadStatus.LOADING));
    try {
      final response = await authRepository.getListAcounts();
      print(response);
      emit(state.copyWith(
          getManagersStatus: LoadStatus.SUCCESS, managers: response));
    } catch (e) {
      emit(state.copyWith(getManagersStatus: LoadStatus.FAILURE));
    }
  }

  void fetchListTree() async {
    emit(state.copyWith(getTreeStatus: LoadStatus.LOADING));
    try {
      final response = await treeRepository.getListTreeData();
      print(response);
      if (response != null) {
        emit(state.copyWith(
          getTreeStatus: LoadStatus.SUCCESS,
          trees: response.trees,
        ));
      } else {
        emit(state.copyWith(getTreeStatus: LoadStatus.FAILURE));
      }
      emit(state.copyWith(getTreeStatus: LoadStatus.SUCCESS));
    } catch (error) {
      emit(state.copyWith(getTreeStatus: LoadStatus.FAILURE));
    }
  }

  void fetchListProcess() async {
    emit(state.copyWith(getProcessStatus: LoadStatus.LOADING));
    try {
      final response = await processRepository.getListProcessData();
      print(response);
      if (response != null) {
        emit(state.copyWith(
          getProcessStatus: LoadStatus.SUCCESS,
          processes: response.processes,
        ));
      } else {
        emit(state.copyWith(getProcessStatus: LoadStatus.FAILURE));
      }
      emit(state.copyWith(getProcessStatus: LoadStatus.SUCCESS));
    } catch (error) {
      emit(state.copyWith(getProcessStatus: LoadStatus.FAILURE));
    }
  }

  fetchListGarden() async {
    emit(state.copyWith(getGardenStatus: LoadStatus.LOADING));
    try {
      final response = await gardenRepository.getGardenData();
      List<GardenEntity> list = [];
      list = response.where((element) => element.zone != null).toList();
      if (response != null) {
        emit(state.copyWith(
          getGardenStatus: LoadStatus.SUCCESS,
          gardens: list /*.data!*/ /*.gardens*/,
        ));

      } else {
        emit(state.copyWith(getGardenStatus: LoadStatus.FAILURE));
      }
      emit(state.copyWith(getGardenStatus: LoadStatus.SUCCESS));
    } catch (error) {
      emit(state.copyWith(getGardenStatus: LoadStatus.FAILURE));
    }
  }

  fetchListSeason() async {
    emit(state.copyWith(getSeasonStatus: LoadStatus.LOADING));
    try {
      final response = await seasonRepository.getListSeasonData();
      if (response != null) {
        emit(state.copyWith(
          getSeasonStatus: LoadStatus.SUCCESS,
          seasons: response /*.data!*/ /*.gardens*/,
        ));
      } else {
        emit(state.copyWith(getSeasonStatus: LoadStatus.FAILURE));
      }
      emit(state.copyWith(getSeasonStatus: LoadStatus.SUCCESS));
    } catch (error) {
      emit(state.copyWith(getSeasonStatus: LoadStatus.FAILURE));
    }
  }
  fetchListMaterials() async {
    emit(state.copyWith(getMaterialsStatus: LoadStatus.LOADING));
    try {
      final response = await materialRepository.getListMaterial();

      if (response != null) {
        emit(state.copyWith(
          getMaterialsStatus: LoadStatus.SUCCESS,
          listMaterials: response /*.data!*/ /*.gardens*/,
        ));

      } else {
        emit(state.copyWith(getGardenStatus: LoadStatus.FAILURE));
      }
      emit(state.copyWith(getGardenStatus: LoadStatus.SUCCESS));
    } catch (error) {
      emit(state.copyWith(getGardenStatus: LoadStatus.FAILURE));
    }
  }

  void removeUserSection() {
    authRepository.removeToken();
    GlobalData.instance.token = null;
  }
  void getWeather() async {
    String? longitude = await SharedPreferencesHelper.getLongitude();
    String? latitude = await SharedPreferencesHelper.getLatitude();

    print('longitude $longitude');
    print('latitude $latitude');

    emit(state.copyWith(weatherStatus: LoadStatus.LOADING));
    try {
      final response = await weatherRepository.getCurrentWeather(
          latitude!, longitude!, AppConfig.apiKey);
      emit(
          state.copyWith(weather: response, weatherStatus: LoadStatus.SUCCESS));
    } catch (e) {
      emit(state.copyWith(weatherStatus: LoadStatus.FAILURE));
    }
  }

  Future<void> fetchListContractWork() async {
    emit(state.copyWith(contractWorkStatus: LoadStatus.LOADING));
    try {
      final response = await contractWorkRepositoy.getListContractWorks();
      if (response != null) {
        emit(state.copyWith(
            contractWorkStatus: LoadStatus.SUCCESS, contractWorks: response));
      } else {
        emit(state.copyWith(weatherStatus: LoadStatus.FAILURE));
      }
    } catch (e) {
      emit(state.copyWith(weatherStatus: LoadStatus.FAILURE));
    }
  }
  //
  // Future<List<StepEntityResponseByDay>> fetchStepOfDay(
  //     String? selectedDate) async {
  //   final kToday = DateTime.now();
  //   final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
  //   final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
  //   DateTime start = kFirstDay;
  //   DateFormat formattedDate = DateFormat('yyyy-MM-dd');
  //   emit(state.copyWith(getStepByDayStatus: LoadStatus.LOADING));
  //   List<StepEntityResponseByDay> response = [];
  //   try {
  //     while(start.isBefore(kLastDay)) {
  //       start = start.add(Duration(days: 1));
  //       final events = await authRepository.getStepsByDay(day: formattedDate.format(start));
  //      if(events!= null){
  //        print(start);
  //        print(events);
  //        response.addAll(events);
  //      }
  //     }
  //   //  print(response);
  //     if (response != null) {
  //       emit(state.copyWith(getStepByDayStatus: LoadStatus.SUCCESS));
  //       return response;
  //     } else {
  //       emit(state.copyWith(getStepByDayStatus: LoadStatus.FAILURE));
  //       return response;
  //     }
  //   } catch (e) {
  //     emit(state.copyWith(getStepByDayStatus: LoadStatus.FAILURE));
  //     return response;
  //   }
  // }

// void getProfile() async {
//   emit(state.copyWith(fetchUser: LoadStatus.LOADING));
//   try {
//     final userRes = await userRepository.getProfile();
//
//     emit(state.copyWith(user: userRes));
//
//     emit(state.copyWith(fetchUser: LoadStatus.SUCCESS));
//   } catch (error) {
//     logger.e(error);
//     emit(state.copyWith(fetchUser: LoadStatus.FAILURE));
//   }
// }
// ///Sign Out
// void signOut() async {
//   emit(state.copyWith(signOutStatus: LoadStatus.LOADING));
//   try {
//     final deviceToken = await FirebaseMessaging.instance.getToken();
//     final param = SignOutParam(deviceToken: deviceToken);
//     //Todo
//     await authRepository.signOut(param);
//     await FirebaseMessaging.instance.deleteToken();
//     await authRepository.removeToken();
//     GlobalData.instance.token = null;
//     AppState newState = state.copyWith(signOutStatus: LoadStatus.SUCCESS);
//     newState.user = null;
//     emit(newState);
//   } catch (e) {
//     logger.e(e);
//     emit(state.copyWith(signOutStatus: LoadStatus.FAILURE));
//   }
// }
}

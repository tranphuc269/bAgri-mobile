import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/generated/l10n.dart';
import 'package:flutter_base/models/entities/garden/garden_entity.dart';
import 'package:flutter_base/models/entities/zone/zone_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/models/params/zone/create_zone_params.dart';
import 'package:flutter_base/repositories/zone_repository.dart';
import 'package:flutter_base/ui/pages/auth/login/login_cubit.dart';
import 'package:flutter_base/ui/widgets/app_snackbar.dart';

import 'package:flutter_base/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

part 'zone_list_state.dart';

class ZoneListCubit extends Cubit<ZoneListState> {
  ZoneRepository? zoneRepository;
  final accessToken = SharedPreferencesHelper.getToken().toString();
  ZoneListCubit({this.zoneRepository}) : super(ZoneListState());

  final showMessageController = PublishSubject<SnackBarMessage>();

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }
  void fetchZoneList() async {
    emit(state.copyWith(getZoneStatus: LoadStatus.LOADING));
    try {
      final response = await zoneRepository!.getZoneData(accessToken);
      if (response != null) {
        print(response);
        print("load success");
        emit(state.copyWith(
          getZoneStatus: LoadStatus.SUCCESS,
          listZoneData: response,
        ));
      } else {
        emit(state.copyWith(getZoneStatus: LoadStatus.FAILURE));
      }
      emit(state.copyWith(getZoneStatus: LoadStatus.SUCCESS));
    } catch (error) {
      emit(state.copyWith(getZoneStatus: LoadStatus.FAILURE));
    }
  }
  Future <void> createZone(String zoneName) async {
    emit(state.copyWith(createZoneStatus: LoadStatus.LOADING));
    try {
      final param = CreateZoneParam(
        name: zoneName,
      );
      final response = await zoneRepository!.createZone(param: param);
      if (response != null) {
        print(response);
        emit(state.copyWith(createZoneStatus: LoadStatus.SUCCESS));
      } else {
        emit(state.copyWith(createZoneStatus: LoadStatus.FAILURE));
      }
    } catch (error) {
      if (error is DioError) {
        emit(state.copyWith(createZoneStatus: LoadStatus.FAILURE));
        print("stattus code: " + (error.response!.statusCode).toString());
        if(error.response!.statusCode == 500){
          emit(state.copyWith(createZoneStatus: LoadStatus.FAILURE));
          // print("Tên khu đã bị trùng");
          emit(state.copyWith(
                        messageError: "Tên khu vực đã được sử dụng!",
                        createZoneStatus: LoadStatus.FAILURE
                    ));
            return;
          }

        }
        // logger.e(error.response!.data['error']['message']);
        // emit(state.copyWith(
        //     messageError: error.response!.data['error']['message'],
        //     RegisterStatus: LoadStatus.FAILURE));
      }
      return;
    }
 Future <void> deleteZone(String? zoneId) async {
    emit(state.copyWith(deleteZoneStatus: LoadStatus.LOADING));
    try {
      final response = await zoneRepository!.deleteZone(accessToken, zoneId);
      emit(state.copyWith(deleteZoneStatus: LoadStatus.SUCCESS));
    } catch (e) {
      emit(state.copyWith(deleteZoneStatus: LoadStatus.FAILURE));
      showMessageController.sink.add(SnackBarMessage(
        message: S.current.error_occurred,
        type: SnackBarType.ERROR,
      ));
      return;
    }
  }
  Future<void> modifyZone(String? zoneId, String newName) async{
    emit(state.copyWith(modifyZoneStatus: LoadStatus.LOADING));
    try {
      final param = CreateZoneParam(
        name: newName,
      );
      final response = await zoneRepository!.modifyZone(accessToken, zoneId, param);
      emit(state.copyWith(modifyZoneStatus: LoadStatus.SUCCESS));
    } catch (error) {
      emit(state.copyWith(modifyZoneStatus: LoadStatus.FAILURE));
      if (error is DioError) {
        emit(state.copyWith(modifyZoneStatus: LoadStatus.FAILURE));
        print("stattus code: " + (error.response!.statusCode).toString());
        if(error.response!.statusCode == 500){
          emit(state.copyWith(modifyZoneStatus: LoadStatus.FAILURE));
          // print("Tên khu đã bị trùng");
          emit(state.copyWith(
              messageError: "Tên khu vực đã được sử dụng!",
              modifyZoneStatus: LoadStatus.FAILURE
          ));
          return;
        }

      }
    }
  }
  void getAmountOfGardenOfZone(String? zoneId) async{
    emit(state.copyWith(createZoneStatus: LoadStatus.LOADING));
    try {
      final response = await zoneRepository!.getAmountOfGardenOfZone(accessToken, zoneId);
      if (response != null) {
        emit(state.copyWith(createZoneStatus: LoadStatus.SUCCESS, listGarden: response));
      } else {
        emit(state.copyWith(createZoneStatus: LoadStatus.FAILURE));
      }
    } catch (e) {
      emit(state.copyWith(createZoneStatus: LoadStatus.FAILURE));
      return ;
    }
  }

}

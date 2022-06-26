import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/process/step_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/auth_repository.dart';
import 'package:flutter_base/repositories/weather_repository.dart';
import 'package:flutter_base/ui/widgets/app_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';

part 'home_garden_manager_state.dart';

class HomeGardenManagerCubit extends Cubit<HomeGardenManagerState> {
  WeatherRepository? weatherRepository;
  AuthRepository authRepository;
  DateFormat formattedDate = DateFormat('yyyy-MM-dd');

  HomeGardenManagerCubit({
    this.weatherRepository,
    required this.authRepository,
  }) : super(HomeGardenManagerState());

  final showMessageController = PublishSubject<SnackBarMessage>();

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }

 Future fetchStepOfDay(DateTime? selectedDate) async {
    print(selectedDate);
    emit(state.copyWith(getEventStatus:  LoadStatus.LOADING));
    try{
      final response = await authRepository.getStepsByDay(day: formattedDate.format(selectedDate!));
     print("response");
     print(response);
      if(response != null){
        emit(state.copyWith(getEventStatus: LoadStatus.SUCCESS, eventsOfDays: response));
      }else{
        emit(state.copyWith(getEventStatus: LoadStatus.FAILURE));
      }
    }
    catch (e) {
      print("error");
      emit(state.copyWith(getEventStatus: LoadStatus.FAILURE));
      throw(e);
    }
  }
}

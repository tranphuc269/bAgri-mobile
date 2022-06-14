import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/repositories/weather_repository.dart';

part 'home_garden_manager_state.dart';

class HomeGardenManagerCubit extends Cubit<HomeGardenManagerState> {
  WeatherRepository? weatherRepository;

  HomeGardenManagerCubit({
    this.weatherRepository,
  }) : super(HomeGardenManagerState());
}

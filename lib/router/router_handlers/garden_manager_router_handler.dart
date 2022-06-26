import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/repositories/auth_repository.dart';
import 'package:flutter_base/repositories/weather_repository.dart';
import 'package:flutter_base/ui/pages/home_garden_manager/home_garden_manager_cubit.dart';
import 'package:flutter_base/ui/pages/home_garden_manager/home_garden_manager_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Handler homeGardenManagerHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return BlocProvider(
        create: (context) {
          final weatherRepository =
          RepositoryProvider.of<WeatherRepository>(context);
          final authRepository = RepositoryProvider.of<AuthRepository>(context);
          return HomeGardenManagerCubit(weatherRepository: weatherRepository, authRepository: authRepository);
        },
        child: HomeGardenManagerPage(),
      );
    });

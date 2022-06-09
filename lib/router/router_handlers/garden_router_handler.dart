import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/repositories/garden_repository.dart';
import 'package:flutter_base/repositories/zone_repository.dart';
import 'package:flutter_base/ui/pages/garden_management/garden_create/garden_create_cubit.dart';
import 'package:flutter_base/ui/pages/garden_management/garden_create/garden_create_page.dart';
import 'package:flutter_base/ui/pages/garden_management/garden_detail/garden_detail.dart';
import 'package:flutter_base/ui/pages/garden_management/garden_detail/garden_detail_cubit.dart';
import 'package:flutter_base/ui/pages/garden_management/garden_list/garden_list_cubit.dart';
import 'package:flutter_base/ui/pages/garden_management/garden_list/garden_list_page.dart';
import 'package:flutter_base/ui/pages/garden_management/garden_list_by_qlv/garden_list_by_qlv.dart';
import 'package:flutter_base/ui/pages/garden_management/garden_list_by_qlv/garden_list_by_qlv_cubit.dart';
import 'package:flutter_base/ui/pages/garden_management/garden_update/garden_update.dart';
import 'package:flutter_base/ui/pages/garden_management/garden_update/garden_update_cubit.dart';
import 'package:flutter_base/ui/pages/garden_management/zone/zone_list_cubit.dart';
import 'package:flutter_base/ui/pages/garden_management/zone/zone_list_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

Handler gardenListHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      GardenListArgument args = context!.settings!.arguments as GardenListArgument;
  return BlocProvider(
    create: (context) {
      final gardenRepository = RepositoryProvider.of<GardenRepository>(context);
      return GardenListCubit(gardenRepository: gardenRepository);
    },
    child: GardenListPage(
      zone_id: args.zone_id,
      titleScreen: args.titleScreen,
    ),
  );
});

Handler gardenCreateHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      GardenCreateArgument args = context!.settings!.arguments as GardenCreateArgument;
  return BlocProvider(
    create: (context) {
      final gardenRepository = RepositoryProvider.of<GardenRepository>(context);
      return GardenCreateCubit(gardenRepository: gardenRepository);
    },
    child: CreateGardenPage(
      zone_id: args.zone_id,
      zoneName: args.zoneName,
    ),
  );
});

Handler gardenDetailHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  GardenArgument args = context!.settings!.arguments as GardenArgument;

  return BlocProvider(
    create: (context) {
      final gardenRepository = RepositoryProvider.of<GardenRepository>(context);
      return GardenDetailCubit(gardenRepository: gardenRepository);
    },
    child: GardenDetailPage(
      garden_id: args.garden_id,
      titleScreen: args.titleScreen,
    ),
  );
});

Handler gardenUpdateHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  GardenUpdateArgument args =
      context!.settings!.arguments as GardenUpdateArgument;
  return BlocProvider(
    create: (context) {
      final gardenRepository = RepositoryProvider.of<GardenRepository>(context);
      return GardenUpdateCubit(gardenRepository: gardenRepository);
    },
    child: UpdateGardenPage(
      garden_Id: args.garden_Id,
      zoneName: args.zoneName,
    ),
  );
});

Handler gardenListByQVLHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return BlocProvider(
    create: (context) {
      final gardenRepository = RepositoryProvider.of<GardenRepository>(context);
      return GardenListByQlvCubit(gardenRepository: gardenRepository);
    },
    child: GardenListByQVLPage(),
  );
});
Handler zoneListHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return BlocProvider(
        create: (context) {
          final zoneRepository = RepositoryProvider.of<ZoneRepository>(context);
          return ZoneListCubit(zoneRepository: zoneRepository);
        },
        child: ZoneListPage(),
      );
    });
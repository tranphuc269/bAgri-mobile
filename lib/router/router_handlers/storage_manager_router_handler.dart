import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/repositories/material_repository.dart';
import 'package:flutter_base/ui/pages/storage_manager/add_material/add_material_cubit.dart';
import 'package:flutter_base/ui/pages/storage_manager/add_material/add_material_page.dart';
import 'package:flutter_base/ui/pages/storage_manager/list_materials/storage_management_cubit.dart';
import 'package:flutter_base/ui/pages/storage_manager/list_materials/storage_manager_page.dart';
import 'package:flutter_base/ui/pages/storage_manager/update_material/update_material_cubit.dart';
import 'package:flutter_base/ui/pages/storage_manager/update_material/update_material_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Handler storageManagementHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return BlocProvider(
      create: (context) {
        MaterialRepository materialRepository =
            RepositoryProvider.of<MaterialRepository>(context);
        return StorageManagementCubit(materialRepository: materialRepository);
      },
      child: StorageManagerPage());
});
Handler addMaterialHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return BlocProvider(
      create: (context) {
        MaterialRepository materialRepository = RepositoryProvider.of(context);
        return AddMaterialCubit(materialRepository: materialRepository);
      },
      child: AddMaterialPage());
});
Handler updateMaterialHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      String argument = context!.settings!.arguments as String;
      return BlocProvider(
          create: (context) {
            MaterialRepository materialRepository = RepositoryProvider.of(context);
            return UpdateMaterialCubit(materialRepository: materialRepository);
          },
          child: UpdateMaterialPage(
            materialId: argument,
          ));
    });

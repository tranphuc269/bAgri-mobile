import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/repositories/contract_task_responsitory.dart';
import 'package:flutter_base/repositories/season_repository.dart';

import 'package:flutter_base/ui/pages/task/contract_task_management/contract_task_add/contract_task_add_cubit.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/contract_task_add/contract_task_add_page.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/contract_task_detail/contract_task_detail_cubit.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/contract_task_detail/contract_task_detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Handler addContractTaskHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      SeasonEntity season = context!.settings!.arguments as SeasonEntity;
      return BlocProvider(
    create: (context) {
      final contractTaskRepository =
          RepositoryProvider.of<ContractTaskRepository>(context);
      return ContractTaskAddingCubit(
          contractTaskRepository: contractTaskRepository);
    },
    child: AddContractTaskPage(
      seasonEntity: season,
    ),
  );
});
Handler contractTaskDetailByAdminHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      ContractTaskDetailArgument args =
      context!.settings!.arguments as ContractTaskDetailArgument;
      return BlocProvider(
        create: (context) {
          final contractTaskRepository =
          RepositoryProvider.of<ContractTaskRepository>(context);
          final seasonRepository =
          RepositoryProvider.of<SeasonRepository>(context);
          return ContractTaskDetailCubit(contractTaskRepository: contractTaskRepository, seasonRepository:seasonRepository);
        },
        child: ContractTaskDetailPage(
          contractTask: args.contractTask,
        ),
      );

    });

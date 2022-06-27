import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/repositories/temporary_task_repository.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_task_add/temporary_task_add_cubit.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_task_add/temporary_task_add_page.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_task_list_cubit.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_task_update/temporary_task_update_cubit.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_task_update/temporary_task_update_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Handler temporaryTaskManagementRouterHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return BlocProvider(
    create: (context) {
      TemporaryTaskRepository temporaryTaskRepository =
          RepositoryProvider.of<TemporaryTaskRepository>(context);
      return TemporaryTaskListCubit(
          temporaryTaskRepository: temporaryTaskRepository);
    },
  );
});
Handler temporaryTaskAddHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return BlocProvider(
    create: (context) {
      TemporaryTaskRepository temporaryTaskRepository =
          RepositoryProvider.of<TemporaryTaskRepository>(context);
      return TemporaryTaskAddCubit(
          temporaryTaskRepository: temporaryTaskRepository);
    },
    child: TemporaryTaskAddPage(),
  );
});
Handler updateTemporaryTaskHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  TemporaryTask args = context!.settings!.arguments as TemporaryTask;
  return BlocProvider(
    create: (context) {
      TemporaryTaskRepository temporaryTaskRepository =
          RepositoryProvider.of<TemporaryTaskRepository>(context);
      return TemporaryTaskUpdateCubit(
          temporaryTaskRepository: temporaryTaskRepository);
    },
    child: TemporaryTaskUpdatePage(
      temporaryTask: args,
    ),
  );
});

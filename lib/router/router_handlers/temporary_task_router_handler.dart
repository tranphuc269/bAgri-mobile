import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/repositories/temporary_task_repository.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_task_list_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Handler temporaryTaskManagementRouterHandler = new Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params){
  return BlocProvider(create:  (context) {
    TemporaryTaskRepository temporaryTaskRepository =
    RepositoryProvider.of<TemporaryTaskRepository>(context);
    return TemporaryTaskListCubit(temporaryTaskRepository: temporaryTaskRepository);
  },);
});
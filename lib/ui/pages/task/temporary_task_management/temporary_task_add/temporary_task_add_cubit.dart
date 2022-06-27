import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/garden/garden_entity.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/temporary_task_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'temporary_task_add_state.dart';
class TemporaryTaskAddCubit extends Cubit<TemporaryTaskAddState>{
  TemporaryTaskRepository? temporaryTaskRepository;

  TemporaryTaskAddCubit({this.temporaryTaskRepository}): super(TemporaryTaskAddState());

  createTemporaryTask(){

  }

}
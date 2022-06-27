import 'package:equatable/equatable.dart';
import 'package:flutter_base/repositories/temporary_task_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'temporary_task_update_state.dart';
class TemporaryTaskUpdateCubit extends Cubit<TemporaryTaskUpdateState>{
  TemporaryTaskRepository? temporaryTaskRepository;

  TemporaryTaskUpdateCubit({this.temporaryTaskRepository}): super(TemporaryTaskUpdateState());
}
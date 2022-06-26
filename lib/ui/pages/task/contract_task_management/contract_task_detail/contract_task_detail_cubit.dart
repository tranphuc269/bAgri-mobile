
import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/contract_task_responsitory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contract_task_detail_state.dart';

class ContractTaskDetailCubit extends Cubit<ContractTaskDetailState>{
  ContractTaskRepository contractTaskRepository;
  ContractTaskDetailCubit({required this.contractTaskRepository}) : super(ContractTaskDetailState());

}
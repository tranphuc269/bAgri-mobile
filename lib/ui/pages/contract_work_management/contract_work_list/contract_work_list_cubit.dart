import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contract_work_list_state.dart';

class ContractWorkListCubit extends Cubit<ContractWorkListState>{
  AuthRepository? authRepository;
  ContractWorkListCubit({this.authRepository}) : super(initialState);

}

import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/models/params/contractWork/create_contract_work_param.dart';
import 'package:flutter_base/repositories/auth_repository.dart';
import 'package:flutter_base/repositories/contract_work_reponsitory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

part 'contract_work_list_state.dart';

class ContractWorkListCubit extends Cubit<ContractWorkListState> {
  ContractWorkRepositoy? contractWorkRepositoy;

  ContractWorkListCubit({this.contractWorkRepositoy})
      : super(ContractWorkListState());

  void fetchContractWorkList() async {
    emit(state.copyWith(getListWorkStatus: LoadStatus.LOADING));
    try {
      final response = await contractWorkRepositoy!.getListContractWorks();
      print(response);
      if (response != null) {
        emit(state.copyWith(getListWorkStatus: LoadStatus.SUCCESS));
      } else {
        emit(state.copyWith(getListWorkStatus: LoadStatus.FAILURE));
      }
    } catch (error) {
      emit(state.copyWith(getListWorkStatus: LoadStatus.FAILURE));
    }
  }

  void createContractWork() async {
    emit(state.copyWith(createContractWorkStatus: LoadStatus.LOADING));
    try {
      final param = CreateContractWorkParam(
          title: "Bon Phan", unit: "Đồng/bầu", unitPrice: "500");
      final response =
          await contractWorkRepositoy!.createContractWork(param: param);
      if (response != null) {
        emit(state.copyWith(createContractWorkStatus: LoadStatus.SUCCESS));
      } else {
        emit(state.copyWith(createContractWorkStatus: LoadStatus.FAILURE));
      }
    } catch (e) {
      emit(state.copyWith(createContractWorkStatus: LoadStatus.FAILURE));
      throw e;
    }
  }
}

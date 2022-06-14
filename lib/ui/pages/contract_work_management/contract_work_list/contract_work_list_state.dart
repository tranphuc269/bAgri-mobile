part of 'contract_work_list_cubit.dart';


class ContractWorkListState extends Equatable{

  LoadStatus? getListWorkStatus;
  LoadStatus? createContractWorkStatus;
  ContractWorkListState({this.getListWorkStatus, this.createContractWorkStatus});

  ContractWorkListState copyWith({
    LoadStatus? getListWorkStatus,
    LoadStatus? createContractWorkStatus
  }) {
    return ContractWorkListState(
      getListWorkStatus: getListWorkStatus ?? this.getListWorkStatus,
      createContractWorkStatus: createContractWorkStatus ?? this.createContractWorkStatus
    );
  }

  @override
  List<Object?> get props =>[
    this.getListWorkStatus,
    this.createContractWorkStatus
  ];

}


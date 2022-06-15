part of 'contract_work_list_cubit.dart';


class ContractWorkListState extends Equatable{

  LoadStatus? getListWorkStatus;
  List<Work>? listWork;
  LoadStatus? createContractWorkStatus;
  ContractWorkListState({this.getListWorkStatus, this.listWork, this.createContractWorkStatus});

  ContractWorkListState copyWith({
    LoadStatus? getListWorkStatus,
    LoadStatus? createContractWorkStatus,
    List<Work>? listWork
  }) {
    return ContractWorkListState(
      listWork: listWork ?? this.listWork,
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


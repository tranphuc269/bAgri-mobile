part of 'contract_work_list_cubit.dart';


class ContractWorkListState extends Equatable{

  LoadStatus? getListWorkStatus;
  // List<Work>? listWork;
  LoadStatus? createContractWorkStatus;
  LoadStatus? deleteContractWorkStatus;
  LoadStatus? modifyContractWorKStatus;
  String? title;
  String? unitPrice;
  List<ContractWorkEntity>? listContractWork;
  ContractWorkListState({this.getListWorkStatus, this.createContractWorkStatus, this.deleteContractWorkStatus,this.modifyContractWorKStatus, this.listContractWork, this.title, this.unitPrice});

  ContractWorkListState copyWith({
    LoadStatus? getListWorkStatus,
    LoadStatus? createContractWorkStatus,
    LoadStatus? deleteContractWorkStatus,
    LoadStatus? modifyContractWorkStatus,
    String? title,
    String? unitPrice,
    List<ContractWorkEntity>? listContractWork
  }) {
    return ContractWorkListState(
      // listWork: listWork ?? this.listWork,
      getListWorkStatus: getListWorkStatus ?? this.getListWorkStatus,
      createContractWorkStatus: createContractWorkStatus ?? this.createContractWorkStatus,
      deleteContractWorkStatus: deleteContractWorkStatus ?? this.deleteContractWorkStatus,
      modifyContractWorKStatus: modifyContractWorkStatus ?? this.modifyContractWorKStatus,
      listContractWork: listContractWork ?? this.listContractWork,
      title: title ?? this.title,

      unitPrice: unitPrice ?? this.unitPrice
    );
  }

  @override
  List<Object?> get props =>[
    this.getListWorkStatus,
    this.createContractWorkStatus,
    this.modifyContractWorKStatus,
    this.deleteContractWorkStatus,
    this.listContractWork,
    this.title,
    this.unitPrice
  ];

}


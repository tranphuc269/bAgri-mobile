part of 'contract_tasks_list_cubit.dart';


class ContractTaskListState extends Equatable{
  LoadStatus? getListContractTaskStatus;
  LoadStatus? createContractTaskStatus;
  LoadStatus? deleteContractTaskStatus;
  LoadStatus? modifyContractTaskStatus;
  List<ContractTask>? listContractTasks;
  ContractTaskListState({this.getListContractTaskStatus, this.createContractTaskStatus, this.deleteContractTaskStatus, this.modifyContractTaskStatus, this.listContractTasks});

  ContractTaskListState copyWith({
    LoadStatus? getListContractTaskStatus,
    LoadStatus? createContractTaskStatus,
    LoadStatus? deleteContractTaskStatus,
    LoadStatus? modifyContractTaskStatus,
    List<ContractTask>? listContractTasks
  }) {
    return ContractTaskListState(
        getListContractTaskStatus: getListContractTaskStatus ?? this.getListContractTaskStatus,
        createContractTaskStatus: createContractTaskStatus ?? this.createContractTaskStatus,
        deleteContractTaskStatus: deleteContractTaskStatus ?? this.deleteContractTaskStatus,
        modifyContractTaskStatus: modifyContractTaskStatus ?? this.modifyContractTaskStatus,
        listContractTasks: listContractTasks ?? this.listContractTasks


    );
  }

  @override
  List<Object?> get props =>[
    this.getListContractTaskStatus,
    this.createContractTaskStatus,
    this.modifyContractTaskStatus,
    this.deleteContractTaskStatus,
    this.listContractTasks,
  ];

}


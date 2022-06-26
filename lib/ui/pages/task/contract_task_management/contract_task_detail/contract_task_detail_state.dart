part of 'contract_task_detail_cubit.dart';

class ContractTaskDetailState extends Equatable {
  LoadStatus? loadStatus;

  @override
  List<Object?> get props => [loadStatus];

  ContractTaskDetailState({
    this.loadStatus});

  ContractTaskDetailState copyWith({
    LoadStatus? loadStatus,
  }) {
    return ContractTaskDetailState(loadStatus: loadStatus ?? this.loadStatus);
  }
}

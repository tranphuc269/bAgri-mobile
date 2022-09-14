part of 'season_detail_cubit.dart';

class SeasonDetailState extends Equatable {
  SeasonEntity? season;
  List<TemporaryTask>? listTemporaryTask;
  List<ContractTask>? listContractTask;
  int? fee;
  int? feeWorker;
  int? feeMaterial;
  List<DailyTask>? listDailyTask;
  List<Work>? listWork;
  List<MaterialUsedByTask>? listMaterial;
  LoadStatus? loadStatus;
  LoadStatus? endStepStatus;
  LoadStatus? endStageStatus;

  // String? linkQR;
  // String? linkUrl;
  @override
  List<dynamic> get props => [
        loadStatus,
        season,
        listContractTask,
        listTemporaryTask,
        listDailyTask,
        fee,
        feeMaterial,
        listMaterial,
        listWork,
        feeWorker,
        endStepStatus,
        endStageStatus
        // linkQR,
        // linkUrl,
      ];

  SeasonDetailState(
      {this.loadStatus,
      this.season,
      this.listTemporaryTask,
      this.listContractTask,
      this.fee,
      this.feeWorker,
      this.feeMaterial,
      this.listDailyTask,
      this.listWork,
      this.listMaterial,
      this.endStageStatus,
      this.endStepStatus
      // this.linkQR,
      // this.linkUrl,
      });

  SeasonDetailState copyWith({
    LoadStatus? loadStatus,
    SeasonEntity? season,
    List<ContractTask>? listContractTask,
    List<TemporaryTask>? listTemporaryTask,
    int? fee,
    List<DailyTask>? listDailyTask,
    int? feeWorker,
    int? feeMaterial,
    List<MaterialUsedByTask>? listMaterial,
    List<Work>? listWork,
    LoadStatus? endStageStatus,
    LoadStatus? endStepStatus,
    // String? linkQR,
    // String? linkUrl,
  }) {
    return SeasonDetailState(
        loadStatus: loadStatus ?? this.loadStatus,
        season: season ?? this.season,
        listContractTask: listContractTask ?? this.listContractTask,
        listTemporaryTask: listTemporaryTask ?? this.listTemporaryTask,
        fee: fee ?? this.fee,
        listDailyTask: listDailyTask ?? this.listDailyTask,
        feeMaterial: feeMaterial ?? this.feeMaterial,
        feeWorker: feeWorker ?? this.feeWorker,
        listWork: listWork ?? this.listWork,
        listMaterial: listMaterial ?? this.listMaterial,
        endStageStatus: endStageStatus ?? this.endStageStatus,
        endStepStatus: endStepStatus ?? this.endStepStatus
        // linkQR: linkQR ?? this.linkQR,
        // linkUrl: linkUrl ?? this.linkUrl,
        );
  }
}

part of 'turnover_detail_cubit.dart';

class TurnoverDetailState extends Equatable {
  LoadStatus? loadStatus;
  SeasonEntity? season;
  List<TemporaryTask>? listTemporaryTask;
  List<ContractTask>? listContractTask;
  int? fee;
  int? feeWorker;
  int? feeMaterial;
  List<DailyTask>? listDailyTask;
  List<Work>? listWork;
  List<MaterialUsedByTask>? listMaterial;

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
    feeWorker
    // linkQR,
    // linkUrl,
  ];

  TurnoverDetailState(
      {this.loadStatus,
        this.season,
        this.listTemporaryTask,
        this.listContractTask,
        this.fee,
        this.feeWorker,
        this.feeMaterial,
        this.listDailyTask,
        this.listWork,
        this.listMaterial
        // this.linkQR,
        // this.linkUrl,
      });

  TurnoverDetailState copyWith(
      {LoadStatus? loadStatus,
        SeasonEntity? season,
        List<ContractTask>? listContractTask,
        List<TemporaryTask>? listTemporaryTask,
        int? fee,
        List<DailyTask>? listDailyTask,
        int? feeWorker,
        int? feeMaterial,
        List<MaterialUsedByTask>? listMaterial,
        List<Work>? listWork
        // String? linkQR,
        // String? linkUrl,
      }) {
    return TurnoverDetailState(
        loadStatus: loadStatus ?? this.loadStatus,
        season: season ?? this.season,
        listContractTask: listContractTask ?? this.listContractTask,
        listTemporaryTask: listTemporaryTask ?? this.listTemporaryTask,
        fee: fee ?? this.fee,
        listDailyTask: listDailyTask ?? this.listDailyTask,
        feeMaterial: feeMaterial ?? this.feeMaterial,
        feeWorker: feeWorker ?? this.feeWorker,
        listWork: listWork ?? this.listWork,
        listMaterial: listMaterial ?? this.listMaterial
    );
  }
}

part of 'app_cubit.dart';

class AppState extends Equatable {
  List<TreeEntity>? trees;
  final LoadStatus? getTreeStatus;

  List<GardenEntity>? gardens;
  final LoadStatus? getGardenStatus;

  List<SeasonEntity>? seasons;
  final LoadStatus? getSeasonStatus;

  List<ProcessEntity>? processes;
  final LoadStatus? getProcessStatus;

  final LoadStatus? taskStatus;

  List<MaterialEntity>? listMaterials;
  final LoadStatus? getMaterialsStatus;

  List<UserEntity>? managers;
  final LoadStatus? getManagersStatus;

  final LoadStatus? farmerStatus;
  List<ContractWorkEntity>? contractWorks;
  final LoadStatus? contractWorkStatus;

  WeatherResponse? weather;
  final LoadStatus? weatherStatus;


  @override
  List<Object?> get props => [
        this.trees,
        this.getTreeStatus,
        this.gardens,
        this.getGardenStatus,
        this.processes,
        this.getProcessStatus,
        this.taskStatus,
        this.managers,
        this.getManagersStatus,
        this.farmerStatus,
        this.contractWorks,
        this.contractWorkStatus,
        this.weather,
        this.weatherStatus,
        this.listMaterials,
    this.getSeasonStatus,
    this.getMaterialsStatus
      ];

  AppState({this.getMaterialsStatus,
    this.trees,
    this.getTreeStatus,
    this.gardens,
    this.getGardenStatus,
    this.processes,
    this.getProcessStatus,
    this.taskStatus,
    this.managers,
    this.getManagersStatus,
    this.farmerStatus,
    this.contractWorks,
    this.contractWorkStatus,
    this.weather,
    this.getSeasonStatus,
    this.seasons,
    this.weatherStatus,
    this.listMaterials,}
   );

  AppState copyWith({
    List<TreeEntity>? trees,
    LoadStatus? getTreeStatus,
    List<GardenEntity>? gardens,
    LoadStatus? getGardenStatus,
    List<SeasonEntity>? seasons,
    LoadStatus? getSeasonStatus,
    List<ProcessEntity>? processes,
    LoadStatus? getProcessStatus,
    LoadStatus? taskStatus,
    List<UserEntity>? managers,
    LoadStatus? getManagersStatus,
    UserEntity? user,
    LoadStatus? fetchUser,
    LoadStatus? farmerStatus,
    List<ContractWorkEntity>? contractWorks,
    LoadStatus? contractWorkStatus,
    WeatherResponse? weather,
    LoadStatus? weatherStatus,
    List<MaterialEntity>? listMaterials,
    LoadStatus? getMaterialsStatus,
  }) {
    return AppState(
      trees: trees ?? this.trees,
      getTreeStatus: getTreeStatus ?? this.getTreeStatus,
      gardens: gardens ?? this.gardens,
      getGardenStatus: getGardenStatus ?? this.getGardenStatus,
      processes: processes ?? this.processes,
      getProcessStatus: getProcessStatus ?? this.getProcessStatus,
      taskStatus: taskStatus ?? this.taskStatus,
      managers: managers ?? this.managers,
      getManagersStatus: getManagersStatus ?? this.getManagersStatus,
      contractWorks: contractWorks ?? this.contractWorks,
      contractWorkStatus: contractWorkStatus ?? this.contractWorkStatus,
      farmerStatus: farmerStatus ?? this.farmerStatus,
      weather: weather ?? this.weather,
      weatherStatus: weatherStatus ?? this.weatherStatus,
      listMaterials: listMaterials ?? this.listMaterials,
      getMaterialsStatus: getMaterialsStatus ?? this.getMaterialsStatus,
      seasons: seasons ?? this.seasons,
      getSeasonStatus: getSeasonStatus ?? this.getSeasonStatus

    );
  }
}

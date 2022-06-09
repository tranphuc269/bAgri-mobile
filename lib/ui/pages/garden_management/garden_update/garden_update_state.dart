part of 'garden_update_cubit.dart';

class GardenUpdateState extends Equatable {
  String? name;
  String? area;
  String? treePlaceQuantity;
  String? areaUnit;
  String? managerUsername;
  LoadStatus? updateGardenStatus;
  GardenDetailEntityResponse? gardenData;
  LoadStatus? getGardenDataStatus;
  List<UserEntity>? listManager;
  LoadStatus? getListManagerStatus;
  LoadStatus? editGardenStatus;

  GardenUpdateState(
      {this.name,
        this.area,
        this.treePlaceQuantity,
        this.areaUnit,
        this.managerUsername,
        this.updateGardenStatus,
        this.listManager,
        this.gardenData,
        this.getGardenDataStatus,
        this.getListManagerStatus,
        this.editGardenStatus});

  GardenUpdateState copyWith(
      {String? name,
        String? area,
        String? managerUsername,
        String? treePlaceQuantity,
        String? areaUnit,
        LoadStatus? updateGardenStatus,
        List<UserEntity>? listManager,
        GardenDetailEntityResponse? gardenData,
        LoadStatus? getGardenDataStatus,
        LoadStatus? editGardenStatus,
        LoadStatus? getListManagerStatus}) {
    return GardenUpdateState(
        name: name ?? this.name,
        area: area ?? this.area,
        managerUsername: managerUsername ?? this.managerUsername,
        treePlaceQuantity: treePlaceQuantity ?? this.treePlaceQuantity,
        areaUnit: areaUnit ?? this.areaUnit,
        updateGardenStatus: updateGardenStatus ?? this.updateGardenStatus,
        listManager: listManager ?? this.listManager,
        gardenData: gardenData ?? this.gardenData,
        getGardenDataStatus: getGardenDataStatus ?? this.getGardenDataStatus,
        editGardenStatus: editGardenStatus ?? this.editGardenStatus,
        getListManagerStatus: getListManagerStatus ?? this.getListManagerStatus);

  }

  @override
  List<Object?> get props => [
    this.name,
    this.area,
    this.managerUsername,
    this.updateGardenStatus,
    this.getListManagerStatus,
    this.getGardenDataStatus,
    this.editGardenStatus,
    this.gardenData
  ];
}

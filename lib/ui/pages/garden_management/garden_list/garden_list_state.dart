part of 'garden_list_cubit.dart';

class GardenListState extends Equatable {
  LoginStatusBagri? getGardenStatus;
  LoadStatus? deleteGardenStatus;
  List<GardenEntity>? listGardenData;
  List<GardenEntityResponseFromZoneId>? listGarden;
  LoadStatus? getGardenDetailStatus;

  GardenListState(
      {this.getGardenStatus, this.listGardenData, this.deleteGardenStatus, this.listGarden, this.getGardenDetailStatus});

  GardenListState copyWith({
    LoginStatusBagri? getGardenStatus,
    List<GardenEntity>? listGardenData,
    LoadStatus? deleteGardenStatus,
    List<GardenEntityResponseFromZoneId>? listGarden,


  }) {
    return GardenListState(
      getGardenStatus: getGardenStatus ?? this.getGardenStatus,
      listGardenData: listGardenData ?? this.listGardenData,
      deleteGardenStatus: deleteGardenStatus ?? this.deleteGardenStatus,
      listGarden: listGarden ?? this.listGarden,


    );
  }

  @override
  List<Object?> get props =>
      [this.getGardenStatus, this.listGardenData, this.deleteGardenStatus, this.listGarden, this.getGardenDetailStatus];
}

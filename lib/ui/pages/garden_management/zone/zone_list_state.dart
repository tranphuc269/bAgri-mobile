part of 'zone_list_cubit.dart';

class ZoneListState extends Equatable {
  String? zoneName;
  String? messageError;
  LoadStatus? getZoneStatus;
  LoadStatus? deleteZoneStatus;
  LoadStatus? createZoneStatus;
  LoadStatus? modifyZoneStatus;
  List<ZoneEntity>? listZoneData;
  List<GardenEntityResponseFromZoneId>? listGarden;


  ZoneListState(
      {this.zoneName,this.messageError, this.getZoneStatus, this.listZoneData, this.deleteZoneStatus, this.createZoneStatus, this.modifyZoneStatus, this.listGarden});

  ZoneListState copyWith({
    String? zoneName,
    String? messageError,
    LoadStatus? getZoneStatus,
    List<GardenEntityResponseFromZoneId>? listGarden,
    List<ZoneEntity>? listZoneData,
    LoadStatus? deleteZoneStatus,
    LoadStatus? createZoneStatus,
    LoadStatus? modifyZoneStatus,


  }) {
    return ZoneListState(
      zoneName: zoneName ?? this.zoneName,
      messageError: messageError ?? this.messageError,
      getZoneStatus: getZoneStatus ?? this.getZoneStatus,
      listZoneData: listZoneData ?? this.listZoneData,
      deleteZoneStatus: deleteZoneStatus ?? this.deleteZoneStatus,
      createZoneStatus: createZoneStatus ?? this.createZoneStatus,
      modifyZoneStatus: modifyZoneStatus ?? this.modifyZoneStatus,
      listGarden: listGarden?? this.listGarden
    );
  }

  @override
  List<Object?> get props =>
      [this.zoneName, this.messageError, this.getZoneStatus, this.listZoneData, this.deleteZoneStatus, this.modifyZoneStatus, this.listGarden, this.createZoneStatus];
}

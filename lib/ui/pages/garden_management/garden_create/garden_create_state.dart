part of 'garden_create_cubit.dart';

class GardenCreateState extends Equatable {
  String? name;
  String? area;
  String? managerUsername;
  LoadStatus? createGardenStatus;
  List<UserEntity>? listManager;
  LoadStatus? getListManagerStatus;

  GardenCreateState(
      {this.name,
      this.area,
      this.managerUsername,
      this.createGardenStatus,
      this.listManager,
      this.getListManagerStatus});

  GardenCreateState copyWith(
      {String? name,
      String? area,
      String? managerUsername,
      LoadStatus? createGardenStatus,
      List<UserEntity>? listManager,
      LoadStatus? getListManagerStatus}) {
    return GardenCreateState(
        name: name ?? this.name,
        area: area ?? this.area,
        managerUsername: managerUsername ?? this.managerUsername,
        createGardenStatus: createGardenStatus ?? this.createGardenStatus,
        listManager: listManager ?? this.listManager,
        getListManagerStatus:
            getListManagerStatus ?? this.getListManagerStatus);
  }

  @override
  List<Object?> get props => [
        this.name,
        this.area,
        this.managerUsername,
        this.createGardenStatus,
        this.getListManagerStatus
      ];
}

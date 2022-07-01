part of 'garden_create_cubit.dart';

class GardenCreateState extends Equatable {
  String? name;
  String? area;
  String? managerPhone;
  LoadStatus? createGardenStatus;
  List<UserEntity>? listManager;
  LoadStatus? getListManagerStatus;

  GardenCreateState(
      {this.name,
      this.area,
      this.managerPhone,
      this.createGardenStatus,
      this.listManager,
      this.getListManagerStatus});

  GardenCreateState copyWith(
      {String? name,
      String? area,
      String? managerPhone,
      LoadStatus? createGardenStatus,
      List<UserEntity>? listManager,
      LoadStatus? getListManagerStatus}) {
    return GardenCreateState(
        name: name ?? this.name,
        area: area ?? this.area,
        managerPhone: managerPhone ?? this.managerPhone,
        createGardenStatus: createGardenStatus ?? this.createGardenStatus,
        listManager: listManager ?? this.listManager,
        getListManagerStatus:
            getListManagerStatus ?? this.getListManagerStatus);
  }

  @override
  List<Object?> get props => [
        this.name,
        this.area,
        this.managerPhone,
        this.createGardenStatus,
        this.getListManagerStatus
      ];
}

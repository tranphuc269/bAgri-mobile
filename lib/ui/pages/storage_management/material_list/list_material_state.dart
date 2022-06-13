part of 'list_material_cubit.dart';

class ListMaterialState extends Equatable {
  LoadStatus? getMaterialStatus;
  LoadStatus? deleteMaterialStatus;
  List<ProcessEntity>? listData;

  ListMaterialState(
      {this.getMaterialStatus, this.listData, this.deleteMaterialStatus});

  ListMaterialState copyWith({
    LoadStatus? getProcessStatus,
    List<ProcessEntity>? listData,
    LoadStatus? deleteMaterialStatus,
  }) {
    return ListMaterialState(
      getMaterialStatus: getProcessStatus ?? this.getMaterialStatus,
      listData: listData ?? this.listData,
      deleteMaterialStatus: deleteMaterialStatus ?? this.deleteMaterialStatus,
    );
  }

  @override
  List<Object?> get props =>
      [this.getMaterialStatus, this.listData, this.deleteMaterialStatus];
}

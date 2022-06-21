part of 'storage_management_cubit.dart';
class StorageManagementState extends Equatable {
  List<Material>? listMaterials;
  // final String? description;
  LoadStatus? loadingStatus;

  StorageManagementState({
    this.listMaterials,
    // this.description,
    this.loadingStatus,
  });

  StorageManagementState copyWith({
    List<Material>? listMaterials,
    // final String? description,
    LoadStatus? loadingStatus,
  }) {
    return StorageManagementState(
      listMaterials: listMaterials ?? this.listMaterials,
      // description: description ?? this.description,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }

  @override
  List<Object?> get props => [
    this.listMaterials,
    // this.description,
    this.loadingStatus,
  ];
}

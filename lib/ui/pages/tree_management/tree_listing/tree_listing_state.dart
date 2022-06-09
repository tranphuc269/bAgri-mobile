part of 'tree_listing_cubit.dart';

class TreeListState extends Equatable {
  LoadStatus? getTreeStatus;
  LoadStatus? deleteTreeStatus;
  LoadStatus? createTreeStatus;
  List<TreeEntity>? listData;

  TreeListState({this.getTreeStatus, this.listData, this.deleteTreeStatus, this.createTreeStatus});

  TreeListState copyWith({
    LoadStatus? getTreeStatus,
    List<TreeEntity>? listData,
    LoadStatus? deleteTreeStatus,
    LoadStatus? createTreeStatus,
  }) {
    return TreeListState(
      getTreeStatus: getTreeStatus ?? this.getTreeStatus,
      listData: listData ?? this.listData,
      deleteTreeStatus: deleteTreeStatus ?? this.deleteTreeStatus,
      createTreeStatus: createTreeStatus?? this.createTreeStatus,
    );
  }

  @override
  List<Object?> get props =>
      [this.getTreeStatus, this.listData, this.deleteTreeStatus, this.createTreeStatus];
}

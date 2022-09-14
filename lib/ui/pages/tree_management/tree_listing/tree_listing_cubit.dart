import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/generated/l10n.dart';
import 'package:flutter_base/models/entities/tree/list_tree_response.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/models/params/trees/create_tree_params.dart';
import 'package:flutter_base/repositories/tree_repository.dart';
import 'package:flutter_base/ui/widgets/app_snackbar.dart';

import 'package:rxdart/rxdart.dart';

part 'tree_listing_state.dart';

class TreeListCubit extends Cubit<TreeListState> {
  TreeRepository? treeRepository;

  TreeListCubit({this.treeRepository}) : super(TreeListState());

  final showMessageController = PublishSubject<SnackBarMessage>();

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }

  void fetchListTree() async {
    emit(state.copyWith(getTreeStatus: LoadStatus.LOADING));
    try {
      final response = await treeRepository!.getListTreeData();
        emit(state.copyWith(
          getTreeStatus: LoadStatus.SUCCESS,
          listData: response.trees,));
    } catch (error) {
      emit(state.copyWith(getTreeStatus: LoadStatus.FAILURE));
    }
  }

  Future<void> deleteTree(String? treeId) async {
    emit(state.copyWith(deleteTreeStatus: LoadStatus.LOADING));
    try {
      final response = await treeRepository!.deleteTree(treeId: treeId);
      emit(state.copyWith(deleteTreeStatus: LoadStatus.SUCCESS));
    } catch (e) {
      emit(state.copyWith(deleteTreeStatus: LoadStatus.FAILURE));
      showMessageController.sink.add(SnackBarMessage(
        message: S.current.error_occurred,
        type: SnackBarType.ERROR,
      ));
      return;
    }
  }
  Future <void> createTree(String name) async {
    emit(state.copyWith(createTreeStatus: LoadStatus.LOADING));
    try {
      final param =
      CreateTreeParam(name: name);
      final response = await treeRepository!.createTree(param: param);
      if (response != null) {
        emit(state.copyWith(createTreeStatus: LoadStatus.SUCCESS));
        showMessageController.sink.add(SnackBarMessage(
            message: 'Thêm cây mới thành công',
            type: SnackBarType.SUCCESS
        ));
      } else {
        emit(state.copyWith(createTreeStatus: LoadStatus.FAILURE));
      }
    } catch (error) {
      if (error is DioError) {
        emit(state.copyWith(createTreeStatus: LoadStatus.FAILURE));
        // print(error.response!.data["message"]);
        if(error.response!.statusCode == 400){
          emit(state.copyWith(createTreeStatus: LoadStatus.FAILURE));
          showMessageController.sink.add(SnackBarMessage(
              message: "Tên khu đã tồn tại",
              type: SnackBarType.ERROR
          ));
        }else{
          showMessageController.sink.add(SnackBarMessage(
              message: error.response!.statusMessage,
              type: SnackBarType.ERROR
          ));
        }
      }
    }
  }
}

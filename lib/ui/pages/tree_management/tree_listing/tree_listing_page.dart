import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/generated/l10n.dart';
import 'package:flutter_base/models/entities/tree/list_tree_response.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/tree_repository.dart';
import 'package:flutter_base/ui/pages/tree_management/tree_listing/tree_listing_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_delete_dialog.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_emty_data_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_input_dialog.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/ui/widgets/b_agri/custome_slidable_widget.dart';
import 'package:flutter_base/ui/widgets/error_list_widget.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../widgets/app_snackbar.dart';

class TabListTree extends StatelessWidget {
  const TabListTree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final treeRepository = RepositoryProvider.of<TreeRepository>(context);
        return TreeListCubit(treeRepository: treeRepository);
      },
      child: TreeListPage(),
    );
  }
}

class TreeListPage extends StatefulWidget {
  @override
  _TreeListPageState createState() => _TreeListPageState();
}

class _TreeListPageState extends State<TreeListPage>
    with AutomaticKeepAliveClientMixin {
  TreeListCubit? _cubit;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameTreeController = TextEditingController(text: '');

  late StreamSubscription _showMessageSubscription;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<TreeListCubit>(context);
    _cubit!.fetchListTree();
    _scrollController.addListener(_onScroll);
    _showMessageSubscription =
        _cubit!.showMessageController.stream.listen((event) {
          _showMessage(event);
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _showMessageSubscription.cancel();
    super.dispose();
  }

  void _showMessage(SnackBarMessage message) {
    _scaffoldKey.currentState!.removeCurrentSnackBar();
    _scaffoldKey.currentState!.showSnackBar(AppSnackBar(message: message));
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          heroTag: "btn2",
          onPressed: () async {
            await showDialog(
                context: context, builder: (context) => _dialogCreate());
          },
          backgroundColor: AppColors.main,
          child: Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<TreeListCubit, TreeListState>(
      bloc: _cubit,
      buildWhen: (previous, current) =>
          previous.getTreeStatus != current.getTreeStatus,
      builder: (context, state) {
        if (state.getTreeStatus == LoadStatus.LOADING) {
          return Center(
              child: CircularProgressIndicator(
            color: AppColors.main,
          ));
        } else if (state.getTreeStatus == LoadStatus.FAILURE) {
          return AppErrorListWidget(onRefresh: _onRefreshData);
        } else if (state.getTreeStatus == LoadStatus.SUCCESS) {
          return state.listData!.length != 0
              ? RefreshIndicator(
                  color: AppColors.main,
                  onRefresh: _onRefreshData,
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 25),
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: state.listData!.length,
                    shrinkWrap: true,
                    primary: false,
                    controller: _scrollController,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 15);
                    },
                    itemBuilder: (context, index) {
                      String? name = state.listData![index].name ?? "";
                      TreeEntity tree = state.listData![index];
                      return _buildItem(
                        name: name,
                        onDelete: () async {
                          bool isDelete = await showDialog(
                              context: context,
                              builder: (context) => AppDeleteDialog(
                                    onConfirm: () async {
                                      await _cubit!.deleteTree(
                                          state.listData![index].tree_id);
                                      Navigator.pop(context, true);
                                    },
                                  ));

                          if (isDelete) _onRefreshData();
                        },
                      );
                    },
                  ),
                )
              : /* Expanded(
                  child:*/
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: EmptyDataWidget(),
                    ),
                  ],
                  /*  ),*/
                );
        } else {
          return Container();
        }
      },
    );
  }

  _buildItem(
      {required String name,
      String? avatarUrl,
      VoidCallback? onDelete,
      VoidCallback? onPressed,
      VoidCallback? onUpdate}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.grayEC,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Slidable(
          endActionPane: ActionPane(
            extentRatio: 1 / 3,
            motion: BehindMotion(),
            children: [
              CustomSlidable(
                  backgroundColor: AppColors.redSlideButton,
                  foregroundColor: Colors.white,
                  onPressed: (BuildContext context) {
                    onDelete?.call();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(AppImages.icSlideDelete),
                      ),
                      SizedBox(height: 4),
                      FittedBox(
                        child: Text(
                          'Xóa',
                          style: AppTextStyle.whiteS16,
                        ),
                      )
                    ],
                  )),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
            child: Row(
              children: [
                Image.asset(avatarUrl ?? AppImages.icTreeAvatar),
                SizedBox(width: 18),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                        color: Color(0xFF5C5C5C),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                  size: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialogCreate() {
    return AppInputDialog(
      title: "Thêm cây trồng",
      onConfirm: (() async =>  {
        if (_formKey.currentState!.validate()){
         await _cubit?.createTree(_nameTreeController.text),
          if(_cubit!.state.createTreeStatus == LoadStatus.SUCCESS){
            Navigator.of(context).pop(),
            _nameTreeController.clear(),
            _onRefreshData(),
          }else{
            Navigator.of(context).pop(),
          }
        }}),
      actions: [
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildTextLabel("Tên cây trồng"),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                child: AppTextField(
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  hintText: 'Nhập tên cây trồng' /*hintText.toString()*/,
                  controller: _nameTreeController,
                  validator: (value) {
                    if (Validator.validateNullOrEmpty(value!))
                      return "Chưa nhập tên cây";
                    else
                      return null;
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextLabel(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 28),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: text,
            style: AppTextStyle.blackS14,
          ),
        ]),
      ),
    );
  }

  Widget _buildEmptyList() {
    return ErrorListWidget(
      text: S.of(context).no_data_show,
      onRefresh: _onRefreshData,
    );
  }

  Widget _buildFailureList() {
    return ErrorListWidget(
      text: S.of(context).error_occurred,
      onRefresh: _onRefreshData,
    );
  }

  Future<void> _onRefreshData() async {
    _cubit!.fetchListTree();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      // _cubit!.fetchNextGardenData();
    }
  }

  @override
  bool get wantKeepAlive => true;
}

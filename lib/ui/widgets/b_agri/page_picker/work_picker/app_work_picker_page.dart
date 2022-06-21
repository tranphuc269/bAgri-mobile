import 'package:flutter/material.dart';
import 'package:flutter_base/blocs/app_cubit.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/entities/contract_work/contract_work.dart';
import 'package:flutter_base/models/entities/garden/garden_entity.dart';

import 'package:flutter_base/models/enums/load_status.dart';

import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui.dart';


import 'package:anim_search_bar/anim_search_bar.dart';

import '../../app_circular_progress_indicator.dart';

class AppContractWorkPickerPage extends StatefulWidget {
  final String? selectedContractWork;

  AppContractWorkPickerPage({this.selectedContractWork});

  @override
  _AppContractWorkPickerPageState createState() => _AppContractWorkPickerPageState();
}

class _AppContractWorkPickerPageState extends State<AppContractWorkPickerPage> {
  late AppCubit _cubit;
  ContractWorkEntity? selectedContractWork;
  TextEditingController textController = TextEditingController();
  List<ContractWorkEntity>? items;
  @override
  void initState() {
    _cubit = BlocProvider.of<AppCubit>(context);
    _cubit.fetchListContractWork();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'Chọn công việc khoán',
        rightActions: [
          AnimSearchBar(
            width: 400,
            textController: textController,
            helpText: "Tìm kiếm",
            color: AppColors.main,
            style: TextStyle(color: Colors.white),
            onSuffixTap: () {
              setState(() {
                textController.clear();
              });
            },
          ),
        ],

      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildListResult()),
          ],
        ),
      ),
    );
  }

  Widget _buildListResult() {
    return BlocBuilder<AppCubit, AppState>(
      bloc: _cubit,
      buildWhen: (prev, current) {
        return prev.contractWorkStatus!= current.contractWorkStatus;
      },
      builder: (context, state) {
        // _cubit.fetchListGarden();
        print(state.contractWorks?.first.title);
        if (state.contractWorkStatus == LoadStatus.LOADING) {
          return Center(
            child: AppCircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            padding: EdgeInsets.only(top: 10),
            itemCount: (state.contractWorks)?.length ?? 0,
            shrinkWrap: true,
            primary: false,
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              final contractWork = state.contractWorks![index];
              String title = contractWork.title!;
              bool isSelected = false;
              if (widget.selectedContractWork != null) if (contractWork.id ==
                  widget.selectedContractWork) isSelected = true;
              return ItemWidget(
                  title: title,
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.of(context).pop(contractWork);
                  });
            },
          );
        }
      },
    );
  }
}

class ItemWidget extends StatefulWidget {
  String title;
  bool isSelected;
  VoidCallback onTap;
  ItemWidget({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 10),
        decoration: BoxDecoration(
            color: AppColors.grayEC, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Text(
                widget.title,
                style: AppTextStyle.blackS18,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Visibility(
              visible: widget.isSelected,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Icon(
                Icons.check,
                color: AppColors.main,
              ),
            )
          ],
        ),
      ),
    );
  }
}

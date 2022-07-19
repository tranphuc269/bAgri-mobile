import 'package:flutter/material.dart';
import 'package:flutter_base/blocs/app_cubit.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/entities/garden/garden_entity.dart';
import 'package:flutter_base/models/entities/material/material.dart';

import 'package:flutter_base/models/enums/load_status.dart';

import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui.dart';

import '../../app_circular_progress_indicator.dart';

class AppMaterialPickerPage extends StatefulWidget {
  final String? selectedMaterialId;

  AppMaterialPickerPage({this.selectedMaterialId});

  @override
  _AppMaterialPickerPageState createState() => _AppMaterialPickerPageState();
}

class _AppMaterialPickerPageState extends State<AppMaterialPickerPage> {
  late AppCubit _cubit;
  MaterialEntity? selectedMaterial;

  @override
  void initState() {
    _cubit = BlocProvider.of<AppCubit>(context);
    _cubit.fetchListMaterials();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'Chọn vật tư',
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
        return prev.getManagersStatus != current.getMaterialsStatus;
      },
      builder: (context, state) {
        if (state.getManagersStatus == LoadStatus.LOADING) {
          return Center(
            child: AppCircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            padding: EdgeInsets.only(top: 10),
            itemCount: (state.listMaterials)?.length ?? 0,
            shrinkWrap: true,
            primary: false,
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              final material = state.listMaterials![index];
              String title = material.name!;
              bool isSelected = false;
              if (widget.selectedMaterialId != null) if (material.materialId ==
                  widget.selectedMaterialId) isSelected = true;
              return ItemWidget(
                  title: title,
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.of(context).pop(material);
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

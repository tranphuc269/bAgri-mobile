import 'package:flutter/material.dart';
import 'package:flutter_base/blocs/app_cubit.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';

import 'package:flutter_base/models/enums/load_status.dart';

import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui.dart';

import '../../app_circular_progress_indicator.dart';

class AppSeasonPickerPage extends StatefulWidget {
  final String? selectedSeasonId;

  AppSeasonPickerPage({this.selectedSeasonId});

  @override
  _AppSeasonPickerPageState createState() => _AppSeasonPickerPageState();
}

class _AppSeasonPickerPageState extends State<AppSeasonPickerPage> {
  late AppCubit _cubit;
  SeasonEntity? selectedSeason;

  @override
  void initState() {
    _cubit = BlocProvider.of<AppCubit>(context);
    _cubit.fetchListSeason();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'Chọn mùa',
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
        return prev.getSeasonStatus != current.getSeasonStatus;
      },
      builder: (context, state) {
        if (state.getSeasonStatus == LoadStatus.LOADING) {
          return Center(
            child: AppCircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            padding: EdgeInsets.only(top: 10),
            itemCount: (state.seasons)?.length ?? 0,
            shrinkWrap: true,
            primary: false,
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              final season = state.seasons![index];
              String title = season.name!;
              bool isSelected = false;
              if (widget.selectedSeasonId != null) if (season.seasonId ==
                  widget.selectedSeasonId) isSelected = true;
              return ItemWidget(
                  title: title,
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.of(context).pop(season);
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

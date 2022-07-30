import 'package:flutter/material.dart';
import 'package:flutter_base/blocs/app_cubit.dart';
import 'package:flutter_base/models/entities/process/list_process.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/garden_picker/app_garden_picker_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_circular_progress_indicator.dart';

class AppSeasonPickerPage extends StatefulWidget {
  final String? selectedSeasonId;

  AppSeasonPickerPage({this.selectedSeasonId});

  @override
  _AppSeasonPickerPageState createState() => _AppSeasonPickerPageState();
}

class _AppSeasonPickerPageState extends State<AppSeasonPickerPage> {
  late AppCubit _cubit;
  SeasonEntity? selectedGarden;

  @override
  void initState() {
    _cubit = BlocProvider.of<AppCubit>(context);
    _cubit.fetchListSeason();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'Chọn mùa vụ',
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
        // _cubit.fetchListProcess();
        if (state.getSeasonStatus == LoadStatus.LOADING) {
          return Center(
            child: AppCircularProgressIndicator(),
          );
        } else {
          // List<ProcessEntity> listProcess = state.processes!.where((element) {
          //   if (element.trees != null) {
          //     for (int i = 0; i < element.trees!.length; i++) {
          //       if (widget.selectedProcessId!=null && element.trees![i].tree_id == widget.selectedTreeId) {
          //         return true;
          //       }
          //     }
          //     return false;
          //   } else {
          //     return true;
          //   }
          // }).toList();

          return ListView.separated(
            padding: EdgeInsets.only(top: 10),
            itemCount: state.seasons?.length ?? 0,
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/models/entities/season/process_season.dart';
import 'package:flutter_base/models/entities/season/stage_season.dart';
import 'package:flutter_base/models/entities/season/step_season.dart';
import 'package:flutter_base/ui/pages/seasons_management/seasons_detail/season_detail_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProcessSeasonDetail extends StatefulWidget{
  ProcessSeason processSeason;

  ProcessSeasonDetail({Key? key, required this.processSeason});

  @override
  _ProcessSeasonDetailState createState() {
    return _ProcessSeasonDetailState();
  }

}
class _ProcessSeasonDetailState extends State<ProcessSeasonDetail>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

      ],
    );
  }

  Widget phaseDescription(StageSeason phase){
    return Container(

    );
  }

  Widget stepDescription(StepSeason stepSeason){
    return Container();
  }

}
class PhaseSeasonDescription extends StatefulWidget {
  int? index;
  String? phase;
  VoidCallback? onRemove;
  SeasonDetailCubit cubitSeasonDetail;

  PhaseSeasonDescription(
      {Key? key,
        this.index,
        this.phase,
        this.onRemove,
        required this.cubitSeasonDetail})
      : super(key: key);

  @override
  _PhaseSeasonDescriptionState createState() => _PhaseSeasonDescriptionState();
}

class _PhaseSeasonDescriptionState extends State<PhaseSeasonDescription> {
  @override
  Widget build(BuildContext context) {
    int sumStart = 0;
    int sumEnd = 0;
    // if (widget.cubitSeasonDetail.state.stages![widget.index!].steps != null) {
    //   for (int i = 0;
    //   i < widget.cubitSeasonDetail.state.stages![widget.index!].steps!.length;
    //   i++) {
    //     var a = widget.cubitProcess.state.stages![widget.index!].steps;
    //     sumStart += a![i].from_day!;
    //     sumEnd += a[i].to_day!;
    //   }
    // }
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 2, right: 2, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.colors[widget.index!],
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Giai đoạn ${widget.phase}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Thời gian: ',
                          style: TextStyle(
                            color: Color(0xFFBBB5D4),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$sumStart - $sumEnd ngày',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              // BlocBuilder<SeasonDetailCubit,
                              //     SeasonDetailState>(
                              //   buildWhen: (prev, current) =>
                              //   prev.loadStatus !=
                              //       current.loadStatus,
                              //   builder: (context, state) {
                              //     return Column(
                              //       children: List.generate(
                              //           state.stages![widget.index!].steps
                              //               ?.length ??
                              //               0, (index) {
                              //         return StepWidget(
                              //             index: index,
                              //             indexStages: widget.index!,
                              //             phase: widget.phase,
                              //             cubitProcess: widget.cubitProcess,
                              //             step: state.stages![widget.index!]
                              //                 .steps![index]);
                              //       }),
                              //     );
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ]),
          ]),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class StepWidget extends StatefulWidget {
  final int? index;
  final StepSeason? step;
  final String? phase;
  final int? indexStages;
  final SeasonDetailCubit cubitProcess;

  const StepWidget({
    Key? key,
    required this.index,
    this.indexStages,
    this.step,
    this.phase,
    required this.cubitProcess,
  }) : super(key: key);

  @override
  State<StepWidget> createState() => _StepWidgetState();
}

class _StepWidgetState extends State<StepWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Color(0xFFDDDAEA),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.step!.name ?? '',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text('Từ'),
              SizedBox(
                width: 3,
              ),
              Text(
                '${widget.step!.from_day}',
              ),
              SizedBox(
                width: 2,
              ),
              Text('-'),
              SizedBox(
                width: 2,
              ),
              Text('${widget.step!.to_day}'),
              SizedBox(
                width: 3,
              ),
              Text('ngày'),
            ],
          )
        ],
      ),
    );
  }
}

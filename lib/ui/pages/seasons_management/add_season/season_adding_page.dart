import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/configs/app_config.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/seasons_management/add_season/season_adding_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/garden_picker/app_garden_picker.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/process_picker/app_process_picker.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/tree_picker/app_single_tree_picker.dart';
import 'package:flutter_base/utils/date_utils.dart' as Util;
import 'package:flutter_bloc/flutter_bloc.dart';

class SeasonAddingPage extends StatefulWidget {
  const SeasonAddingPage({Key? key}) : super(key: key);

  @override
  _SeasonAddingPageState createState() => _SeasonAddingPageState();
}

class _SeasonAddingPageState extends State<SeasonAddingPage> {
  late SeasonAddingCubit _cubit;
  late TextEditingController nameController;
  late TextEditingController treeQuantityController;
  late SingleTreePickerController treeController;
  late ProcessPickerController processController;
  late GardenPickerController gardenController;

  @override
  void initState() {
    _cubit = BlocProvider.of<SeasonAddingCubit>(context);
    nameController = TextEditingController();
    treeController = SingleTreePickerController();
    processController = ProcessPickerController();
    gardenController = GardenPickerController();
    treeQuantityController = TextEditingController();
    super.initState();
    nameController.addListener(() {
      _cubit.changeSeasonName(nameController.text);
    });
    treeController.addListener(() {
      _cubit.changeTree(treeController.treeEntity!);
      processController.processEntity = null;
    });
    gardenController.addListener(() {
      _cubit.changeGarden(gardenController.gardenEntity!);
    });
    processController.addListener(() {
      _cubit.changeProcess(processController.processEntity);
      if (processController.processEntity != null) {
        _cubit
            .changeDuration(processController.processEntity!.process_id ?? "");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    treeController.dispose();
    processController.dispose();
    gardenController.dispose();
    treeQuantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'Th??m m??a v???',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'T??n m??a v???',
                  style: AppTextStyle.greyS18,
                ),
                SizedBox(height: 10),
                AppTextField(
                  controller: nameController,
                  hintText: 'Nh???p v??o t??n m??a v???',
                ),
                SizedBox(height: 20),
                Text(
                  'Ch???n v?????n',
                  style: AppTextStyle.greyS18,
                ),
                SizedBox(height: 10),
                AppPageGardenPicker(
                  controller: gardenController,
                  onChanged: (value) {},
                ),
                SizedBox(height: 20),
                Text(
                  'Ch???n lo???i c??y',
                  style: AppTextStyle.greyS18,
                ),
                SizedBox(height: 10),
                AppPageSingleTreePicker(
                  controller: treeController,
                  onChanged: (value) {},
                ),
                SizedBox(height: 20),
                Text(
                  'Ch???n quy tr??nh ch??m s??c',
                  style: AppTextStyle.greyS18,
                ),
                SizedBox(height: 10),
                BlocBuilder<SeasonAddingCubit, SeasonAddingState>(
                  buildWhen: (prev, current) =>
                      prev.treeEntity != current.treeEntity ||
                      prev.processEntity != current.processEntity,
                  builder: (context, state) {
                    return AppPageProcessPicker(
                      enabled: state.treeEntity == null ? false : true,
                      controller: processController,
                      treeId: state.treeEntity?.tree_id ?? null,
                      onChanged: (value) {},
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'S??? l?????ng b???u',
                  style: AppTextStyle.greyS18,
                ),
                SizedBox(height: 10),
                AppTextField(
                  keyboardType: TextInputType.number,
                  controller: treeQuantityController,
                  hintText: 'Nh???p v??o s??? l?????ng b???u',
                ),
                SizedBox(height: 30),
                // BlocBuilder<SeasonAddingCubit, SeasonAddingState>(
                //   buildWhen: (prev, current) =>
                //       prev.startTime != current.startTime ||
                //       prev.endTime != current.endTime,
                //   builder: (context, state) {
                //     return Column(
                //       children: [
                //         Row(
                //           children: [
                //             Text(
                //               'Ng??y b???t ?????u:',
                //               style: AppTextStyle.greyS18,
                //             ),
                //             SizedBox(width: 15),
                //             Text(
                //               state.startTime ?? "yyyy/mm/dd",
                //               style: AppTextStyle.blackS16.copyWith(
                //                   decoration: TextDecoration.underline),
                //             ),
                //             SizedBox(width: 10),
                //             GestureDetector(
                //               onTap: () async {
                //                 final result = await showDatePicker(
                //                     context: context,
                //                     locale: Locale('vi'),
                //                     initialEntryMode: DatePickerEntryMode.input,
                //                     builder: (context, child) {
                //                       return _buildCalendarTheme(child);
                //                     },
                //                     fieldHintText: "yyyy/mm/dd",
                //                     initialDate: state.startTime != null
                //                         ? Util.DateUtils.fromString(
                //                             state.startTime!,
                //                             format:
                //                                 AppConfig.dateDisplayFormat)!
                //                         : DateTime.now(),
                //                     firstDate: DateTime.now(),
                //                     lastDate: DateTime(2024));
                //                 if (result != null) {
                //                   _cubit.changeStartTime(
                //                     Util.DateUtils.toDateString(result),
                //                   );
                //                 }
                //               },
                //               child: SizedBox(
                //                 height: 26,
                //                 width: 26,
                //                 child: Image.asset(
                //                   AppImages.icCalendar,
                //                   fit: BoxFit.fill,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                        // SizedBox(height: 15),
                //         Row(
                //           children: [
                //             Text(
                //               'Ng??y k???t th??c (d??? ki???n):',
                //               style: AppTextStyle.greyS18,
                //             ),
                //             SizedBox(width: 15),
                //             Text(
                //               state.endTime ?? "yyyy/mm/dd",
                //               style: AppTextStyle.blackS16.copyWith(
                //                   decoration: TextDecoration.underline),
                //             ),
                //             SizedBox(width: 10),
                //             GestureDetector(
                //               onTap: () async {
                //                 final result = await showDatePicker(
                //                     context: context,
                //                     locale: Locale('vi'),
                //                     initialEntryMode: DatePickerEntryMode.input,
                //                     builder: (context, child) {
                //                       return _buildCalendarTheme(child);
                //                     },
                //                     fieldHintText: "yyyy-MM-dd",
                //                     initialDate: state.endTime != null
                //                         ? Util.DateUtils.fromString(
                //                         state.endTime!,
                //                         format:
                //                         AppConfig.dateDisplayFormat)!
                //                         : DateTime.now(),
                //                     firstDate: DateTime.now(),
                //                     lastDate: DateTime(2024));
                //                 if (result != null) {
                //                   _cubit.changeEndTime(
                //                     Util.DateUtils.toDateString(result),
                //                   );
                //                 }
                //               },
                //               child: SizedBox(
                //                 height: 26,
                //                 width: 26,
                //                 child: Image.asset(
                //                   AppImages.icCalendar,
                //                   fit: BoxFit.fill,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //
                //       ],
                //     );
                //   },
                // ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        color: AppColors.redButton,
                        title: 'H???y b???',
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ),
                    SizedBox(width: 25),
                    BlocBuilder<SeasonAddingCubit, SeasonAddingState>(
                      builder: (context, state) {
                        return Expanded(
                          child: AppButton(
                            color: AppColors.main,
                            isEnabled: state.buttonEnabled,
                            isLoading: state.loadStatus == LoadStatus.LOADING
                                ? true
                                : false,
                            title: 'X??c nh???n',
                            onPressed: () async {
                              await _cubit.createSeason(int.parse(treeQuantityController.text));
                              Navigator.of(context).pop(true);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Theme _buildCalendarTheme(Widget? child) {
    return Theme(
      data: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
            primary: AppColors.main,
            surface: AppColors.main,
            // onSurface: AppColors.main,
            background: AppColors.main,
            onPrimary: Colors.white),
      ),
      child: child!,
    );
  }
}

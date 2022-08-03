import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_base/blocs/app_cubit.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/models/entities/process/step_entity.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/auth_repository.dart';
import 'package:flutter_base/router/application.dart';
import 'package:flutter_base/router/routers.dart';
import 'package:flutter_base/ui/pages/notification_management/notification_management_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/utils/dialog_utils.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import 'home_garden_manager_cubit.dart';

class HomeGardenManagerPage extends StatefulWidget {
  HomeGardenManagerPage();

  @override
  State<StatefulWidget> createState() {
    return _HomeGardenManagerPageState();
  }
}

class _HomeGardenManagerPageState extends State<HomeGardenManagerPage>
    with TickerProviderStateMixin {
  HomeGardenManagerCubit? _cubit;
  AppCubit? _appCubit;

  CalendarFormat _calendarFormat = CalendarFormat.month;

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  final _scrollController = ScrollController();

  // Bottom navigation
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0; //default index of a first screen

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;
  final iconList = <String>[AppImages.icCrop, AppImages.icDialyWork];

  final kToday = DateTime.now();

  @override
  void initState() {
    super.initState();
    final repository = RepositoryProvider.of<AuthRepository>(context);
    _cubit = BlocProvider.of<HomeGardenManagerCubit>(context);
    _appCubit = BlocProvider.of<AppCubit>(context);
    _appCubit!.getData();
    _selectedDay = _focusedDay;
    _cubit!.fetchStepOfDay(_selectedDay);

    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(
      Duration(seconds: 1),
      () => _fabAnimationController.forward(),
    );
    Future.delayed(
      Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        _cubit!.fetchStepOfDay(_selectedDay);
      });
    }
  }

  Future<void> _onRefreshData() async {
    _cubit!.fetchStepOfDay(_selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(flex: 4, child: _buildCalendar()),
              Expanded(flex: 4, child: _buildEvents()),
            ],
          ),
        ),
        drawer: MainDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool isAdd = await showDialog(
                context: context,
                builder: (context) =>
                    selectTypeTask(contractTask: ()  async {
                     bool isAdd = await Application.router
                          ?.navigateTo(context, Routes.addContractTask,
                        routeSettings: RouteSettings(
                        arguments: SeasonEntity()
                      ),);
                     if (isAdd) {
                       Navigator.pop(context, true);
                     }
                    }, temporaryTasks: () async {
                      bool isAdd = await   Application.router
                          ?.navigateTo(context, Routes.addTemporaryTask);
                      if (isAdd) {
                        Navigator.pop(context, true);
                      }
                    },
                  close:(){
                    Navigator.pop(context, false);
                  }
                    ));
            if (isAdd) {
              showSnackBar('Thêm công việc thành công!');
            }
          },
          backgroundColor: AppColors.main,
          child: Icon(
            Icons.add,
            size: 40,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color =
                isActive ? AppColors.mainDarker : AppColors.mainDarker;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconList[index],
                  width: 30,
                  height: 30,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AutoSizeText(
                    index == 0 ? "Mùa vụ" : "Công việc",
                    maxLines: 1,
                    style: TextStyle(color: color),
                    group: autoSizeGroup,
                  ),
                )
              ],
            );
          },
          backgroundColor: Colors.white,
          activeIndex: _bottomNavIndex,
          splashColor: AppColors.mainDarker,
          notchAndCornersAnimation: borderRadiusAnimation,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.defaultEdge,
          gapLocation: GapLocation.center,
          onTap: (index) => setState(() {
            if(index == 0){
              Application.router?.navigateTo(context, Routes.seasonManagement);
            }else{
              Application.router?.navigateTo(context, Routes.seasonListTask);
            }
          }),
          hideAnimationController: _hideBottomBarAnimationController,
          shadow: BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 12,
            spreadRadius: 0.5,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TableCalendar(
        firstDay: DateTime(kToday.year, kToday.month - 3, kToday.day),
        lastDay: DateTime(kToday.year, kToday.month + 3, kToday.day),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        calendarFormat: _calendarFormat,
        rangeSelectionMode: _rangeSelectionMode,
        startingDayOfWeek: StartingDayOfWeek.monday,
        shouldFillViewport: true,
        calendarStyle: CalendarStyle(
          cellMargin: EdgeInsets.all(0),
          // Use `CalendarStyle` to customize the UI
          outsideDaysVisible: true,
          todayDecoration: BoxDecoration(
            border: Border.all(color: AppColors.mainDarker),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
              shape: BoxShape.circle, color: AppColors.mainDarker),
          todayTextStyle: TextStyle(color: Color(0xFF5A5A5A)),
          markerSize: 0,
        ),
        onDaySelected: _onDaySelected,
        locale: "vi",
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle:
                TextStyle(color: AppColors.mainDarker, fontSize: 17)),
      ),
    );
  }

  Widget _buildEvents() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<HomeGardenManagerCubit, HomeGardenManagerState>(
          bloc: _cubit,
          buildWhen: (previous, current) =>
              previous.getEventStatus != current.getEventStatus,
          builder: (context, state) {
            if (state.getEventStatus == LoadStatus.LOADING) {
              return Center(
                  child: CircularProgressIndicator(
                color: AppColors.main,
              ));
            } else if (state.getEventStatus == LoadStatus.FAILURE) {
              return Center(
                child: Text("Co loi xay ra"),
              );
            } else if (state.getEventStatus == LoadStatus.SUCCESS) {
              return state.eventsOfDays!.length != 0
                  ? RefreshIndicator(
                      color: AppColors.main,
                      onRefresh: _onRefreshData,
                      child: ListView.separated(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: state.eventsOfDays!.length,
                        // itemCount: 100,
                        shrinkWrap: true,
                        primary: false,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          StepEntityResponseByDay step =
                              state.eventsOfDays![index];
                          return _buildEvent(
                              gardenName: step.garden,
                              treeQuantity: step.treeQuantity.toString(),
                              step: step.name,
                              season: step.season);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                      ),
                    )
                  : Container(
                      height: 60,
                      child: Center(
                        child: Text("Không có công việc"),
                      ),
                    );
            } else {
              return Container();
            }
          }),
      // ],
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: AppColors.main,
      ),
      padding: EdgeInsets.only(left: 15, right: 19),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 13),
                child: Image.asset(
                  AppImages.icMenuFold,
                  width: 19,
                  height: 15,
                  fit: BoxFit.fill,
                ),
              ),
            );
          }),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 50,
                      height: 46,
                      child: Image.asset(
                        AppImages.icCloudBA,
                        fit: BoxFit.fill,
                      )),
                  Container(
                    height: 30,
                    child: BlocBuilder<AppCubit, AppState>(
                      builder: (context, state) {
                        if (state.weather != null) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${state.weather!.main!.temp!.toInt()}℃',
                                style: AppTextStyle.whiteS12
                                    .copyWith(fontSize: 20),
                              ),
                              Text(
                                '  |  ',
                                style: AppTextStyle.whiteS12
                                    .copyWith(fontSize: 20),
                              ),
                              Image.asset(
                                AppImages.icHumidity,
                                width: 10,
                                height: 15,
                                fit: BoxFit.fill,
                              ),
                              Text(
                                ' ${state.weather!.main!.humidity!.toInt()}%',
                                style: AppTextStyle.whiteS12
                                    .copyWith(fontSize: 20),
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ]),
          )),
        ],
      ),
    );
  }

  Widget _buildEvent(
      {String? gardenName,
      String? treeQuantity,
      String? season,
      String? step}) {
    return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.mainDarker),
          color: Color(0xFFEAFBEC),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          onTap: () {
            // Application.router!.navigateTo(context,
            //   Routes.tabTask);
          },
          title: Text(
            "Vườn: ${gardenName}",
            style: AppTextStyle.blackS16Bold,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Số lượng cây: ${treeQuantity} cây",
                style: AppTextStyle.greyS14,
              ),
              Text(
                "Mùa vụ: ${season}",
                style: AppTextStyle.greyS14,
              ),
              Text("Bước: ${step}")
            ],
          ),
        ));
  }
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: "success",
      message: message,
    ));
  }
}

Widget selectTypeTask(
    {VoidCallback? contractTask, VoidCallback? temporaryTasks, VoidCallback? close}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    ),
    title: Center(
      child: Text("Loại công việc"),
    ),
    content: Container(

      width: 50,
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              child: Container(
                  width: double.infinity,
                  child: Text(
                    "Công khoán",
                    style: AppTextStyle.blackS16,
                  )),
              onTap: contractTask),
          Divider(
            thickness: 1,
          ),
          InkWell(
            child: Container(
                width: double.infinity,
                child: Text(
                  "Công nhật",
                  style: AppTextStyle.blackS16,
                )),
            onTap: temporaryTasks,
          )
        ],
      ),
    ),
    actions: [
      TextButton(
          onPressed: close,
          child: Text(
            "Đóng",
            style: AppTextStyle.redS16,
          ))
    ],
  );
}

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  AppCubit? _appCubit;
  UserEntity? _userInfo;

  @override
  void initState() {
    super.initState();
    _appCubit = BlocProvider.of<AppCubit>(context);
    _userInfo = GlobalData.instance.userEntity;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBarWidget(
          title: "",
          context: context,
        ),
        body: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Họ và tên: ${_userInfo?.name ?? ""}',
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Vai trò: ',
                          style: TextStyle(color: Colors.black87, fontSize: 18),
                        ),
                        Text(
                          '${_userInfo?.role == "SUPER_ADMIN" ? "Super Admin" : (_userInfo?.role == "ADMIN" ? "Kỹ thuật viên" : (_userInfo?.role == "GARDEN_MANAGER" ? "Quản lý vườn" : "Kế toán"))}',
                          style: TextStyle(color: AppColors.main, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Application.router!.navigateTo(
                  context,
                  Routes.changePassword,
                );
              },
              child: Container(
                height: 35,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    IconButton(
                        padding: EdgeInsets.only(right: 10),
                        onPressed: () {},
                        icon: Image.asset(
                          AppImages.icChangePass,
                          fit: BoxFit.fill,
                        )),
                    Text('Đổi mật khẩu'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                showTokenExpiredDialog();
              },
              child: Container(
                height: 35,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    IconButton(
                        padding: EdgeInsets.only(right: 10),
                        onPressed: () {},
                        icon: Image.asset(
                          AppImages.icLogout,
                          fit: BoxFit.fill,
                        )),
                    Text(
                      'Đăng xuất',
                      style: TextStyle(color: Color(0xFFD7443B)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showTokenExpiredDialog() {
    DialogUtils.showNotificationDialog(
      context,
      title: "Bạn có chắc chắc muốn đăng xuất?",
      okText: "Xác nhận!",
      showCloseButton: true,
      onOkPressed: () {
        _appCubit!.removeUserSection();
        Application.router!
            .navigateTo(context, Routes.login, clearStack: true, replace: true);
      },
    );
  }

}

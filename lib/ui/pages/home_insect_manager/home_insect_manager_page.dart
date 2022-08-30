import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/blocs/app_cubit.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';
import 'package:flutter_base/router/application.dart';
import 'package:flutter_base/router/routers.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/utils/dialog_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:table_calendar/table_calendar.dart';

class HomeInsectManagerPage extends StatefulWidget {
  HomeInsectManagerPage();

  @override
  State<StatefulWidget> createState() {
    return _HomeInsectManagerState();
  }
}

class _HomeInsectManagerState extends State<HomeInsectManagerPage>
    with TickerProviderStateMixin {
  // HomeGardenManagerCubit? _cubit;
  AppCubit? _appCubit;

  CalendarFormat _calendarFormat = CalendarFormat.week;

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late DateTime _selectedDate;

  final _scrollController = ScrollController();
  final kToday = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _resetSelectedDate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now().add(Duration(days: 2));
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
              Container(height: 150, child: _buildCalendar()),
              _buildEvent(
                  titleColor: Color(0xFFEB1D36),
                  statusColor: Color(0xFFFF0000),


                  subtitleColor: Color(0xFFFF4848),
                backgroundColor: Color(0xFFFFDEDE),
                headlineColor: Color(0xFFEB1D36)
              ),
              _buildEvent(),
            ],
          ),
        ),
        drawer: MainDrawer(),
      ),
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
            titleTextStyle: TextStyle(
              color: AppColors.mainDarker,
              fontSize: 17,
            )),
      ),
    );
  }

  Widget _buildEvent(
      {Color? titleColor,
      Color? headlineColor,
      Color? statusColor,
      Color? subtitleColor,
      Color? backgroundColor}) {
    return Center(
      child: Card(
        elevation: 5,
        child: InkWell(
          onTap: () {
            print("Them cong viec khoan");
          },
          splashColor: Color(0xFFCDF2CA),
          child: ClipPath(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: MediaQuery.of(context).size.width - 20,
              height: 105,
              decoration: BoxDecoration(
                  color: backgroundColor ?? Color(0xFFDCFCEF),
                  border: Border(
                      left: BorderSide(
                          color: headlineColor ?? AppColors.mainDarker,
                          width: 5))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vườn A1 - Mùa 1/2022",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: titleColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Tình trạng: Phát hiện sâu bệnh",
                    style: TextStyle(
                        color: subtitleColor, fontWeight: FontWeight.w500),
                  ),
                  Text("Người tạo:  Nguyễn Văn A - Quản lý vườn",
                      style: TextStyle(
                          color: subtitleColor, fontWeight: FontWeight.w500)),
                  Text("Ngày tạo: 25-08-2022",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: subtitleColor, fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      Text("Trạng thái: ",
                          style: TextStyle(
                              color: subtitleColor,
                              fontWeight: FontWeight.w500)),
                      Text("Chưa được xử lý",
                          style: TextStyle(
                              color: statusColor ?? AppColors.mainDarker,
                              fontWeight: FontWeight.w500))
                    ],
                  )
                ],
              ),
            ),
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3))),
          ),
        ),
      ),
    );
  }

  Widget _buildEvent1(
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
            "Vườn: $gardenName",
            style: AppTextStyle.blackS16Bold,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Số lượng cây: $treeQuantity cây",
                style: AppTextStyle.greyS14,
              ),
              Text(
                "Mùa vụ: $season",
                style: AppTextStyle.greyS14,
              ),
              Text("Bước: $step")
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        // _cubit!.fetchStepOfDay(_selectedDay);
      });
    }
  }
}

Widget selectTypeTask(
    {VoidCallback? contractTask,
    VoidCallback? temporaryTasks,
    VoidCallback? close}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

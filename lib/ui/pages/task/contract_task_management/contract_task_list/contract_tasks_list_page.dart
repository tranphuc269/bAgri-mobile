import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/repositories/process_repository.dart';
import 'package:flutter_base/router/application.dart';
import 'package:flutter_base/router/routers.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/custome_slidable_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TabListContractTask extends StatelessWidget {
  const TabListContractTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContractTaskListPage();
  }
}
class ContractTaskListPage extends StatefulWidget {

  @override
  _ContractTaskListState createState() => _ContractTaskListState();


}

class _ContractTaskListState extends State<ContractTaskListPage> {
  bool selectTools = false;
  bool selectSupplies = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 25),
                child:_buildItem(name: "Công việc: Rải vật tư cho máy trộn"),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.main,
          onPressed: () async {
            bool? isAdd = await Application.router
                ?.navigateTo(context, Routes.processCreate);
            if (isAdd == true) {
              // _onRefreshData();
            }
          },
          child: Icon(
            Icons.add,
            size: 40,
          ),
        ));
  }

  _buildItem({required String name,
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
              CustomSlidableAction(
                  backgroundColor: AppColors.blueSlideButton,
                  foregroundColor: Colors.white,
                  onPressed: (BuildContext context) {
                    onUpdate?.call();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(AppImages.icSlideEdit),
                      ),
                      SizedBox(height: 4),
                      FittedBox(
                        child: Text(
                          'Sửa',
                          style: AppTextStyle.whiteS16,
                        ),
                      )
                    ],
                  )),
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
                Image.asset(avatarUrl ?? AppImages.icWorks),
                SizedBox(width: 18),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              color: Color(0xFF5C5C5C),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Text("Vườn: A1", overflow: TextOverflow.ellipsis),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Text("Ngày bắt đầu: 14/06/2022"),
                            )

                          ],
                        )
                      ],
                    )
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
  // Widget _addContractTaskDialog(){
  //
  // }
}

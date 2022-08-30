import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/ui/widgets/b_agri/custome_slidable_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TabListTool extends StatelessWidget {
  const TabListTool({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialListPage();
  }
}
class MaterialListPage extends StatefulWidget {

  @override
  _ToolListState createState() => _ToolListState();


}

class _ToolListState extends State<MaterialListPage> {
  bool selectTools = false;
  bool selectSupplies = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
             Padding(
               padding: EdgeInsets.only(
                   left: 10, right: 10, top: 10, bottom: 25),
               child:_buildItem(name: "Dụng cụ: Cuốc") ,
             )

            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.main,
          onPressed: () {},
          child: Icon(
            Icons.add,
            size: 40,
          ),
        ));
  }


  Widget _buildItem({required String name,
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
                Image.asset(avatarUrl ?? AppImages.icTools),
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
                        Text("Số lượng: 20 cái", style: AppTextStyle.blackS14,)
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
}

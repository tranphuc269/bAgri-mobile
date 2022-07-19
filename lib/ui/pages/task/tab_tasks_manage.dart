import 'package:flutter/material.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/contract_task_list/contract_tasks_list_page.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_tasks_list_page.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';

class TaskTabPage extends StatefulWidget{
  SeasonEntity seasonEntity;

  TaskTabPage({required this.seasonEntity});
  @override
  _TaskTabPageState createState() => _TaskTabPageState();
}

class _TaskTabPageState extends State<TaskTabPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBarWidget(
       title: "Danh sách công việc",
       context: context,
     ),
     body: Container(
       child: Padding(
         padding: const EdgeInsets.only(
           top: 9,
         ),
         child: Column(
           children: [
             Container(
               padding: EdgeInsets.symmetric(horizontal: 10),
               child: Row(
                 children: [
                   Expanded(
                     child: TabItem(
                       controller: _controller,
                       title: 'Công khoán ',
                       index: 0,
                     ),
                   ),
                   const SizedBox(width: 8),
                   Expanded(
                     child: TabItem(
                       controller: _controller,
                       title: 'Công nhật',
                       index: 1,
                     ),
                   ),
                 ],
               ),
             ),
             const SizedBox(height: 9),
             Expanded(
               child: TabBarView(
                 controller: _controller,
                 children: [
                   TabListContractTask(seasonEntity: widget.seasonEntity,),
                   TabListTemporaryTask(),
                 ],
               ),
             ),
           ],
         ),
       ),
     ),
   );
  }
}
class TabItem extends StatelessWidget {
  final TabController controller;
  final String title;
  final int index;

  TabItem({required this.controller, required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.animateTo(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color:
          controller.index == index ? Color(0xFF4EC04B) : Color(0xFFECECEC),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: controller.index == index
                ? const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF))
                : const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A7A7A)),
          ),
        ),
      ),
    );
  }
}

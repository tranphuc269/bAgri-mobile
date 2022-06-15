import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/ui/pages/process_management/tab_process_tree.dart';
import 'package:flutter_base/ui/pages/storage_manager/material_list_tab.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/contract_task_list/contract_tasks_list_page.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_tasks_list_page.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';

class StorageManagerPage extends StatefulWidget {
  @override
  _StorageManagerPageState createState() {
    return _StorageManagerPageState();
  }
}

class _StorageManagerPageState extends State<StorageManagerPage>
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Quản lý kho',
          context: context,
        ),
        body: Container(
            child: Padding(
                padding: const EdgeInsets.only(
                  top: 9,
                ),
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TabItem(
                            controller: _controller,
                            title: 'Danh sách vật tư',
                            index: 0,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TabItem(
                            controller: _controller,
                            title: 'Danh sách dụng cụ',
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
                        TabMaterialList(),
                        TabMaterialList(),
                      ],
                    ),
                  ),
                ]))));
  }
}

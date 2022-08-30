import 'package:flutter/material.dart';
import 'package:flutter_base/ui/pages/storage_manager/list_materials/material_list_tab.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';

class StorageManagerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Quản lý kho',
        context: context,
      ),
      body: MaterialListPage(),
    );
  }
}

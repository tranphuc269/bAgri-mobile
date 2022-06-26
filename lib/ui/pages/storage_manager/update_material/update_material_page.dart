import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';

class UpdateMaterialPage extends StatefulWidget{
  @override
  _UpdateMaterialPageState createState() {
    return _UpdateMaterialPageState();
  }

}
class _UpdateMaterialPageState extends State<UpdateMaterialPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Thay đổi vật tư', context: context,
      ),
    );
  }

}
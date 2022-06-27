import 'package:flutter/material.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';

class TemporaryTaskUpdatePage extends StatefulWidget{
  TemporaryTask temporaryTask;
  TemporaryTaskUpdatePage({Key? key, required this.temporaryTask}) : super(key: key);
  @override
  _TemporaryTaskUpdatePageState createState() {
    return _TemporaryTaskUpdatePageState();
  }

}
class _TemporaryTaskUpdatePageState extends State<TemporaryTaskUpdatePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: widget.temporaryTask.title!,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),

          ],
        ),
      ),
    );
  }

}
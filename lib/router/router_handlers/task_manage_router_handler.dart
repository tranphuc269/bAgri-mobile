import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/ui/pages/task/tab_tasks_manage.dart';

Handler tabTaskHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return TaskTabPage();
    });



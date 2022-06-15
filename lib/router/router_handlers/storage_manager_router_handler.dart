import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/ui/pages/storage_manager/storage_manager_page.dart';

Handler storageManagementHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return StorageManagerPage();
    });
import 'package:fluro/fluro.dart';
import 'package:flutter_base/router/router_handlers/auth_bagri_router_handler.dart';
import 'package:flutter_base/router/router_handlers/contract_task_router_handler.dart';
import 'package:flutter_base/router/router_handlers/contract_work_router_handler.dart';
import 'package:flutter_base/router/router_handlers/garden_manager_router_handler.dart';
import 'package:flutter_base/router/router_handlers/garden_router_handler.dart';
import 'package:flutter_base/router/router_handlers/home_bagri_router_handler.dart';
import 'package:flutter_base/router/router_handlers/notification_router_handler.dart';
import 'package:flutter_base/router/router_handlers/season_router_handler.dart';
import 'package:flutter_base/router/router_handlers/process_router_handler.dart';
import 'package:flutter_base/router/router_handlers/storage_manager_router_handler.dart';
import 'package:flutter_base/router/router_handlers/task_manage_router_handler.dart';
import 'package:flutter_base/router/router_handlers/task_router_handler.dart';
import 'package:flutter_base/router/router_handlers/temporary_task_router_handler.dart';
import 'package:flutter_base/router/router_handlers/tree_router_handler.dart';

import 'router_handlers/root_router_handler.dart';

class Routes {
  static String root = "/";

  /// B-Agri
  static String login = "/login";
  static String changePassword = "/changePassword";
  static String forgotPassword = "/forgotPassword";
  static String registry = "/registry";
  static String OtpAuth = "/OtpAuth";

  static String home = "/home";

  /// Zone
  static String zoneList = "/zoneList";

  /// Garden
  static String gardenList = "/gardenList";
  static String gardenCreate = "/gardenCreate";
  static String gardenDetail = "/gardenDetail";
  static String gardenUpdate = "/gardenUpdate";
  static String gardenListByQVL = "/gardenListByQVL";

  /// Process
  static String tabProcess = "/tabProcess";
  static String processList = "/processList";
  static String processCreate = 'processCreate';
  static String processUpdate = "/processUpdate";
  static String processDetail = "/processDetail";
  static String processSeasonUpdate = "/processSeasonUpdate";

  /// Tree
  static String treeList = "/treeList";
  static String treeCreate = "/treeCreate";
  static String treeUpdate = "/treeUpdate";
  static String treeDetail = "/treeDetail";

  ///Employee
  static String employeeManagement = "/employeeManagement";
  static String employeeAdding = "/employeeAdding";
  static String employeeUpdating = "/employeeUpdating";
  static String employeeDetail = "/employeeDetail";

  ///Season
  static String seasonManagement = "/seasonManagement";
  static String seasonAdding = "/seasonAdding";
  static String seasonDetail = "/seasonDetail";
  static String seasonUpdating = "/seasonUpdating";
  static String seasonEnding = "/seasonEnding";

  ///Notification
  static String notificationManagement = "/notificationManagement";
  static String notificationDetail = "/notificationDetail";

  ///Task
  static String taskCreate = "/taskCreate";
  static String taskUpdate = "/taskUpdate";
  static String gardenTask = "/gardenTask";
  static String seasonListTask = "/seasonListTask";

  ///Home
  static String main = "/main_page";

  ///Account Management
  static String manageAccount = '/manageAccount';

  ///Garden Manager
  static String homeGardenManager = '/homeGardenManager';

  ///Contract Work
  static String contractWorkList = '/contractWorkList';

  ///Task
  static String tabTask = '/tabTask';
  static String addContractTask = '/addContractTask';
  static String contractTaskDetailAdmin = '/contractTaskDetailAdmin';

  static String updateTemporaryTask = '/updateTemporaryTask';
  static String addTemporaryTask = '/addTemporaryTask';
  static String temporaryTaskDetail = '/temporaryTaskDetail';

  ///Storage
  static String manageStorage = '/manageStorage';
  static String addMaterial = '/addMaterial';
  static String updateMaterial = '/updateMaterial';
  /// turn-over Management
  static String seasonListForTurnover = '/seasonListForTurnover';
  static String seasonDetailForTurnover = '/seasonDetailForTurnover';





  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = notHandler;
    // router.define(root, handler: splashHandler);

    /// b-agri
    router.define(
      root,
      handler: bagriSplashHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      login,
      handler: loginHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      changePassword,
      handler: changePasswordHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      forgotPassword,
      handler: forgotPasswordHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
        OtpAuth,
        handler: OtpAuthHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      registry,
      handler: registryHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      home,
      handler: homeHandler,
      transitionType: TransitionType.fadeIn,
    );

    /// Zone
    router.define(zoneList,
        handler: zoneListHandler, transitionType: TransitionType.fadeIn);

    /// Garden
    router.define(
      gardenList,
      handler: gardenListHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      gardenCreate,
      handler: gardenCreateHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      gardenDetail,
      handler: gardenDetailHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      gardenUpdate,
      handler: gardenUpdateHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      gardenListByQVL,
      handler: gardenListByQVLHandler,
      transitionType: TransitionType.fadeIn,
    );

    /// Process
    router.define(
      tabProcess,
      handler: tabProcessHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      processList,
      handler: processListHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      processCreate,
      handler: processCreateHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      processUpdate,
      handler: processUpdateHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      processDetail,
      handler: processDetailHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      processSeasonUpdate,
      handler: processSeasonUpdateHandler,
      transitionType: TransitionType.fadeIn,
    );

    /// Tree
    router.define(
      treeCreate,
      handler: treeCreateHandler,
      transitionType: TransitionType.fadeIn,
    );
    // router.define(
    //   treeUpdate,
    //   handler: treeUpdateHandler,
    //   transitionType: TransitionType.fadeIn,
    // );
    // router.define(
    //   treeDetail,
    //   handler: treeDetailHandler,
    //   transitionType: TransitionType.fadeIn,
    // );

    /// Employee
    // router.define(
    //   employeeManagement,
    //   handler: employeeManagementHandler,
    //   transitionType: TransitionType.fadeIn,
    // );
    // router.define(
    //   employeeAdding,
    //   handler: employeeAddingHandler,
    //   transitionType: TransitionType.fadeIn,
    // );
    // router.define(
    //   employeeUpdating,
    //   handler: employeeUpdatingHandler,
    //   transitionType: TransitionType.fadeIn,
    // );
    // router.define(
    //   employeeDetail,
    //   handler: employeeDetailHandler,
    //   transitionType: TransitionType.fadeIn,
    // );

    /// Season
    router.define(
      seasonManagement,
      handler: seasonManagementHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      seasonAdding,
      handler: seasonAddingHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      seasonDetail,
      handler: seasonDetailHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      seasonUpdating,
      handler: seasonUpdatingHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      seasonEnding,
      handler: seasonEndingHandler,
      transitionType: TransitionType.fadeIn,
    );

    /// Notification
    router.define(
      notificationManagement,
      handler: notificationManagementHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      notificationDetail,
      handler: notificationDetailHandler,
      transitionType: TransitionType.fadeIn,
    );

    ///Task
    router.define(
      taskCreate,
      handler: taskCreateHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      taskUpdate,
      handler: taskUpdateHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      gardenTask,
      handler: gardenTaskHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      seasonListTask,
      handler: seasonListTaskHandler,
      transitionType: TransitionType.fadeIn,
    );

    /// ManageAccount
    router.define(
      manageAccount,
      handler: listAccountHandler,
      transitionType: TransitionType.fadeIn,);

    /// homeGardenManager
    router.define(
      homeGardenManager,
      handler: homeGardenManagerHandler,
      transitionType: TransitionType.fadeIn,
    );

    /// contractWorkList
    router.define(contractWorkList,
        handler: contractWorkListHandler,
        transitionType: TransitionType.fadeIn);

    ///New task manage

    router.define(
        tabTask,
        handler: tabTaskHandler,
        transitionType: TransitionType.fadeIn);
    router.define(
        addContractTask,
        handler: addContractTaskHandler,
        transitionType: TransitionType.fadeIn);
    router.define(
        contractTaskDetailAdmin,
        handler: contractTaskDetailByAdminHandler);
    router.define(updateTemporaryTask, handler: updateTemporaryTaskHandler);

    router.define(addTemporaryTask, handler: temporaryTaskAddHandler, transitionType: TransitionType.fadeIn);
    router.define(temporaryTaskDetail, handler: temporaryTaskDetailHandler, transitionType: TransitionType.fadeIn);
    ///manage Storage
    router.define(manageStorage,
        handler: storageManagementHandler,
        transitionType: TransitionType.fadeIn);
    router.define(updateMaterial, handler: updateMaterialHandler, transitionType: TransitionType.fadeIn);
    router.define(addMaterial, handler: addMaterialHandler, transitionType: TransitionType.fadeIn);


    /// Turn-over management
    router.define(seasonListForTurnover,
        handler: seasonListForTurnoverHandler,
        transitionType: TransitionType.fadeIn);
    router.define(seasonDetailForTurnover,
        handler: seasonDetailForTurnoverHandler,
        transitionType: TransitionType.fadeIn);

  }
}

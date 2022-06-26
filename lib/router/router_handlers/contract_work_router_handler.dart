import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/repositories/contract_work_reponsitory.dart';
import 'package:flutter_base/ui/pages/contract_work_management/contract_work_list/contract_work_list_cubit.dart';
import 'package:flutter_base/ui/pages/contract_work_management/contract_work_list/contract_work_list_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Handler contractWorkListHandler = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return BlocProvider(
        create: (context) {
          final contractWorkRepository = RepositoryProvider.of<ContractWorkRepositoy>(context);
          return ContractWorkListCubit(contractWorkRepositoy: contractWorkRepository);
        },
        child: ContractWorkListPage(),
      );
    });
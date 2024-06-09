
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/remote_config_service.dart';
import 'package:flutter_crm_prove/theme_provider.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_create/crm_create_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_detail/crm_detail_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_list_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/login/login_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_crm_prove/ui/pages/login/select_module/select_module_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/pjt_list_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_create/pjt_create_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/project_edit/pjt_edit_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_create/task_create_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_detail/task_detail_bloc.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await RemoteConfigService.instance.initialize();
  runApp(
    ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<CrmListBloc>(
          create: (context) => CrmListBloc(),
        ),
        BlocProvider<CrmDetailBloc>(
          create: (context) => CrmDetailBloc(),
        ),
        BlocProvider<CrmCreateBloc>(
          create: (context) => CrmCreateBloc(),
        ),
        BlocProvider<ModuleBloc>(
          create: (context) => ModuleBloc(),
        ),
        BlocProvider<PjtListBloc>(
          create: (context) => PjtListBloc(),
        ),
        BlocProvider<ProjectDetailBloc>(
          create: (context) => ProjectDetailBloc(),
        ),
        BlocProvider<ProjectEditBloc>(
          create: (context) => ProjectEditBloc(),
        ),
        BlocProvider<TaskCreateBloc>(
          create: (context) => TaskCreateBloc(),
        ),
        BlocProvider<TaskDetailBloc>(
          create: (context) => TaskDetailBloc(),
        ),
        BlocProvider<ProjectCreateBloc>(
          create: (context) => ProjectCreateBloc(),
        )
      ],
      child: MaterialApp(
        theme: Provider.of<ThemeProvider>(context).themeData,
        debugShowCheckedModeBanner: false,
        title: 'Flutter - Odoo app',
        home: const LoginPage(),
      ),
    );
  }
}

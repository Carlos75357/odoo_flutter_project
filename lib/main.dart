import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/remote_config_service.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_create/crm_create_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_detail/crm_detail_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_list_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/login/login_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await RemoteConfigService.instance.initialize();
  runApp(const MyApp());
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
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter - Odoo app',
        home: LoginPage(),
      ),
    );
  }
}

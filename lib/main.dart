import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_detail/crm_detail_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_list_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/login/login_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/login/login_page.dart';

void main() {
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
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter - Odoo app',
        home: LoginPage(),
      ),
    );
  }
}
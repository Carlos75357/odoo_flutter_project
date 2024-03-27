import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_list_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/login/login_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/login/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<CrmListBloc>(
          create: (context) => CrmListBloc(),
        )
      ],
      child: const MaterialApp(
        title: 'Flutter - Odoo app',
        home: LoginPage(),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/widgets/text_fields.dart';
import '../crm_list/crm_list_page.dart';
import 'login_bloc.dart';
import 'login_events.dart';
import 'login_states.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Controllers for the different text fields.
  final TextEditingController urlController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    urlController.text = "https://demos15.aurestic.com";
    usernameController.text = "admin";
    passwordController.text = "admin";

    return Scaffold(
      /// The bloc listener is used to navigate to the next page when the login
      /// is successful and check for errors if there are any in the login process
      /// check if the message contains 'obligatorios' in case of an error.
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CrmListPage()),
            );
          } else if (state is LoginError) {
            String errorMessage = state.error;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          }
        },
        /// The bloc builder is used to render the login page.
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.purple.shade800,
                    Colors.purple.shade700,
                    Colors.purple.shade500
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 80,),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Odoo CRM", style: TextStyle(color: Colors.white, fontSize: 60),),
                          SizedBox(height: 5,),
                          Text("Login", style: TextStyle(color: Colors.white, fontSize: 35),),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 60,),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  CustomTextField(controller: urlController, hintText: 'URL del servidor', icon: Icon(Icons.web)),
                                  SizedBox(height: 20),
                                  CustomTextField(controller: usernameController, hintText:'Nombre de usuario', icon: Icon(Icons.person)),
                                  SizedBox(height: 20),
                                  CustomTextField(controller: passwordController, hintText: 'Contraseña', icon: Icon(Icons.password_outlined), isPassword: true),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                            Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.purple.shade800,
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  BlocProvider.of<LoginBloc>(context).add(
                                    LoginButtonPressed(
                                      url: urlController.text,
                                      username: usernameController.text,
                                      password: passwordController.text,
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    "Iniciar Sesión",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

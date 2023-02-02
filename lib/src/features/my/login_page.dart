import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/auth_provider.dart';
import 'utility/validator.dart';
import 'utility/widgets.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  late String _userName, _password, _sms_code;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);

    var doLogin = () {
      final form = formKey.currentState;

      if(form!.validate()){

        form.save();

        final Future<Map<String,dynamic>> respose =  auth.login(_userName,_password);

        respose.then((response) {
          if (response['status']) {
            GoRouter.of(context).go("/my");
          } else {
            Flushbar(
              title: "Failed Login",
              message: response['msg'].toString(),
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      }else{
        Flushbar(
          title: 'Invalid form',
          message: 'Please complete the form properly',
          duration: Duration(seconds: 10),
        ).show(context);
      }
    };

    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(0.0),
            child: TextButton(
              child: Text("Forgot password?",
                  style: TextStyle(fontWeight: FontWeight.w300)),
              onPressed: () {
//            Navigator.pushReplacementNamed(context, '/reset-password');
              },
            )),
        Padding(
          child: TextButton(
            child:
                Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
            onPressed: () {
              GoRouter.of(context).go("/register");
            },
          ),
          padding: EdgeInsets.only(left: 0.0),
        ),
      ],
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(40.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  Text("手机号"),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    autofocus: false,
                    validator: validatePhone,
                    onSaved: (value) => _userName = value!,
                    decoration:
                        buildInputDecoration('输入手机号', Icons.phone),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("密码"),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    autofocus: false,
                    obscureText: true,
                    validator: (value) {
                      if(value == null || value == ""){
                        return "请输入密码";
                      }else{
                        return null;
                      }
                    },
                    onSaved: (value) => _password = value!,
                    decoration:
                        buildInputDecoration('输入密码', Icons.lock),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // auth.loggedInStatus == Status.Authenticating
                  //     ? loading
                  //     : longButtons('Login',doLogin),
                  longButtons("login", doLogin),
                  SizedBox(
                    height: 8.0,
                  ),
                  forgotLabel
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

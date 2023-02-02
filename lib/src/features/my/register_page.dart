import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/auth_provider.dart';
import 'utility/validator.dart';
import 'utility/widgets.dart';
import 'package:provider/provider.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  final formKey = GlobalKey<FormState>();
  late String _username , _password, _sms_code;
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    AuthProvider auth = Provider.of<AuthProvider>(context);

    var loading  = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    var doRegister = () async {
      print('on doRegister');

      final form = formKey.currentState!;
      if(form.validate()){
        form.save();
        var originStatus = auth.loggedInStatus;
        auth.loggedInStatus = Status.Authenticating;
        Map<String, dynamic> res = await auth.register(username: _username, password:_password, sms_code: _sms_code);
        if(res["status"] == "SUCCESS"){
          Flushbar(
            title: "成功",
            message: "注册成功，正在跳转登录页面！",
            duration: Duration(seconds: 3),
          ).show(context);
          auth.loggedInStatus = originStatus;
          await Future.delayed(Duration(seconds: 2), (){
            GoRouter.of(context).go('/login');
          });
        }else{
          Flushbar(
            title: "失败",
            message: res["msg"],
            duration: Duration(seconds: 3),
          ).show(context);
          auth.loggedInStatus = originStatus;

        }
      }else{
        Flushbar(
          title: 'Invalid form',
          message: 'Please complete the form properly',
          duration: Duration(seconds: 10),
        ).show(context);
      }

    };

    return Scaffold(
      appBar: AppBar(title: Text('Registration'),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.0,),
                Text('手机'),
                TextFormField(
                  autofocus: false,
                  validator: validatePhone,
                  onSaved: (value) => _username = value!,
                  decoration: buildInputDecoration("请输入手机号", Icons.email),
                  controller: myController,
                ),
                SizedBox(height: 20.0,),
                Text("验证码"),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value){
                    if(value == null || value == ""){
                      return "请输入验证码";
                    }else{
                      return null;
                    }
                  },
                  onSaved: (value) => _sms_code = value!,
                  decoration:
                  buildInputDecoration('输入验证码', Icons.verified),
                ),
                SendVerificationCodeWidget(mobileFieldController: myController),
                SizedBox(
                  height: 20.0,
                ),
                Text('Password'),
                SizedBox(height: 5.0,),
                TextFormField(
                  autofocus: false,
                  obscureText: true,
                  validator: validatePassword,
                  onSaved: (value) => _password = value!,
                  decoration: buildInputDecoration("Enter Password", Icons.lock),
                ),
                SizedBox(height: 20.0,),
                auth.loggedInStatus == Status.Authenticating
                    ?loading
                    : longButtons('Register',doRegister)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
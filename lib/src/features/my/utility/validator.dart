String? validateEmail(String? value) {
  String _msg="";
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value == null) {
    _msg = "Your username is required";
  } else if (!regex.hasMatch(value)) {
    _msg = "Please provide a valid emal address";
  }
  return _msg;
}


String? validatePhone(String? value) {
  String _msg="";
  RegExp regex = new RegExp(
      r'^\d{11}$');
  if (value == null) {
    _msg = "手机号是必填的！";
  } else if (!regex.hasMatch(value)) {
    _msg = "请输入合法的手机号";
  }else{
    return null;
  }
  return _msg;
}

String? validatePassword(String? value){
  if(value == null || value.length < 6){
    return "请输入6位以上的密码";
  }else{
    return null;
  }
}
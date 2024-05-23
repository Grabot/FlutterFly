import 'package:flutterfly/util/util.dart';


class LoginRequest {
  late String emailOrUserName;
  late String password;
  late bool isWeb;

  LoginRequest(this.emailOrUserName, this.password, this.isWeb);

  @override
  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};

    if (emailValid(emailOrUserName)) {
      json['email'] = emailOrUserName;
    } else {
      json['user_name'] = emailOrUserName;
    }

    json['password'] = password;
    json['is_web'] = isWeb;
    return json;
  }
}

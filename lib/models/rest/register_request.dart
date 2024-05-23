
class RegisterRequest {
  late String email;
  late String userName;
  late String password;
  late bool isWeb;

  RegisterRequest(this.email, this.userName, this.password, this.isWeb);

  @override
  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};

    json['email'] = email;
    json['user_name'] = userName;
    json['password'] = password;
    json['is_web'] = isWeb;

    return json;
  }
}

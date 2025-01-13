import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutterfly/models/rest/base_response.dart';
import 'package:flutterfly/services/rest/auth_api_clean.dart';
import 'auth_api.dart';


class AuthServiceSetting {
  static AuthServiceSetting? _instance;

  factory AuthServiceSetting() => _instance ??= AuthServiceSetting._internal();

  AuthServiceSetting._internal();

  Future<BaseResponse> changeUserName(String newUsername) async {
    String endPoint = "change/username";
    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(<String, String>{
          "username": newUsername,
        }
      )
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }

  Future<BaseResponse> changePassword(String newPassword) async {
    String endPoint = "change/password";
    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(<String, String> {
          "password": newPassword,
        }
      )
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }

  Future<BaseResponse> changeAvatar(String newAvatarRegular, String newAvatarSmall) async {
    String endPoint = "change/avatar";
    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(<String, String>{
          "avatar": newAvatarRegular,
          "avatar_small": newAvatarSmall,
        }
      )
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }

  Future<bool> getIsAvatarDefault() async {
    // A quick request to see if the current avatar is the default avatar
    String endPoint = "get/avatar/default";
    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(<String, String>{
        }
      )
    );

    Map<String, dynamic> json = response.data;
    if (json.containsKey("result")) {
      return json["result"];
    }

    return false;
  }

  Future<String?> getAchievementImage(String imageName) async {
    String endPoint = "/flutterfly_images/${imageName}.txt";
    var response = await AuthApiClean().dio.get(endPoint);

    if (response.data == null) {
      return null;
    }
    return response.data;
  }

  Future<BaseResponse> resetAvatar() async {
    String endPoint = "reset/avatar";
    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(<String, String>{
        }
      )
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }

  Future<BaseResponse> deleteAccount(String email) async {
    String endPoint = "remove/account";
    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(<String, String>{
          "email": email
        }
      )
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }

  Future<BaseResponse> deleteAccountLoggedIn(String email) async {
    String endPoint = "remove/account/token";
    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(<String, String>{
          "email": email
        }
        )
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }

}

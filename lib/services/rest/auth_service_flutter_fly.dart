import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutterfly/models/rest/base_response.dart';
import 'package:flutterfly/services/user_achievements.dart';
import 'package:flutterfly/services/user_score.dart';
import 'auth_api.dart';


class AuthServiceFlutterFly {
  static AuthServiceFlutterFly? _instance;

  factory AuthServiceFlutterFly() => _instance ??= AuthServiceFlutterFly._internal();

  AuthServiceFlutterFly._internal();

  Future<BaseResponse> getUserScore() async {
    String endPoint = "score/get";
    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(<String, dynamic>{
        }
        )
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }

  Future<BaseResponse> updateUserScore(int? singleButterflyScore, int? doubleButterflyScore, Score score) async {
    String endPoint = "score/update";
    // We'll find the user using the token.
    Map<String, dynamic> data = {
      if (singleButterflyScore != null) "best_score_single_butterfly": singleButterflyScore,
      if (doubleButterflyScore != null) "best_score_double_butterfly": doubleButterflyScore,
      "total_flutters": score.getTotalFlutters(),
      "total_pipes_cleared": score.getTotalPipesCleared(),
      "total_games": score.getTotalGames(),
    };

    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data)
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }

  Future<BaseResponse> updateAchievements(Achievements achievements) async {
    String endPoint = "achievements/update";
    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(<String, dynamic>{
          "achievements_dict": achievements.toJson(),
        }
      )
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }
}

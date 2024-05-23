import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutterfly/models/rest/base_response.dart';
import 'package:flutterfly/models/ui/rank.dart';

import 'auth_api.dart';


class AuthServiceLeaderboard {
  static AuthServiceLeaderboard? _instance;

  factory AuthServiceLeaderboard() => _instance ??= AuthServiceLeaderboard._internal();

  AuthServiceLeaderboard._internal();

  Future<BaseResponse> updateLeaderboardOnePlayer(int score) async {
    String endPoint = "update/leaderboard/one_player";
    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(<String, dynamic>{
          "score": score,
        }
      )
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }

  Future<BaseResponse> updateLeaderboardTwoPlayers(int score) async {
    String endPoint = "update/leaderboard/two_players";
    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(<String, dynamic>{
          "score": score,
        }
      )
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }

  Future<List<Rank>?> getLeaderboardOnePlayer() async {
    String endPoint = "get/leaderboard/one_player";
    var response = await AuthApi().dio.get(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
    );

    Map<String, dynamic> json = response.data;
    if (json["result"]) {
      if (!json.containsKey("leaders")) {
        return null;
      } else {
        List<Rank> ranks = [];
        for (var test in json["leaders"]) {
          ranks.add(Rank.fromJson(test));
        }
        return ranks;
      }
    } else {
      return null;
    }
  }

  Future<List<Rank>?> getLeaderboardTwoPlayers() async {
    String endPoint = "get/leaderboard/two_players";
    var response = await AuthApi().dio.get(endPoint,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
    );

    Map<String, dynamic> json = response.data;
    if (json["result"]) {
      if (!json.containsKey("leaders")) {
        return null;
      } else {
        List<Rank> ranks = [];
        for (var test in json["leaders"]) {
          ranks.add(Rank.fromJson(test));
        }
        return ranks;
      }
    } else {
      return null;
    }
  }
}
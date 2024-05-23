import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutterfly/constants/url_base.dart';
import 'package:flutterfly/models/ui/rank.dart';
import 'package:flutterfly/util/change_notifiers/user_change_notifier.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'rest/auth_service_login.dart';
import 'settings.dart';


class SocketServices extends ChangeNotifier {
  late io.Socket socket;
  late Settings settings;

  static final SocketServices _instance = SocketServices._internal();

  SocketServices._internal() {
    startSockConnection();
  }

  factory SocketServices() {
    return _instance;
  }

  startSockConnection() {
    String socketUrl = baseUrlV1_0;
    socket = io.io(socketUrl, <String, dynamic>{
      'autoConnect': false,
      'path': "/socket.io",
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      socket.emit('message_event', 'Connected!');
    });

    socket.onDisconnect((_) {
      socket.emit('message_event', 'Disconnected!');
    });

    socket.on('message_event', (data) {
      checkMessageEvent(data);
    });

    socket.on('update_leaderboard', (data) {
      updatingLeaderboard(data);
      notifyListeners();
    });

    socket.open();
  }

  retrieveAvatar() {
    AuthServiceLogin().getAvatarUser().then((value) {
      if (value != null) {
        Uint8List avatar = base64Decode(value.replaceAll("\n", ""));
        Settings().setAvatar(avatar);
        if (Settings().getUser() != null) {
          Settings().getUser()!.setAvatar(avatar);
        }
        UserChangeNotifier().notify();
      }
    }).onError((error, stackTrace) {
      // TODO: What to do on an error? Reset?
    });
  }

  void checkMessageEvent(data) {
    if (data == "Avatar creation done!") {
      retrieveAvatar();
    }
  }

  login(int userId) {
    joinRoom(userId);
  }

  logout(int userId) {
    leaveRoom(userId);
  }

  void joinRoom(int userId) {
    if (userId != -1) {
      socket.emit(
        "join",
        {
          'user_id': userId,
        },
      );
    }
  }

  void leaveRoom(int userId) {
    if (socket.connected) {
      socket.emit("leave", {
        'user_id': userId,
      });
    }
  }

  setSettings(Settings settings) {
    this.settings = settings;
  }

  updatingLeaderboard(Map<String, dynamic> data) {
    Rank newRank = Rank.fromJson(data);
    settings.updateLeaderboard(newRank, data["one_player"]);
  }

}

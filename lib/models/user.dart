import 'dart:convert';
import 'dart:typed_data';

import 'package:flutterfly/models/friend.dart';

class User {

  late int id;
  late String userName;
  bool verified = false;
  late List<Friend> friends;
  Uint8List? avatar;
  bool origin = false;

  User(this.id, this.userName, this.verified, this.friends);

  int getId() {
    return id;
  }

  String getUserName() {
    return userName;
  }

  setUsername(String username) {
    userName = username;
  }

  bool isVerified() {
    return verified;
  }

  Uint8List? getAvatar() {
    return avatar;
  }

  void setAvatar(Uint8List avatar) {
    this.avatar = avatar;
  }

  List<Friend> getFriends() {
    return friends;
  }

  bool isOrigin() {
    return origin;
  }

  addFriend(Friend friend) {
    // update friend if the username is already in the list
    for (Friend f in friends) {
      if (f.getFriendId() == friend.getFriendId()) {
        if (friend.retrievedAvatar) {
          f.setAccepted(friend.isAccepted());
          f.setRequested(friend.isRequested());
          f.setFriendName(friend.getFriendName());
          f.setUnreadMessages(friend.getUnreadMessages());
          f.setFriendAvatar(friend.getFriendAvatar());
          f.retrievedAvatar = friend.retrievedAvatar;
          return;
        } else {
          // the friend already exists and maybe it's information retrieved, but it is now updated.
          // update the information except the avatar and username.
          f.setAccepted(friend.isAccepted());
          f.setRequested(friend.isRequested());
          f.setUnreadMessages(friend.getUnreadMessages());
          return;
        }
      }
    }
    // If the friend was not updated it is not in the list, so we add it to the list.
    friends.add(friend);
  }

  removeFriend(int friendId) {
    friends.removeWhere((friend) => friend.getFriendId() == friendId);
  }

  User.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    userName = json["username"];

    if (json.containsKey("verified")) {
      verified = json["verified"];
    }
    if (json.containsKey("friends")) {
      friends = [];
      for (var friend in json["friends"]) {
        friends.add(Friend.fromJson(friend));
      }
    } else {
      friends = [];
    }

    if (json.containsKey("avatar") && json["avatar"] != null) {
      avatar = base64Decode(json["avatar"].replaceAll("\n", ""));
    }
    if (json.containsKey("origin")) {
      origin = json["origin"];
    }
  }

  @override
  String toString() {
    return 'User{userName: $userName}';
  }
}


class Rank {
  late String userName;
  late int userId;
  late int score;
  bool me = false;
  late String timestampString;
  DateTime? timestamp;

  Rank({
    required this.userName,
    required this.userId,
    required this.score,
    required this.me,
    required this.timestampString
  });

  String getUserName() {
    return userName;
  }

  int getScore() {
    return score;
  }

  bool getMe() {
    return me;
  }

  setMe(bool me) {
    this.me = me;
  }

  String getTimestampString() {
    return timestampString;
  }
  DateTime getTimestamp() {
    // Should always be there at the times you need it.
    return timestamp!;
  }

  int getUserId() {
    return userId;
  }

  @override
  bool operator ==(Object other) {
    if (other is Rank) {
      return userName == other.getUserName()
          && userId == other.getUserId()
          && score == other.getScore()
          && me == other.getMe()
          && timestampString == other.getTimestampString();
    }
    return false;
  }

  @override
  int get hashCode => userName.hashCode ^ userId.hashCode ^ score.hashCode ^ me.hashCode ^ timestampString.hashCode;

  Rank.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("user_name")) {
      userName = json["user_name"];
    }
    if (json.containsKey("user_id")) {
      userId = json["user_id"];
    }
    if (json.containsKey("score")) {
      score = json["score"];
    }
    if (json.containsKey("timestamp")) {
      timestampString = json["timestamp"];
      if (!timestampString.endsWith("Z")) {
        // The server has utc timestamp, but it's not formatted with the 'Z'.
        timestampString += "Z";
      }
      timestamp = DateTime.parse(timestampString);
    }
  }
}
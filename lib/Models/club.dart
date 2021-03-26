/// Club Model Class
///
/// This class is the schema for the Club
///
/// Usually works with Firestore database.

class Club {
  final String clubId;
  final String name;
  final String code;
  final String boatGroup;
  final String email;
  final String joinCode;
  final List<dynamic> users;
  final List<dynamic> admins;
  final String chatID;

  Club(
      {this.clubId,
      this.name,
      this.code,
      this.email,
      this.users,
      this.admins,
      this.joinCode,
      this.boatGroup,
      this.chatID});

  /// Convert JSON format (output of Firestore query) into Club Class
  Club.fromMap(
    Map snapshot,
    String id,
  )   : clubId = id ?? '',
        name = snapshot['name'] ?? '',
        code = snapshot['code'] ?? '',
        //address = snapshot['address'] ?? '',
        //phoneNum = snapshot['phoneNum'] ?? '',
        email = snapshot['email'] ?? '',
        users = snapshot['users'] ?? List(),
        admins = snapshot['admins'] ?? List(),
        joinCode = snapshot['joinCode'],
        boatGroup = snapshot['boatGroup'],
        chatID = snapshot['chatID'] ?? "";

  /// Convert Club Class format into JSON format for Firestore
  toJson() {
    return {
      "name": name,
      "code": code,
      "email": email,
      "joinCode": joinCode,
      'users': users,
      'admins': admins,
      'boatGroup': boatGroup,
      'chatID': chatID,
    };
  }

  /// Add a new user, userID to the user List
  void addUser(uid) {
    if (!users.contains(uid)) {
      users.add(uid);
    }
  }
}

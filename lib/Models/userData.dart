/// userData Model Class
///
/// This class is the schema for the user information
///
/// Usually works with Firestore database.

class UserData {
  final String uid;
  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final int age;
  final String phoneNum;
  List<dynamic> clubs = new List();
  final List<dynamic> chats;

  UserData(
      {this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.age,
      this.phoneNum,
      this.role,
      this.clubs,
      this.chats});

  /// Convert JSON format (output of Firestore query) into userData Class
  UserData.fromMap(Map snapshot, String id)
      : uid = id ?? '',
        email = snapshot['email'] ?? '',
        firstName = snapshot['firstName'] ?? '',
        lastName = snapshot['lastName'] ?? '',
        age = snapshot['age'] ?? 10,
        phoneNum = snapshot['phoneNum'] ?? '',
        role = snapshot['role'] ?? '',
        clubs = snapshot['clubs'] ?? List(),
        chats = snapshot['chats'] ?? List();

  /// Convert userData Class format into JSON format for Firestore
  toJson() {
    return {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "age": age,
      "phoneNum": phoneNum,
      "role": role,
      "clubs": clubs,
      "chats": chats,
    };
  }

  /// Add new club, clubId that user signed up
  void addClub(clubId) {
    if (!clubs.contains(clubId)) {
      clubs.add(clubId);
    }
  }

  /// Make sure to no blank space around the first name
  String firstNameTrimmed() {
    return this.firstName.trim();
  }
}

/// User Model class
///
/// This class is only used for the Firestore Authentication
/// Uid and Email value are passed to userData.dart class after Authentication

class User {
  final String uid;
  final String email;

  User({this.uid, this.email});
}

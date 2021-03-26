/// Board Model Class
///
/// This class is the schema for the announcement
/// (ie. the script under noticeBoards Directory)
///
/// Usually works with Firestore database.

class Board {
  String boardId;
  String uid;
  String firstName;
  String lastName;
  String clubId;
  String subject;
  String body;
  DateTime timestamp;
  bool pinned;

  Board(
      {this.boardId,
      this.uid,
      this.firstName,
      this.lastName,
      this.clubId,
      this.subject,
      this.body,
      this.timestamp,
      this.pinned});

  /// Convert JSON format (output of Firestore query) into Board Class
  Board.fromMap(Map snapshot, String boardId)
      : boardId = boardId ?? '',
        uid = snapshot['uid'] ?? '',
        firstName = snapshot['firstName'] ?? '',
        lastName = snapshot['lastName'] ?? '',
        clubId = snapshot['clubId'] ?? '',
        subject = snapshot['subject'] ?? '',
        body = snapshot['body'] ?? '',
        timestamp = DateTime.fromMillisecondsSinceEpoch(
                snapshot['timestamp'].seconds * 1000) ??
            DateTime.fromMicrosecondsSinceEpoch(0),
        pinned = snapshot['pinned'] ?? false;

  /// Convert Board Class format into JSON format for Firestore
  toJson() {
    return {
      'clubId': clubId,
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'subject': subject,
      'body': body,
      'timestamp': timestamp,
      'pinned': pinned,
    };
  }
}

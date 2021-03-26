/// Workout Model Class
///
/// This class is the schema for the workout
/// (ie. scripts under trainings directory)
///
/// Usually works with Firestore database.

class Workout {
  final String workoutId;
  final String title;
  final DateTime startTime; //time class
  final DateTime endTime; //time class
  final int duration; //in minutes
  final List<dynamic> groupNumList;
  final String location;
  final String workoutDescription;
  final String comment;
  final List<dynamic> attendingUser;
  List<dynamic> crewGroups;
  final String clubId; //foreign key from club.dart model

  Workout({
    this.workoutId,
    this.title,
    this.startTime,
    this.endTime,
    this.duration,
    this.groupNumList,
    this.location,
    this.workoutDescription,
    this.comment,
    this.attendingUser,
    this.clubId,
    this.crewGroups,
  });

  /// Convert JSON format (output of Firestore query) into Workout Class
  Workout.fromMap(Map snapshot, String id)
      : workoutId = id ?? '',
        title = snapshot['title'] ?? '',
        startTime = DateTime.fromMillisecondsSinceEpoch(
                snapshot['startTime'].seconds * 1000) ??
            DateTime.fromMicrosecondsSinceEpoch(0),
        endTime = DateTime.fromMillisecondsSinceEpoch(
                snapshot['endTime'].seconds * 1000) ??
            DateTime.fromMicrosecondsSinceEpoch(0),
        //endTime = snapshot['endTime'].toDate() ?? DateTime.fromMicrosecondsSinceEpoch(0),
        duration = snapshot['duaration'] ?? 0,
        groupNumList = snapshot['groupNumList'] ?? [],
        location = snapshot['location'] ?? '',
        workoutDescription = snapshot['workoutDescription'] ?? '',
        comment = snapshot['comment'] ?? '',
        attendingUser = snapshot['attendingUser'] ?? [],
        crewGroups = snapshot['crewGroups'] ?? [],
        clubId = snapshot['clubId'] ?? '';

  /// Convert Workout Class format into JSON format for Firestore
  toJson() {
    return {
      "title": title,
      "startTime": startTime,
      "endTime": endTime,
      "duration": duration,
      "groupNumList": groupNumList,
      "comment": comment,
      "workoutDescription": workoutDescription,
      "location": location,
      "attendingUser": attendingUser,
      "clubId": clubId,
      "crewGroups": crewGroups,
    };
  }
}

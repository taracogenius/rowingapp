/// Crew Model Class
///
/// This class is the schema for the Crew Model
/// (ie. scripts under the CrewCreation directory)
///
/// Usually works with Firestore database.

class CrewModel {
  final String coach;
  String boatID;
  List<String> athletes;
  String boatType;

  CrewModel({this.coach, this.boatID, this.athletes, this.boatType});

  /// Convert JSON format (output of Firestore query) into CrewModel Class
  CrewModel.fromMap(Map snapshot, String coach)
      : coach = coach,
        boatID = snapshot['boatID'] ?? '',
        athletes = snapshot['athletes'] ?? [],
        boatType = snapshot["boatType"] ?? '';

  /// Convert CrewModel Class format into JSON format for Firestore
  toJson() {
    return {
      "coach": coach,
      "boatID": boatID,
      "athletes": athletes,
      "boatType": boatType,
    };
  }
}

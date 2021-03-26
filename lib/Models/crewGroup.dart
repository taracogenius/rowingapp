/// Crew Group Model Class
///
/// This class is the schema for the Crew 'Group' Model
/// (ie. scripts under the CrewCreation directory)
///
/// Usually works with Firestore database.

class CrewGroup {
  final int groupNum;
  String coach;
  List<String> boatIdList;

  CrewGroup({this.groupNum, this.coach, this.boatIdList});

  /// Convert JSON format (output of Firestore query) into CrewGroup Class
  CrewGroup.fromMap(Map snapshot, int num)
      : groupNum = num,
        coach = snapshot['coach'] ?? '',
        boatIdList = snapshot['boatIdList'] ?? [];

  /// Convert CrewModel Class format into JSON format for Firestore
  toJson() {
    return {
      "coach": coach,
      "boatIdList": boatIdList,
    };
  }

  void setCoach(String newCoach) {
    coach = newCoach;
  }
}

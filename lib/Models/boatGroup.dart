class BoatGroup {
  final String groupId;
  final String clubId;

  BoatGroup({this.groupId, this.clubId});

  BoatGroup.fromMap(Map snapshot, String id)
      : groupId = id ?? '',
        //boatType = snapshot['boatType'] ?? '',
        clubId = snapshot['clubId'] ?? '';

  toJson() {
    return {
      //"boatType": boatType,
      "clubId": clubId,
    };
  }
}

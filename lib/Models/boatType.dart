/// Boat Type Model Class
///
/// This class is the schema for the Boat Type Model
/// (ie. scripts under the Boats directory)
///
/// Usually works with Firestore database.

class BoatType {
  final String boatType;
  final String name;
  final String riggedAs;

  BoatType({this.boatType, this.name, this.riggedAs});

  /// Convert JSON format (output of Firestore query) into BoatType Class
  BoatType.fromMap(Map snapshot, String id)
      : boatType = id ?? '',
        name = snapshot['name'] ?? '',
        riggedAs = snapshot['riggedAs'] ?? '';

  /// Convert BoatType Class format into JSON format for Firestore
  toJson() {
    return {
      "name": name,
      "boatType": boatType,
      'riggedAs': riggedAs,
    };
  }
}

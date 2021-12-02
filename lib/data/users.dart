class Users {
  String name;
  double latitude, longitude, accuracy, battery;
  Users({required this.name, required this.battery, required this.latitude, required this.longitude, required this.accuracy});

  factory Users.fromJson(Map<String, dynamic> jsonData) {

    return Users(
        name: jsonData['name'],
        battery: jsonData['battery'],
        latitude: jsonData['latitude'],
        longitude: jsonData['longitude'],
        accuracy: jsonData['accuracy'],
    );
  }

}
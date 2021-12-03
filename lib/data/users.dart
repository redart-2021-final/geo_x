class Users {
  String name;
  double latitude, longitude, accuracy, battery;
  Users({required this.name, required this.battery, required this.latitude, required this.longitude, required this.accuracy});

  factory Users.fromJson(Map<String, dynamic> jsonData) {

    return Users(
        name: jsonData['username']?? 'none name',
        battery: jsonData['battery']?? 0.0,
        latitude: jsonData['latitude']?? 0.0,
        longitude: jsonData['longitude']?? 0.0,
        accuracy: jsonData['accuracy']?? 0.0,
    );
  }

}
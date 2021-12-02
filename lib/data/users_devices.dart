class UsersDevices {
  String name, device_name, location_name;
  int id, device_id, location_id;
  UsersDevices({required this.name, required this.device_name, required this.location_name, required this.id, required this.device_id, required this.location_id});

  factory UsersDevices.fromJson(Map<String, dynamic> jsonData) {

    return UsersDevices(
      name: jsonData['name'],
      device_name: jsonData['device']==null?null:jsonData['device']['name'],
      location_name: jsonData['location']==null?null:jsonData['location']['name'],
      id: jsonData['id'],
      device_id: jsonData['device']==null?null:jsonData['device']['id'],
      location_id: jsonData['location']==null?null:jsonData['location']['id'],
    );
  }

}
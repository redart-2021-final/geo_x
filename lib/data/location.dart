class Location {
  String name, description;
  int parent, id;
  double current_consumption, max_consumption, tariff;
  Location({required this.name, required this.description, required this.parent, required this.current_consumption, required this.max_consumption, required this.id, required this.tariff});

  factory Location.fromJson(Map<String, dynamic> jsonData) {

    return Location(
        name: jsonData['name'],
        description: jsonData['description'],
        parent: jsonData['parent'],
        max_consumption: jsonData['max_consumption']!=null?jsonData['max_consumption']:0.0,
        current_consumption: jsonData['current_consumption']!=null?jsonData['current_consumption']:0.0,
        id: jsonData['id'],
        tariff: jsonData['tariff']
    );
  }

}
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:geo_x/data/session_options.dart';
import 'package:geo_x/data/static_variable.dart';
import 'package:geo_x/data/users.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:geo_x/forms/account.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:geo_x/directions_model.dart';
import 'package:geo_x/directions_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController pageController = PageController();
  CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  late GoogleMapController _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;
  List<Marker> _markers = <Marker>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.wait([getInitialCameraPosition()]).then((_) => setState(() {}));
    _getLocation();
  }

  _getLocation() {
    late LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      print('android');
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        //forceLocationManager: true,
        intervalDuration: const Duration(seconds: 30),
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {

      postMessage(position);
      print(position == null
          ? 'Unknown'
          : position.latitude.toString() +
              ', ' +
              position.longitude.toString());
    });
  }

  postMessage(Position position) async{

    // try {
    //   var response = await http.post(
    //       Uri.parse('${ServerUrl}/users/children'),
    //       headers: {
    //         'Authorization': 'Basic ${AuthorizationString}',
    //         'content-type': 'application/json',
    //       },
    //       body: '{"username": "${username.text}", "password": "${password.text}"}');
    //
    //   if (response.statusCode >= 200 && response.statusCode < 300) {
    //     Navigator.pop(context);
    //
    //   } else {
    //     LoadingStop(context);
    //     print("Response status: ${response.statusCode}");
    //     print("Response body: ${response.body}");
    //     CreateshowDialog(
    //         context,
    //         new Text(
    //           response.body,
    //           style: new TextStyle(fontSize: 16.0),
    //         ));
    //   }
    // } catch (error) {
    //   LoadingStop(context);
    //   print(error.toString());
    //   CreateshowDialog(
    //       context,
    //       new Text(
    //         'Ошибка соединения с сервером',
    //         style: new TextStyle(fontSize: 16.0),
    //       ));
    // };
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  Future<void> getInitialCameraPosition() async {
    Position test = await _determinePosition();
    print('Точность ' + test.accuracy.toString());
    print('Высота ' + test.altitude.toString());
    print('Пол ' + test.floor.toString());
    print('Широта ' + test.latitude.toString());
    print('Долгота ' + test.longitude.toString());
    print('Скорость ' + test.speed.toString());
    print('Заголовок ' + test.heading.toString());

    CameraPosition newPosition = CameraPosition(
      target: LatLng(test.latitude, test.longitude),
      zoom: 11.5,
    );
    CameraUpdate update = CameraUpdate.newCameraPosition(newPosition);
    _googleMapController.moveCamera(update);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('GEO X'),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (controller) => _googleMapController = controller,
                markers: Set<Marker>.of(_markers),
                polylines: {
                  if (_info != null)
                    Polyline(
                      polylineId: const PolylineId('overview_polyline'),
                      color: Colors.red,
                      width: 5,
                      points: _info!.polylinePoints
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList(),
                    ),
                },
              ),
              if (_info != null)
                Positioned(
                  top: 20.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        )
                      ],
                    ),
                    child: Text(
                      '${_info!.totalDistance}, ${_info!.totalDuration}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Text('test')
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_alarms_outlined), label: 'Uvedom'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: onTapped,
      ),
      bottomSheet: _selectedIndex==0?FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return Container(
                  //width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 10,
                  child: ListView.builder(

                    //shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Users user_data = snapshot.data[index];
                      print(user_data.color);

                      return Container(
                          width: MediaQuery.of(context).size.width / 4,
                          //height: MediaQuery.of(context).size.height / 10,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                side: BorderSide(width: 0.5, color: Colors.black,)
                              ),
                          onPressed: () {

                            CameraPosition newPosition = CameraPosition(
                              target: LatLng(user_data.latitude, user_data.longitude),
                              zoom: 11.5,
                            );
                            CameraUpdate update = CameraUpdate.newCameraPosition(newPosition);
                            _googleMapController.moveCamera(update);

                          },
                          child: Row(
                            children: [
                              Icon(Icons.pin_drop, color: Color(int.parse('0xFF'+user_data.color))),
                              Text(user_data.name)
                            ],
                          )));
                      return ListTile(
                        title: Text(user_data.name),
                      );
                    },
                  ));
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
        future: getUsersForGroup(),
      ):null,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AccountPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addMarker(Users user_data) async {
    print('okk');
    _markers.add(
        Marker(
          markerId: MarkerId(user_data.name),
          infoWindow: InfoWindow(title: user_data.name),
          icon: await getClusterMarker(
            user_data.name,
            Color(int.parse('0xFF'+user_data.color)),
            Colors.white,
            80,
          ),
          position: LatLng(user_data.latitude, user_data.longitude),
        ));

  }

  Future<BitmapDescriptor> getClusterMarker(
      String text,
      Color clusterColor,
      Color textColor,
      int width,
      ) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = clusterColor;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    final double radius = width / 2;
    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );
    textPainter.text = TextSpan(
      text: text,
      style: TextStyle(
        fontSize: radius - 10,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        radius - textPainter.width / 2,
        radius - textPainter.height / 2,
      ),
    );
    final image = await pictureRecorder.endRecording().toImage(
      radius.toInt() * 2,
      radius.toInt() * 2,
    );
    final data = await image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  getUsersForGroup() async {
    try {
      var response =
          await http.get(Uri.parse('${ServerUrl}/users/children'), headers: {
        'Authorization': 'Basic ${AuthorizationString}',
      });
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        List map_data = data.map((data) => new Users.fromJson(data)).toList();

        _markers.clear();
          for(var map_data_el in map_data){
            _addMarker(map_data_el);
          }


        return map_data;
      } else {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        return null;
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
    ;
  }
}

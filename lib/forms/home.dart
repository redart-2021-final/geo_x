import 'dart:async';

import 'package:flutter/foundation.dart';
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.wait([getInitialCameraPosition()])
        .then((_) => setState(() {}));
    _getLocation();
  }

  _getLocation(){

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

    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position position) {
              print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
        });

  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  Future<void> getInitialCameraPosition() async{
    Position test  = await _determinePosition();
    print('Точность '+test.accuracy.toString());
    print('Высота '+test.altitude.toString());
    print('Пол '+test.floor.toString());
    print('Широта '+test.latitude.toString());
    print('Долгота '+test.longitude.toString());
    print('Скорость '+test.speed.toString());
    print('Заголовок '+test.heading.toString());

    CameraPosition newPosition = CameraPosition(
      target: LatLng(test.latitude, test.longitude),
      zoom: 11.5,
    );
    CameraUpdate update =CameraUpdate.newCameraPosition(newPosition);
    _googleMapController.moveCamera(update);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
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

  void onTapped(int index){
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
        // actions: [
        //   if (_origin != null)
        //     TextButton(
        //       onPressed: () => _googleMapController.animateCamera(
        //         CameraUpdate.newCameraPosition(
        //           CameraPosition(
        //             target: _origin!.position,
        //             zoom: 14.5,
        //             tilt: 50.0,
        //           ),
        //         ),
        //       ),
        //       style: TextButton.styleFrom(
        //         primary: Colors.green,
        //         textStyle: const TextStyle(fontWeight: FontWeight.w600),
        //       ),
        //       child: const Text('ORIGIN'),
        //     ),
        //   if (_destination != null)
        //     TextButton(
        //       onPressed: () => _googleMapController.animateCamera(
        //         CameraUpdate.newCameraPosition(
        //           CameraPosition(
        //             target: _destination!.position,
        //             zoom: 14.5,
        //             tilt: 50.0,
        //           ),
        //         ),
        //       ),
        //       style: TextButton.styleFrom(
        //         primary: Colors.blue,
        //         textStyle: const TextStyle(fontWeight: FontWeight.w600),
        //       ),
        //       child: const Text('DEST'),
        //     )
        // ],
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
                markers: {
                  if (_origin != null) _origin!,
                  if (_destination != null) _destination!
                },
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
                onLongPress: _addMarker,
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
          BottomNavigationBarItem(icon: Icon(Icons.access_alarms_outlined), label: 'Uvedom'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: onTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(
          _info != null
              ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
              : CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    print('okk');
    if (_origin == null || (_origin != null && _destination != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        // Reset destination
        _destination = null;

        // Reset info
        _info = null;
      });
    } else {
      // Origin is already set
      // Set destination
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Get directions
      final directions = await DirectionsRepository()
          .getDirections(origin: _origin!.position, destination: pos);
      setState(() => _info = directions);
    }
  }
}
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:signup/Functions/providerpunchin.dart';

class Location extends StatefulWidget {
  final Function(LatLng)? locationSelected;

  const Location({super.key, this.locationSelected});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  GoogleMapController? mapController;
  LatLng? _currentLocation;
  LatLng? _selectedLocation;

  final LatLng a1Location = const LatLng(12.98464, 77.54896);
  final LatLng a2Location = const LatLng(13.0003, 77.5497);

  
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final Set<Circle> _circles = {};

  Timer? _locationCheckTimer;

  @override
  void initState() {
    super.initState();
    _requestLocation();
    _startLocationCheck();
  }

  @override
  void dispose() {
    mapController?.dispose();
    _locationCheckTimer?.cancel();
    super.dispose();
  }
//requesting location permission
  void _requestLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('Location permission denied');
    } else {
      _getCurrentLocation();
    }
  }

//getting current location
  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        print('Current location :$_currentLocation');
      });
      _moveCameraToLocation(_currentLocation!);
      _addCurrentLocationMarker();
      
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

//adding marker for current location
  void _addCurrentLocationMarker() {
    setState(() {
      
   
    _markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: _currentLocation!,
        infoWindow: const InfoWindow(title: 'Current Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
      ),
    );
     });
  }

  void _moveCameraToLocation(LatLng location) {
    if (mapController != null) {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: location, zoom: 15),
        ),
      );
    }
  }
//fetching direction http request to get the google direction api 
  Future<void> _getDirections(LatLng destination) async {
    if (_currentLocation == null) return;

    const String googleAPIKey = 'AIzaSyDnjaaPOs3ywI5Hn3u2XL0f35q-2IcD17M';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleAPIKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String encodedPolyline =
            data['routes'][0]['overview_polyline']['points'];

        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> decodedPolyline =
            polylinePoints.decodePolyline(encodedPolyline);

        List<LatLng> polylineCoordinates = decodedPolyline
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      }
    } catch (e) {
      print('Error fetching directions: $e');
    }
  }
//checks if the current location is within a 100 mt radius - destination
  bool _isLocationMatch(LatLng currentLocation, LatLng destination) {
    const double proximityThresholdMeters = 100.0; // (in meters)

    double distanceInMeters = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      destination.latitude,
      destination.longitude,
    );

    return distanceInMeters <= proximityThresholdMeters;
  }
//bottom sheet
  void _showBottomSheet(LatLng destination) {
    String locationName = '';
    if (destination == a1Location) {
      locationName = 'a1';
    } else if (destination == a2Location) {
      locationName = 'a2';
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You have reached the destination: $locationName!'),
              ElevatedButton(
                onPressed: () async {
                  await _punchIn(destination);
                  Navigator.pop(context);
                },
                child: const Text('Punchin'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _punchIn(LatLng destination) async {
    DateTime now = DateTime.now();

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Update the existing document with current and destination location
    DocumentReference documentRef = firestore.collection('location').doc('document id ');

    Map<String, dynamic> locationData = {
      'currentLocation': GeoPoint(_currentLocation!.latitude, _currentLocation!.longitude),
      'destination': GeoPoint(destination.latitude, destination.longitude),
      'time': now,
    };

    await documentRef.set(locationData, SetOptions(merge: true)); // Use merge to update the same document
  }
//timer that checks the location for every 5 seconds 
  void _startLocationCheck() {
    _locationCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentLocation != null && _selectedLocation != null) {
        if (_isLocationMatch(_currentLocation!, _selectedLocation!)) {
          _showBottomSheet(_selectedLocation!);
          _locationCheckTimer?.cancel();
        } else {
          _updateCurrentLocationInFirebase();
        }
      }
    });
  }

  Future<void> _updateCurrentLocationInFirebase() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentRef = firestore.collection('location').doc('document_id'); 

    if (_currentLocation != null) {
      Map<String, dynamic> updateData = {
        'currentLocation': GeoPoint(_currentLocation!.latitude, _currentLocation!.longitude),
      };
      await documentRef.set(updateData, SetOptions(merge: true)); // Use merge to update the same document
    }
  }

  @override
  Widget build(BuildContext context) {
    final punch = Provider.of<punchinprovider>(context);

    if (punch.punchintext == 'a1') {
      _selectedLocation = a1Location;
    } else if (punch.punchintext == 'a2') {
      _selectedLocation = a2Location;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
      ),
      body: _currentLocation == null || _selectedLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.terrain,
              onMapCreated: (controller) {
                mapController = controller;
                _moveCameraToLocation(_currentLocation!);
                _updateDestinationMarkerAndCircle();
              },
              markers: _markers,
              polylines: _polylines,
              circles: _circles,
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 10,
              ),
            ),
    );
  }
//destination marker and circles
  void _updateDestinationMarkerAndCircle() {
    if (_selectedLocation != null && mapController != null) {
      setState(() {
        _markers.removeWhere((marker) => marker.markerId.value.startsWith('destination'));
        _circles.removeWhere((circle) => circle.circleId.value.startsWith('destination'));

        _markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: _selectedLocation!,
            infoWindow: const InfoWindow(title: 'Destination'),
            // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),
        );

        _circles.add(
          Circle(
            circleId: const CircleId('destinationCircle'),
            center: _selectedLocation!,
            radius: 20,
            fillColor: Colors.green.withOpacity(0.3),
            strokeColor: Colors.green,
            strokeWidth: 1,
          ),
        );

        _getDirections(_selectedLocation!);
      });
    }
  }
}

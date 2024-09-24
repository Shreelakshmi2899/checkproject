import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackOrderPage extends StatefulWidget {
  final int ?orderId;

  const TrackOrderPage({super.key, required this.orderId});

  @override
  _TrackOrderPageState createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  double deliveryLatitude = 0.0;
  double deliveryLongitude = 0.0;
  double userLatitude = 0.0;
  double userLongitude = 0.0;
  bool loading = true;

  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  StreamSubscription<DocumentSnapshot>? _locationStreamSubscription;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
    _listenToLocationUpdates();
  }

  @override
  void dispose() {
    _locationStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> fetchOrderDetails() async {
    try {
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('order')
          .doc(widget.orderId.toString())
          .get();

      if (orderSnapshot.exists) {
        setState(() {
          deliveryLatitude = orderSnapshot['delivery_latitude'];
          deliveryLongitude = orderSnapshot['delivery_longitude'];
          userLatitude = orderSnapshot['user_latitude'];
          userLongitude = orderSnapshot['user_longitude'];
          loading = false;
        });
        _updateMarkers();
      } else {
        print('Order not found for ID: ${widget.orderId}');
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print('Error fetching order details: $e');
      setState(() {
        loading = false;
      });
    }
  }

  void _listenToLocationUpdates() {
    _locationStreamSubscription = FirebaseFirestore.instance
        .collection('order')
        .doc(widget.orderId.toString())
        .snapshots()
        .listen((orderSnapshot) {
      if (orderSnapshot.exists) {
        setState(() {
          deliveryLatitude = orderSnapshot['delivery_latitude'];
          deliveryLongitude = orderSnapshot['delivery_longitude'];
        });
        _updateMarkers();
      }
    });
  }

  void _updateMarkers() {
    _markers.clear();
    if (userLatitude != 0.0 && userLongitude != 0.0) {
      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(userLatitude, userLongitude),
          infoWindow: const InfoWindow(title: 'User Location'),
        ),
      );
    }

    if (deliveryLatitude != 0.0 && deliveryLongitude != 0.0) {
      _markers.add(
        Marker(
          markerId: const MarkerId('delivery_location'),
          position: LatLng(deliveryLatitude, deliveryLongitude),
          infoWindow: const InfoWindow(title: 'Delivery Location'),
        ),
      );
    }

    setState(() {});
  }

  double _calculateDistance() {
    if (userLatitude != 0.0 &&
        userLongitude != 0.0 &&
        deliveryLatitude != 0.0 &&
        deliveryLongitude != 0.0) {
      return Geolocator.distanceBetween(
            userLatitude,
            userLongitude,
            deliveryLatitude,
            deliveryLongitude,
          ) /
          1000; // convert to kilometers
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(deliveryLatitude, deliveryLongitude),
                      zoom: 14,
                    ),
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Distance between delivery and user: ${_calculateDistance().toStringAsFixed(2)} km',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }
}

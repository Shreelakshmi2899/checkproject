import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class  location extends StatefulWidget {
  final Function(LatLng) ? locationselected;  
  const location({super.key, this.locationselected});

  @override
  State<location> createState() => _locationState();
}

class _locationState extends State<location> {

  GoogleMapController? mapController;
  LatLng? _selectedlocation;
  StreamSubscription<Position>? positionStream;


  
   @override
  void initState() {
    super.initState();
    _requestlocation();
    
  }
  @override
  void dispose (){
    positionStream?.cancel();
    super.dispose();
  }

  void _requestlocation()async{
    LocationPermission permission = await Geolocator.requestPermission();

    if(permission == LocationPermission.denied) {
      print('Location permission denied');

    }else if (permission == LocationPermission.deniedForever){
      print('Location permission denied forever');
    }else {
      _getCurrentLocation();
    }
  }

  void _getCurrentLocation() async {
    try{
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('Latitude: ${position.latitude }, Longitude: ${position.longitude}');
      setState(() {
        _selectedlocation = LatLng(position.latitude, position.longitude);
      });
    }catch (e) {
      print('Error getting current location : $e');
    }

  }

  void _listenToLocationChanges() {
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _selectedlocation = LatLng(position.latitude, position.longitude);
        _moveCameraToLocation(_selectedlocation!);
      });
    });
  }

  void _moveCameraToLocation(LatLng location) {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: location, zoom: 15)));
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: SizedBox(width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(children: [
           Expanded(child: 
          GoogleMap(
            mapType: MapType.terrain,
            onMapCreated: (controller) => {
              mapController = controller
              },
            onTap: (LatLng){
              
              setState(() {
                _selectedlocation = LatLng;
              });
            },
            
            
            markers : _selectedlocation != null    //current location is not null
            ? {
              Marker(markerId: const MarkerId('selectedlocation'),
              position: _selectedlocation!,
              infoWindow: InfoWindow(
                title: 'Selected location',
                snippet:  'Lat : ${_selectedlocation!.latitude}, Lng : ${_selectedlocation!.longitude}',

              )
              ) 
            }
             : {},
            initialCameraPosition: const CameraPosition(target: LatLng(0 ,0),  //  we can pass our current location like bng lantitude and langitutde
            zoom: 10,    
            ),
            myLocationButtonEnabled: true,

          )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: ()  async {
                if(_selectedlocation!=null) {
                  print('Selected Location - Lat : ${_selectedlocation!.latitude} ,Lng : ${_selectedlocation!.longitude} ');
                  Navigator.pop(context);
                  widget.locationselected?.call(_selectedlocation!);
                }else {
            
                }
            
              },
              child: const Icon(Icons.check,color:Colors.white),
              ),
          ),
        ],),),
    );
  }
}
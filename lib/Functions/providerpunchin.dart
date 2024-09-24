import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class punchinprovider with ChangeNotifier{
   String punchintext = 'a1'; //default
   LatLng? currentlocation;
    LatLng? selectedlocation; //to store selected location

  

  void setpunch( String text){
    punchintext =text;
    notifyListeners();

  }

  void setcurrentlocation(LatLng location){
    currentlocation = location;
    notifyListeners();
  }


  void setSelectedLocation(LatLng location) {
    selectedlocation = location;
    notifyListeners();
  }

  
}



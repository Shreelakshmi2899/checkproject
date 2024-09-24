
import 'package:flutter/material.dart';

//this class use inheritance

class numberlistprovider extends ChangeNotifier{
   List<int> numbers = [1,2,3,4];

   void add(){
    int last = numbers.last;
    numbers.add(last+1);
    notifyListeners();
   }
}
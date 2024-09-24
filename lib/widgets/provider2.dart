import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:signup/widgets/list_provider.dart';

class provider_2 extends StatefulWidget {
  const provider_2({super.key, 
  // required this.numbers
  });

  // final List<int> numbers;

  @override
  State<provider_2> createState() => _provider_2State();
}

class _provider_2State extends State<provider_2> {
  // List<int> numbers = [1,2,3,4]
  @override
  Widget build(BuildContext context) {
    return Consumer<numberlistprovider>(
        builder:(context, numbersmodel,child)  => Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          numbersmodel.add();
        // int last = widget.numbers.last;
        // setState(() {
        //   widget.numbers.add(last+1);
        // }
        // );
        },

      child: const Icon(Icons.add),),
      appBar: AppBar(),
      body:  SizedBox(
          child: Column(children: [
             Text(numbersmodel.numbers.last.toString(),
            style: const TextStyle(fontSize: 30),),
        
            SizedBox(
              height: 200,
              width: double.maxFinite,
              child: ListView.builder(
                scrollDirection: Axis.horizontal ,
                itemCount: numbersmodel.numbers.length,
                itemBuilder: (context, index) {
                  return   Text(numbersmodel.numbers[index].toString(),
                  style: const TextStyle(
                    fontSize: 30),
                    );
                },
              ),
            ),
        
          ],),
        ),
      ),
    


    );
  }
} 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signup/Functions/location.dart';
import 'package:signup/Functions/locationpickalert.dart';
import 'package:signup/Functions/providerpunchin.dart';
import 'package:signup/widgets/signup.dart';

class punch_in extends StatefulWidget {
  const punch_in({super.key});

  @override
  State<punch_in> createState() => _punch_inState();
}

class _punch_inState extends State<punch_in> {
  @override
  Widget build(BuildContext context) {
    return Consumer<punchinprovider>(
      builder: (context, punch, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Map Screen'),
        ),
        body: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Location(
                      locationSelected: (location) {
                        punch.setcurrentlocation(location);
                        
                      },
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                  ),
                  child: Center(
                    child: Text(
                      punch.punchintext,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Sign_Up()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

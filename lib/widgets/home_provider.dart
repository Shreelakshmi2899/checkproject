import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signup/Functions/providerpunchin.dart';
import 'package:signup/widgets/punchin.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _HomepageState();
}

class _HomepageState extends State<home_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('homepage'),
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                context.read<punchinprovider>().setpunch('a1');
                
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const punch_in()),
                );
              },
              child: Container(
                height: 100,  
                width: 100,   
                decoration: const BoxDecoration(
                  color: Colors.amberAccent,
                ),
                child: const Center( 
                  child: Text(
                    '1',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
           const SizedBox(height: 20),
        GestureDetector(
           onTap: () {
            context.read<punchinprovider>().setpunch('a2');
            Navigator.push(context,MaterialPageRoute(builder: (context) => const punch_in()),
            );
          },
          child: Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(color: Colors.black87),
            child: const Center( 
        child: Text(
          '2',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white, 
          ),
        ),
            ),
          ),
        )
        
          ],
          
        ),
      ),
    );
  
  }
}
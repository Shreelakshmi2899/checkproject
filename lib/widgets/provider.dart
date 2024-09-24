import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signup/widgets/list_provider.dart';
import 'package:signup/widgets/provider2.dart';

class ProviderExample extends StatefulWidget {
  const ProviderExample({super.key});

  @override
  State<ProviderExample> createState() => _ProviderExampleState();
}

class _ProviderExampleState extends State<ProviderExample> {
  // List<int>numbers = [1,2,34,5]
  @override
  Widget build(BuildContext context) {
    return Consumer<numberlistprovider>(
        builder: (context, numbersModel, child) =>  Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add number to the list using provider
          numbersModel.add();
          // context.read<numberlistprovider>().add();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(),
      body: SizedBox(
          child: Column(
            children: [
              Text(
                numbersModel.numbers.last.toString(),
                style: const TextStyle(fontSize: 30),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: numbersModel.numbers.length,
                  itemBuilder: (context, index) {
                    return Text(
                      numbersModel.numbers[index].toString(),
                      style: const TextStyle(fontSize: 30),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const provider_2(),
                    ),
                  );
                },
                child: const Text('Next Page'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

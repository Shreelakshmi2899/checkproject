import 'package:flutter/material.dart';
import 'package:signup/widgets/homepage.dart';
import 'package:signup/widgets/trackorder.dart';
 

class OrderConfirmationPage extends StatelessWidget {
  final int  orderid;

  const OrderConfirmationPage({super.key, required this.orderid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Order Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text(
              'Your order has been placed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Order ID: $orderid'),
            // SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => TrackOrderPage(orderId: orderid),
            //       ),
            //     );
            //   },
            //   child: Text('Track Order'),
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Homepage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

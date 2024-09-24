// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:signup/widgets/cart.dart';

// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// class  cart_items extends StatefulWidget {
//   const cart_items({super.key});

//   @override
//   State<cart_items> createState() => _cart_itemsState();
// }

// class _cart_itemsState extends State<cart_items> {

//     int cartQuantity = 0;

//      @override
//   void initState() {
//     super.initState();
//     fetchCartQuantity();
//   }

//   void fetchCartQuantity() async {
//     final cartItems = await _firestore.collection('cart').get();
//     int totalQuantity = 0;
//      for (var item in cartItems.docs) {
//       totalQuantity += (item['quantity'] as num).toInt();
//     }
//     setState(() {
//       cartQuantity = totalQuantity;
//     });
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       color: Colors.grey[200],
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Text(
//             'Cart Quantity: $cartQuantity',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => Cart()));
//             },
//             child: Text('Go to Cart'),
//           ),
//         ],
//       )
//     );
//   }
// }
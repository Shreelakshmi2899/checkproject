import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:signup/widgets/cart.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class CartItems extends StatefulWidget {
  const CartItems({super.key});

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('cart').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color:  const Color.fromARGB(255, 242, 235, 235),
            child: Container(
              
               padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Items: 0',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const Cart()));
                    },
                    child: const Text('Go to Cart'),
                  ),
                ],
              ),
            ),
          );
        }

        int totalQuantity = 0;
        final cartItems = snapshot.data!.docs;
        for (var item in cartItems) {
          totalQuantity += (item['quantity'] as num).toInt();
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: const Color.fromARGB(255, 242, 235, 235),
          child: Container(
            
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  ' $totalQuantity item added ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Cart()));
                  },
                  child: const Text('Go to Cart'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

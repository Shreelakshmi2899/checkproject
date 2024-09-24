import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:signup/Functions/item.dart';
import 'package:signup/widgets/cart.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class wish_page extends StatefulWidget {
  const wish_page({super.key});

  @override
  State<wish_page> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<wish_page> {
  double calculatePrice(double price, int quantity) {
    return price * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.blueGrey,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
          ),
          flexibleSpace: const Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Wishlist',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('Wishlist').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }
          final wishlistItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              final item = wishlistItems[index];
              int quantity = item['quantity'] ?? 1;
              double price = (item['price'] as num).toDouble();
              double totalPrice = calculatePrice(price, quantity);

              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black,width: 0.2),
                    borderRadius: BorderRadius.circular(18),
                    color: const Color.fromARGB(255, 240, 237, 237)
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Row(
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: Image.network(
                            item['pimage'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['pname']),
                            const SizedBox(height: 4),
                            Text('Quantity: $quantity'),
                            const SizedBox(height: 4),
                            Text('Price: ₹ $totalPrice'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final cartSnapshot = await _firestore
                                        .collection('cart')
                                        .where('pname', isEqualTo: item['pname'])
                                        .get();
                                    if (cartSnapshot.docs.isEmpty) {
                                      await _firestore.collection('cart').add({
                                        'pname': item['pname'],
                                        'pimage': item['pimage'],
                                        'price': price,
                                        'quantity': quantity,
                                      });

                                      await _firestore.collection('Wishlist').doc(item.id).delete();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Cart(),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Item is already in cart'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Move to Cart'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      await _firestore.collection('Wishlist').doc(item.id).delete();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const CartItems(),
    );
  }
}

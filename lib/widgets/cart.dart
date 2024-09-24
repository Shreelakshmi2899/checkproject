import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:signup/widgets/order.dart';
import 'package:signup/widgets/wish.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int _totalPrice = 0;
  int _totalQuantity = 0;

  @override
  void initState() {
    super.initState();
    TotalPrice();
  }

  void TotalPrice() async {
    final cartItems = await _firestore.collection('cart').get();
    int total = 0;
    int quantity = 0;
    for (var item in cartItems.docs) {
      total += (item['price'] as num).toInt() * (item['quantity'] as num).toInt();
      quantity += (item['quantity'] as num).toInt();
    }
    setState(() {
      _totalPrice = total;
      _totalQuantity = quantity;
    });
  }

  void _incrementQuantity(DocumentSnapshot cartItem) async {
    int currentQuantity = cartItem['quantity'] ?? 0;
    final newQuantity = cartItem['quantity'] + 1;
    await _firestore.collection('cart').doc(cartItem.id).update({'quantity': newQuantity});
    TotalPrice();
  }

  void _decrementQuantity(DocumentSnapshot cartItem) async {
    int currentQuantity = cartItem['quantity'] ?? 0;
    final newQuantity = cartItem['quantity'] - 1;
    if (newQuantity > 0) {
      await _firestore.collection('cart').doc(cartItem.id).update({'quantity': newQuantity});
      TotalPrice();
    }
  }

  void _removeItem(DocumentSnapshot cartItem) async {
    await _firestore.collection('cart').doc(cartItem.id).delete();
    TotalPrice();
  }

  void _placeOrder() async {
    final cartItems = await _firestore.collection('cart').get();
    if (cartItems.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty!'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      final orderItems = cartItems.docs.map((doc) => {
        'pname': doc['pname'],
        'pimage': doc['pimage'],
        'price': doc['price'],
        'quantity': doc['quantity'],
      }).toList();

      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(
        orderitems: orderItems,
        totalamount: _totalPrice,
      )));
    }
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
          flexibleSpace: Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 60),
                  const Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.white),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const wish_page()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('cart').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final cartItems = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), 
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];


                      return Container(
                        decoration: BoxDecoration(
                      border: Border.all(color: Colors.black,width: 0.2),
                       borderRadius: BorderRadius.circular(18),
                      color: const Color.fromARGB(255, 240, 237, 237)
                    ),

                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: SizedBox(
                            height: 80,
                            width: 80,
                            child: Image.network(
                              cartItem['pimage'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(cartItem['pname']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total: ₹ ${(cartItem['price'] * cartItem['quantity']).toStringAsFixed(2)}'),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () => _decrementQuantity(cartItem),
                                  ),
                                  Text('${cartItem['quantity']}'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () => _incrementQuantity(cartItem),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeItem(cartItem),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Text('Total Items: $_totalQuantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Total Price: ₹ $_totalPrice', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _placeOrder,
                child: const Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

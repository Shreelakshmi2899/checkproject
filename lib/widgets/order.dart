import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:signup/Functions/item.dart';
import 'package:signup/Functions/locationpickalert.dart';
import 'package:signup/widgets/orderconfirmation.dart';

class OrderDetails extends StatefulWidget {
  final List<Map<String, dynamic>> orderitems;
  final int totalamount;

  const OrderDetails({super.key, required this.orderitems, required this.totalamount});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? selectedPaymentType;
  bool isEditingAddress = false;

  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
      setState(() {
        nameController.text = userDoc['name'] ?? 'No Name';
        emailController.text = userDoc['email'] ?? 'No Email';
        phoneNumberController.text = userDoc['number'] ?? 'No Phone';
        addressController.text = userDoc['address'] ?? 'No Address';
      });
    }
  }

  double calculatePrice(double price, int quantity) {
    return price * quantity;
  }

  void _placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && selectedLocation != null && selectedPaymentType != null) {
      try {
        // Fetch the current number of orders to generate the next order ID
        QuerySnapshot orderCount = await FirebaseFirestore.instance.collection('Orderdetails').get();
        int nextOrderId = orderCount.size + 1; // Generate the next sequential order ID

        // Prepare order details with unique product IDs
        List<Map<String, dynamic>> orderItemsWithId = widget.orderitems.map((item) {
          return {
            ...item,
            'order_id': nextOrderId// Assign sequential order ID
          };
        }).toList();

        // Prepare order details
        Map<String, dynamic> orderDetails = {
          'order_id': nextOrderId,
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneNumberController.text,
          'address': addressController.text,
          'payment_type': selectedPaymentType,
          'total_amount': widget.totalamount,
          'order_items': orderItemsWithId,
          'latitude': selectedLocation!.latitude,
          'longitude': selectedLocation!.longitude,
          'timestamp': FieldValue.serverTimestamp(),
        };

        
        await FirebaseFirestore.instance.collection('Orderdetails').add(orderDetails);
        
        final CartItems = await FirebaseFirestore.instance.collection('cart').get();
        for(var cartItem in CartItems.docs){
          await FirebaseFirestore.instance.collection('cart').doc(cartItem.id).delete();
        }

        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderConfirmationPage(orderid: nextOrderId,)));

        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order has been placed!'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Failed to store order: $e');
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to place order. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a location and payment type'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.blueGrey,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.0)),
          ),
          flexibleSpace: const Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Order Details',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.blueGrey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: nameController,
                                readOnly: true, // Make the field read-only
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.email, color: Colors.blueGrey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: emailController,
                                readOnly: true, // Make the field read-only
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.blueGrey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: phoneNumberController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Phone',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.blueGrey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: isEditingAddress
                                  ? TextField(
                                      controller: addressController,
                                      decoration: const InputDecoration(
                                        labelText: 'Address',
                                      ),
                                    )
                                  : Text(
                                      'Address: ${addressController.text}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                            ),
                            IconButton(
                              icon: Icon(isEditingAddress ? Icons.check : Icons.edit),
                              onPressed: () {
                                if (isEditingAddress) {
                                  FirebaseFirestore.instance
                                      .collection("user")
                                      .doc(FirebaseAuth.instance.currentUser!.uid)
                                      .update({'address': addressController.text});
                                }
                                setState(() {
                                  isEditingAddress = !isEditingAddress;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return location(locationselected: (LatLng userLocation) {
                                  setState(() {
                                    selectedLocation = userLocation;
                                  });
                                  print('Selected location - Lat: ${userLocation.latitude}, Lng: ${userLocation.longitude}');
                                });
                              },
                            );
                          },
                          child: const Text('Select Location'),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.payment, color: Colors.blueGrey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Payment Type',
                                ),
                                value: selectedPaymentType,
                                items: ['Cash on Delivery', 'PhonePe', 'Google Pay']
                                    .map((paymentType) => DropdownMenuItem(
                                          value: paymentType,
                                          child: Text(paymentType),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymentType = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Order Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.orderitems.length,
                itemBuilder: (context, index) {
                  final orderItem = widget.orderitems[index];
                  int quantity = orderItem['quantity'] ?? 1;
                  double price = (orderItem['price'] as num).toDouble();
                  double totalPrice = calculatePrice(price, quantity);

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(5),
                        leading: SizedBox(
                          height: 80,
                          width: 80,
                          child: Image.network(
                            orderItem['pimage'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(orderItem['pname']),
                            const SizedBox(height: 4),
                            Text('Quantity: $quantity'),
                            const SizedBox(height: 4),
                            Text('Price: ₹ $totalPrice'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Total Amount: ₹ ${widget.totalamount}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _placeOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          textStyle: const TextStyle(fontSize: 20),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text('Order'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

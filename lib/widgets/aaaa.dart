//Future<int?> fetchOrderID() async {
  //   try {
  //     QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
  //         .collection('order')
  //         .where('user_id', isEqualTo: authService.currentUser!.uid)
  //         .get();

  //     if (orderSnapshot.docs.isNotEmpty) {
  //       return orderSnapshot.docs.first['order_id'] as int;
  //     } else {
  //       print('No orders found for user: ${authService.currentUser!.uid}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error fetching order ID: $e');
  //     return null;
  //   }
  // }
//
//
//
//
//
//
//
//
//
// Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: GestureDetector(
//                       onTap: () async {
//                         int? orderID = await fetchOrderID();
//                         if (orderID != null) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   TrackOrderPage(orderId: orderID),
//                             ),
//                           );
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text('No order found for tracking'),
//                             ),
//                           );
//                         }
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black, width: 0.2),
//                           borderRadius: BorderRadius.circular(18),
//                           color: Color.fromARGB(255, 244, 238, 238),
//                         ),
//                         child: ListTile(
//                           leading: Icon(Icons.track_changes, color: Colors.blueGrey),
//                           title: Text(
//                             'Track Order',
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.normal),
//                           ),
//                           trailing:
//                               Icon(Icons.arrow_forward_ios, color: Colors.blueGrey),
//                         ),
//                       ),
//                     ),
//                   ),
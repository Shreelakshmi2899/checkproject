import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:signup/Functions/categorydb.dart';
import 'package:signup/Functions/item.dart';
import 'package:signup/widgets/cart.dart';

import '../Functions/categorydb.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
class product_details extends StatefulWidget {
 

  const product_details({super.key,
  // this.proimage,  
  // this.productname, 
  // this.prodprice,
  //  this.prodqunatity, 
  //  this.prodescription,
    required this.reference,  });
  
  // final proimage;
  // final productname;
  // final prodprice;
  // final prodqunatity;
  // final prodescription;

   final DocumentReference reference;
  
   //final DocumentReference wishreference;
   
     

  @override
  State<product_details> createState() => _product_detailsState();
}

class _product_detailsState extends State<product_details> {
  
    DocumentSnapshot ? productSnapshot;
    int quantity = 1;
    bool isfavorite = false;
    double newprice = 0.0;
  



    @override
  void initState() {
    super.initState();
    getProductDetails();
  }

  void getProductDetails() async {
    final snapshot = await widget.reference.get();
    setState(() {
      productSnapshot = snapshot;
      quantity =snapshot['quantity'] ?? 1;
      newprice = (snapshot['price']as num ).toDouble()*quantity;
    });

     _firestore.collection('cart').where('pname', isEqualTo: productSnapshot!['pname']).snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final cartItem = snapshot.docs.first;
        setState(() {
          quantity = cartItem['quantity'];
          newprice = (productSnapshot!['price'] as num).toDouble() * quantity;
        });
      }
    });
  }
  

  

  void _incrementquantity() async {
    setState(() {
      quantity++;
      newprice = (productSnapshot!['price']as num).toDouble()*quantity;
      
    });
    await updateCart();
    await updatewishlist();
  }

  void _decrementquantity()async{
    setState(() {
      if(quantity > 1){
        quantity--;
         newprice = (productSnapshot!['price']as num).toDouble()*quantity;
      }
    });
      await updateCart();
      await updatewishlist();
  }
  
   Future<void> updateCart() async {
    final snapshot = await _firestore.collection('cart')
    .where('pname', isEqualTo: productSnapshot!['pname']).get();
    if (snapshot.docs.isNotEmpty) {
      await _firestore.collection('cart').doc(snapshot.docs.first.id).update({
        'quantity': quantity,
        'totalPrice': newprice.toInt(),});
    }
  }

  Future<void> updatewishlist() async {
    final wishlistsnap = await _firestore.collection('Wishlist')
    .where('pname', isEqualTo: productSnapshot!['pname']).get();
    
    for (var doc in wishlistsnap.docs) {
      await _firestore.collection('Wishlist').doc(doc.id).update({
        'quantity': quantity,
        'totalPrice': newprice.toInt(),});
    }
  }

  void favorite() async {
    setState(() {
      
      isfavorite = !isfavorite;
    });

    final wishlistsnap  = await _firestore
    .collection('Wishlist')
    .where('pname', isEqualTo: productSnapshot!['pname'])
    .get();


     if (isfavorite){
      if (wishlistsnap.docs.isEmpty) {
      await _firestore.collection('Wishlist').add({
        'pname' :productSnapshot!['pname'],
        'pimage' : productSnapshot!['pimage']?? '',
        'price': productSnapshot!['price'],
        'quantity':quantity,
         'totalPrice': newprice,
       
      }
      );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: 
          Text('Added to wishlist',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),),
           duration: Duration(seconds: 2),
          )
        );

      }
    }else{
      
      for (var doc in wishlistsnap.docs) {
        await _firestore.collection('Wishlist').doc(doc.id).delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: 
          Text('Removed from wishlist',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          ),
           duration: Duration(seconds: 2),
          )
        );
    }
  }

  void cart ()async{
    if (productSnapshot != null) {
      final snapshot = await _firestore.collection('cart')
      .where('pname', isEqualTo: productSnapshot!['pname']).get();
     

      if (snapshot.docs.isEmpty){
    await _firestore.collection('cart').add({
      'pname' :productSnapshot!['pname'] ?? '',
      'pimage' : productSnapshot!['pimage'],
        'price': productSnapshot!['price'],
        'quantity' :productSnapshot!['quantity']?? 1,
        'quantity' : quantity,
        'totalPrice': newprice,

       
    });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: 
     Text('Added to cart',
     style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          ),
     duration: Duration(seconds: 2),

)
);
 }else{
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: 
    Text('Item already in cart',style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          ),
    duration: Duration(seconds: 2),

    )
  );
 }
    //  Navigator.push(context, MaterialPageRoute(builder: (context)=> Cart()));
    
  }
  }

  @override
  Widget build(BuildContext context) {
   if (productSnapshot == null) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
       body: const Center(child: CircularProgressIndicator()),

       );
    }
       final product = productSnapshot!;
      return Scaffold(
      appBar: PreferredSize(
         preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.blueGrey,
          shape: const RoundedRectangleBorder(
            borderRadius:  BorderRadius.vertical(bottom: Radius.circular(40.0)),
          ),
        flexibleSpace:  Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                 product['pname'],
                style: const TextStyle(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
                color:Color.fromARGB(255, 250, 241, 241)
              
              ),
              
                    child:  Center(
                      child: Image.network(product['pimage']
                      , width: 200,
                      height: 200)
                      ),   
              
            ),
            
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                 
                                  Text(product['pname'],
                                      style: const TextStyle(fontSize: 16,fontWeight:FontWeight.bold)
                                      ),
                                    GestureDetector(
                                      onTap: favorite,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(255, 198, 193, 193),
                                          shape: BoxShape.rectangle
                                        ),
                                        child:
                                         Icon(Icons.favorite_outlined,
                                        color: isfavorite? const Color.fromARGB(255, 234, 55, 55) : const Color.fromARGB(255, 232, 217, 216)
                                        ),
                                        
                                        
                                        
                                      ),
                                    )
                                  
                                ],
                                
                              ),
                              const SizedBox(height:20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text( 'Price: ₹ ${newprice.toStringAsFixed(2)}',),
                                ],
                              ),
                        
                              const SizedBox(height: 10),
                              
                              Row(
                                children: [
                                  SizedBox(height: 30,width:30,
                                  child: OutlinedButton(
                                     style: OutlinedButton.styleFrom(
                                       padding: EdgeInsets.zero,
                                     shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                   
                                    onPressed: _decrementquantity, 
                                    child:const Icon(Icons.remove),
                                  ),
                        
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.only(left: 5),
                                   child: SizedBox(
                                    height: 30,width: 40,
                                   child:OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                       padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      )
                                    ),
                                    onPressed: () {}, 
                                    child: Text('$quantity')
                                    )
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.only(left: 5),
                                   child: SizedBox(height: 30,width: 30,
                                   child:OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                       padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )
                                    ),
                                    onPressed: _incrementquantity, 
                                    child: const Icon(Icons.add)
                                   ),
                                   ),
                                 ),
                        
                                ],
                              
                              ),
                        
                              const SizedBox(height:10 ),
                              Text( product['description'],
                              ),
                              const SizedBox(height: 5),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Reviews'
                                  ),
                                  Icon(Icons.star)
                                ],
                              )
                                  
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  
              
                ],
              ),
            ),
             const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                  
                    onPressed:cart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                     padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 14),
                    textStyle: const TextStyle(fontSize: 18),
                    foregroundColor: Colors.white,
                  ),
                   // Navigator.push(context, MaterialPageRoute(builder: (context)=> Cart()));
                   child: Text('add to cart',
                  ),),
                )
            
            
          ],
        ),
      ),
      bottomNavigationBar: const CartItems(),
    );
  }
}

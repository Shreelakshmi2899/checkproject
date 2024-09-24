import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String name;
  final String image;
  final  DocumentReference reference;
  

  Category( {required this.name, required this.image,required this.reference });

  factory Category.fromDocument(DocumentSnapshot doc) {
     final data = doc.data() as Map<String, dynamic>;
    return Category(
      
      name: doc['name'],
      image: doc['image'],
       reference: doc.reference, 
      
    );
  }
}

class product {
  final String pname;
  final String pimage;
  final DocumentReference catref;
  final int quantity;
  final double price;
  final String description ;
   DocumentReference reference;

 

  

  product( {required this.pname, required this.pimage,required this.catref,required this.quantity,required this.price,  required this.description,required this.reference
   });     

  factory product.fromDocument(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    return product(
      pname: doc['pname'] ?? '', 
      pimage: doc['pimage'] ?? '',
      catref: doc['catref']as DocumentReference,
      quantity: (doc['quantity'] ?? 0).toInt(),
      price: (doc['price'] ?? 0.0).toDouble(), 
      description: doc['description']?? '', 
      reference: doc.reference,
    
      

       );
  }

  
}


class Wishlist{
  final String pname;
  final String pimage;
  DocumentReference wishreference;

 Wishlist( {required this.pname, required this.pimage,required this.wishreference});

  
  factory Wishlist.fromDocument(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    return Wishlist(
      pname: doc['pname'] ?? '', 
      pimage: doc['pimage'] ?? '',
      
      wishreference: doc.reference,
    );
  }

  
}
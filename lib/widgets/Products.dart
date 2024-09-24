
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:signup/Functions/categorydb.dart';
import 'package:signup/Functions/item.dart';
import 'package:signup/Functions/items.dart';
import 'package:signup/widgets/Productdetails.dart';
import 'package:signup/widgets/cart.dart';
import 'homepage.dart';

 final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class product_page extends StatefulWidget {
 final DocumentReference categoryReference;
//  final DocumentReference reference;
  
  const product_page({super.key, 
  // this.product,  
  //  this.pname,
  //  this.pimage,
  //   this.quantity, 
  //   this.price, 
  //   this.description, 
    required this.categoryReference, 
     
      });
  
  //final product;
 
  // final  pname;
  // final  pimage;
  // final quantity;
  // final price;
  // final description;
  
 
 
  

  @override
  State<product_page> createState() => _ProductState();
}

class _ProductState extends State<product_page> {
 final TextEditingController _searchcontroller = TextEditingController();

  DocumentSnapshot ? categorySnapshot;
  late Stream<List<product>> _productsStream;
   



    @override
  void initState() {
    super.initState();
    getProductDetails();
        _productsStream = _getProductsStream();

    
   
  }

  void getProductDetails() async {
    final snapshot = await widget.categoryReference.get();
    
    setState(() {
      categorySnapshot= snapshot;
    });
  }

  Stream<List<product>> _getProductsStream() {
    return _firestore
        .collection('Product')
        .where('catref', isEqualTo: widget.categoryReference)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => product.fromDocument(doc))
            .where((product) =>
                product.pname
                    .toLowerCase()
                    .contains(_searchcontroller.text.toLowerCase()))
            .toList());
  }
 
 Future<void> cart(Map<String,dynamic>product) async {
  final snapshot = await _firestore
  .collection('cart')
  .where('pname' , isEqualTo: product['pname'])
  .get();

  if (snapshot.docs.isEmpty) {

    await _firestore.collection('cart').add(product);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar (content: Text('added to cart',
       style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
      ),
      duration: Duration(seconds: 2),
      )
    );
  
 }else { 
  ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Item already in cart',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: Duration(seconds: 2),
        ),
      );
 }

 }

 
  
   
    
  
  @override
  Widget build(BuildContext context) {
    if (categorySnapshot == null) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
       body: const Center(child: CircularProgressIndicator()),

       );
    }
     final cate = categorySnapshot!;
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
                  cate['name'],
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
      
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          primary: true,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 252, 252),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  controller: _searchcontroller,
                  decoration:const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    onChanged: (value){
                      setState(() {
                          _productsStream = _getProductsStream();
                      });
                    },
                    ),
              ),
             const SizedBox(height: 20),
             Container(
               child: StreamBuilder <List<product>>(
                 stream: _productsStream,
                //  .where('catref', isEqualTo: widget.categoryReference)
                //  .where('pname',isGreaterThanOrEqualTo: _searchcontroller.text.trim())
                //    .where('pname',isLessThanOrEqualTo: _searchcontroller.text.trim()+ '\uf8ff')
                //  .snapshots(),
                 
                 builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData || snapshot.data!.isEmpty ){
                                  return const Center(child: Text('no products'));
                                }
                         
                                final Product = snapshot.data!;
                                // .map((doc)=> product.fromDocument(doc))
                                // .toList();

                                //  print("Number of products: ${Product.length}");
                         
                   return GridView.builder(
                    
                     primary: false,
                    shrinkWrap: true,
                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:2,
                      crossAxisSpacing: 12.0,                 

                      mainAxisSpacing:  12.0,
                      mainAxisExtent: 300 ,
                   ),
                     itemCount: Product.length,
                     itemBuilder: (BuildContext context, int index) {
                       var product = Product[index];
                       return GestureDetector(
                        onTap: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => 
                                    product_details(
                                    // productname:product.pname ,
                                    // proimage: product.pimage,
                                    // prodprice: '₹ ${product.price.toStringAsFixed(1)}', 
                                    // prodqunatity: '${product.quantity.toString()}',
                                    // prodescription: product.description, 
                                     reference: product.reference, 
                                    ))
                                 );
                        },
                         child: Container(
                             decoration: BoxDecoration( 
                             color: const Color.fromARGB(0, 26, 25, 25),
                            border: Border.all(color: const Color.fromARGB(255, 68, 66, 66),width: 0.5),
                            borderRadius: BorderRadius.circular(12.0),
                                                 
                            ),
                            child: Column(
                              children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SizedBox(
                                      height: 150,
                                      width: 200,
                                      
                                      child: Image.network(product.pimage,
                                      height: 150,
                                      width: 200,
                                      ),
                                            
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Row(
                                                    children: [
                                                     Text(product.pname,
                                                      textAlign: TextAlign.start,
                                                      style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                                      
                                                      ),
                                                     
                                                    ],
                                                  ),
                                                ),
                                                 Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Row(
                                                    children: [
                                                      // Text( '${product.quantity.toString()}',
                                                      //  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                                      // textAlign: TextAlign.start),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left:10.0),
                                                          child: Text('₹ ${product.price.toStringAsFixed(1)}',
                                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                                          textAlign:TextAlign.start),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                    
                                                      SizedBox(
                                                        height: 40.0,
                                                        width: 40.0,
                                
                                                        child: FloatingActionButton(
                                                          onPressed:()async {
                                                            await cart({
                                                              'pname':product.pname,
                                                              'pimage': product.pimage,
                                                              'price' : product.price,
                                                              'quantity':product.quantity,
                                                            });
                                                            //  Navigator.push(context, MaterialPageRoute(builder: (context)=> Cart()));
                                                          },
                                                       
                                                         
                                                        backgroundColor: Colors.black38,
                                                        child: const Icon(Icons.add,color: Colors.white,),
                                                        
                                         ),
                                       ),
                                     ],
                                  ),
                              )
                         
                            ],
                                               )
                                            ],
                                           ),
                                            
                                        
                                        ),
                       );
                   
                     },
                   );
                 }
               ),
             ),
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
            
            ],
            
            
          ),
        ),
        
      
        
      ),
      
      bottomNavigationBar:const CartItems(),


    );
  }
}
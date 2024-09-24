import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:signup/Functions/categorydb.dart';
import 'package:signup/Functions/item.dart';
import 'package:signup/widgets/Productdetails.dart';
import 'package:signup/widgets/Products.dart';
import 'package:signup/widgets/cart.dart';
import 'package:signup/widgets/category.dart';
import 'package:signup/widgets/profile.dart';
import 'package:signup/widgets/wish.dart';
import 'package:signup/widgets/order.dart';





class Homepage extends StatefulWidget {
  const Homepage({super.key, this.name, this.image, });
  final name;
  final image;
  
  
  
  

  

  


  
  @override
  State<Homepage> createState() => _HomepageState();

  
}

class _HomepageState extends State<Homepage> {
final FirebaseFirestore _firestore = FirebaseFirestore.instance;




  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        primary: true,

        child: Container(
        
          child: Column(

            children: [
             
              Container(
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top:20,left: 15),
                  
                  child: Row(
                  
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.person, color: Colors.white),
                        onPressed: () {
        
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Profile_page()),
                          );
                        },
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
              // SizedBox(height: 20),
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      
                      Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  
                  ),
              
                ),
              ),
                   const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: SizedBox(
                    
                    
                        height: 150,
                          
                        child: StreamBuilder(
                          stream: _firestore.collection('categories').snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData){
                              return const Center(child: Text('no categories'));
                            }

                            final categories = snapshot.data!.docs
                            .map((doc)=> Category.fromDocument(doc)) 
                            .toList();
                            
                            return ListView.builder( 
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                             itemCount: categories.length,      //circle count
                             itemBuilder:(context,index){
                              var category = categories[index];
                              return Padding(
                                padding: const EdgeInsets.only(left:8.0),
                               
                                child: GestureDetector(
                                   
                                  onTap: () {
                                    Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=>  product_page(
                                      //product:product ,
                                       categoryReference: category.reference, 
                                    
                                    ))
                                    );
                                  },

                                  child: Column(
                                    
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(80),
                                          border: Border.all(width: 0.5)
                                        ),
                                        width: 80,
                                        height: 80,
                                        
                                       child: ClipRRect(
                                        borderRadius: BorderRadius.circular(80),
                                         child: Image.network(category.image,
                                         fit: BoxFit.cover,
                                         ),
                                       ),
                                       ),
                                    const SizedBox(height: 2),
                                    Text(
                                    category.name,
                                     overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                     style: const TextStyle(
                                     
                                     ),
                                  )
                                  
                                      
                                    ],
                                  ),
                                ),
                              );
                            
                             }
                            
                              );
                          }
                        )
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Container(
                      height: 150,
                      width: 500,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color.fromARGB(255, 227, 221, 221)
                      ),
                      child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: PageView.builder(
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          // List of image paths
          final List<String> imagePaths = [
            'assets/images/beautyshop.png',
            'assets/images/beautyshop.png',
            'assets/images/beautyshop.png',
            'assets/images/beautyshop.png',
          ];
          
          
          return Image.asset(
            imagePaths[index],
            fit: BoxFit.cover,
          );
        },
      ),
    ),
  ),
),
                  
        
                  const SizedBox(height:10),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20,right: 20),
                  //   child: Container(
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text('Groceries',style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),
                  //         ),
                  //         Text('See all',style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),)
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  
 const SizedBox(height: 10),
Padding(
  padding: const EdgeInsets.only(left: 20, right: 20),
  child: SizedBox(
    height: 80,
    child: StreamBuilder(
      stream: _firestore.collection('Product').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No products'));
        }

        final Products = snapshot.data!.docs
            .map((doc) => product.fromDocument(doc))
            .toList();

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: Products.length,
          itemBuilder: (BuildContext context, int index) {
            var product = Products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => product_details(
                      reference: product.reference,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(232, 240, 238, 238),
                  border: Border.all(color: const Color.fromARGB(255, 68, 66, 66), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 140,
                child: Row(
                 // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: ClipOval(
                          child: Image.network(product.pimage, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.pname,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  ),
),

                 const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                    child: Container(
                     
                     child: StreamBuilder(
                       stream: _firestore.collection('Product').snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData){
                              return const Center(child: Text('no products'));
                            }

                            final Product = snapshot.data!.docs
                            .map((doc)=> product.fromDocument(doc))
                            .toList();
                       
                      
                           return GridView.builder(
                            primary: false,
                           shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.0,                 //space between 2 columns
                             mainAxisSpacing:  12.0,
                             mainAxisExtent: 250                      //length 
                            ),
                            itemCount:Product.length, 
                            itemBuilder: (BuildContext context, int index) {
                               var product = Product[index];
                              return  GestureDetector(
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
                                     color: Colors.transparent,
                                     border: Border.all(color: const Color.fromARGB(255, 68, 66, 66),width: 0.5),
                                    borderRadius: BorderRadius.circular(12.0),
                                    
                                                         
                                    
                                    
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                       Padding(
                                         padding: const EdgeInsets.all(10.0),
                                         child: Column(
                                         
                                           children: [
                                             SizedBox(
                                              height: 150,
                                              width: 200,
                                             // color: const Color.fromARGB(255, 238, 218, 158),
                                              child: Image.network(product.pimage,fit: BoxFit.fill,),
                                              
                                              
                                            
                                             ),
                                           ],
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
                                         Row(
                                           children: [
                                             // Text( '${product.quantity.toString()}',
                                             //  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                             // textAlign: TextAlign.start),
                                               Padding(
                                                 padding: const EdgeInsets.only(left:10.0),
                                                 child: Text('₹ ${product.price.toStringAsFixed(1)}',
                                                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                                 textAlign:TextAlign.start),
                                               )
                                           ],
                                         )
                                      ],
                                      
                                    ),
                                  ),
                                  
                                  
                                  
                                  
                                ),
                              );
                            },
                         );
                       }
                     ),
                     ),
                  )
                  
                  
        
        
        
        
                
            ]  
         )
            
        
        ),
      ),
        
      bottomNavigationBar: const CartItems()
          
     );
 
  }
}

    
      
      
     
   

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:signup/Functions/categorydb.dart';
import 'package:signup/Functions/item.dart';
import 'package:signup/widgets/Products.dart';

class Category_page extends StatefulWidget {
  const Category_page({super.key});

  @override
  State<Category_page> createState() => _Category_pageState();
}

class _Category_pageState extends State<Category_page> {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchcontroller =TextEditingController();

late Stream<List<Category>> _productsStream;
   



    @override
  void initState() {
    super.initState();
    
     _productsStream = _getProductsStream();
  }
     Stream<List<Category>> _getProductsStream() {
    return _firestore
        .collection('categories')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Category.fromDocument(doc))
            .where((category) =>
                category.name.toLowerCase().contains(_searchcontroller.text.toLowerCase()))
            .toList());
  }

  



  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(60),
       child: AppBar(backgroundColor: Colors.blueGrey,
       shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0))
       ),
      automaticallyImplyLeading: false,    //to remove the backbutton 
      flexibleSpace: const Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Text('Category',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),),
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
                  child:  TextField(
                    controller: _searchcontroller,
                    
                    decoration:const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      onChanged: (value) {
                    setState(() {
                      _productsStream = _getProductsStream();
                    });
                  },
                      ),
            ),
            const SizedBox(height: 20),
            StreamBuilder<List<Category>>(
              stream:_productsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData){
                              return const Center(child: Text('no categories'));
                            }

                           final categories = snapshot.data!;
                            

              
                return GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,                 
                
                    mainAxisSpacing:  12.0,
                    mainAxisExtent: 200 ,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) {
                     var category = categories[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => product_page(categoryReference: category.reference, )));
                      },
                      child: Container(
                        decoration: BoxDecoration( 
                                   color: const Color.fromARGB(0, 26, 25, 25),
                                   border: Border.all(color: const Color.fromARGB(255, 68, 66, 66),width: 0.5),
                                   borderRadius: BorderRadius.circular(12.0),
                                                       
                                  ),
                                  child: Column(children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: Image.network(category.image),
                                          
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                         Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(category.name,
                                               style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                                            ],
                                          ),
                                        )
                                      ],
                                    )],),
                      ),
                    );
                  },
                );
              }
            ),
          ],
            
          
          ),
        ),
      ),
      bottomNavigationBar: const CartItems(),
    );
}
}
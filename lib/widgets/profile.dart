import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signup/widgets/signup.dart';
import 'package:signup/widgets/trackorder.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
}

class Profile_page extends StatefulWidget {
  const Profile_page({super.key});

  @override
  State<Profile_page> createState() => _ProfileState();
}

class _ProfileState extends State<Profile_page> {
  final AuthService authService = AuthService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController orderIdController = TextEditingController();
  bool isEditingName = false;
  bool isEditingNumber = false;

  

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
          automaticallyImplyLeading: false,
          flexibleSpace: const Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Profile',
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
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("user")
              .doc(authService.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('User data not found'));
            } else {
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              nameController.text = userData['name'];
              numberController.text = userData['number'];
        
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.2),
                          borderRadius: BorderRadius.circular(18),
                          color: const Color.fromARGB(255, 245, 243, 243),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.email, color: Colors.blueGrey),
                          title: Text(
                            'Email: ${userData['email']}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.2),
                          borderRadius: BorderRadius.circular(18),
                          color: const Color.fromARGB(255, 244, 238, 238),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.person, color: Colors.blueGrey),
                          title: isEditingName
                              ? TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                  ),
                                )
                              : Text(
                                  'Name: ${userData['name']}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                          trailing: IconButton(
                            icon: Icon(isEditingName ? Icons.check : Icons.edit),
                            onPressed: () {
                              if (isEditingName) {
                                FirebaseFirestore.instance
                                    .collection("user")
                                    .doc(authService.currentUser!.uid)
                                    .update({'name': nameController.text});
                              }
                              setState(() {
                                isEditingName = !isEditingName;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.2),
                          borderRadius: BorderRadius.circular(18),
                          color: const Color.fromARGB(255, 244, 238, 238),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.phone, color: Colors.blueGrey),
                          title: isEditingNumber
                              ? TextField(
                                  controller: numberController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: 'Number',
                                  ),
                                )
                              : Text(
                                  'Number: ${userData['number']}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                          trailing: IconButton(
                            icon: Icon(isEditingNumber ? Icons.check : Icons.edit),
                            onPressed: () {
                              if (isEditingNumber) {
                                FirebaseFirestore.instance
                                    .collection("user")
                                    .doc(authService.currentUser!.uid)
                                    .update({'number': numberController.text});
                              }
                              setState(() {
                                isEditingNumber = !isEditingNumber;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: orderIdController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Order ID',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrackOrderPage(
                                orderId: int.parse(orderIdController.text),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          textStyle: const TextStyle(fontSize: 20),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(200, 50),
                        ),
                        child: Text('Track Order'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const Sign_Up()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          textStyle: const TextStyle(fontSize: 20),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(200, 50),
                        ),
                        child: Text('Logout'),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

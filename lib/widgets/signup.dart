import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signup/widgets/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signup/widgets/signin.dart';

class Sign_Up extends StatefulWidget {
  const Sign_Up({super.key});

  @override
  State<Sign_Up> createState() => _Sign_UpState();
}

class _Sign_UpState extends State<Sign_Up> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          // name:_nameController.text.trim(),

        );

        User? user = userCredential.user;
        if (user != null) {
          await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
            'email': _emailController.text.trim(),
            'password' : _passwordController.text.trim(),
            'name': _nameController.text.trim(),
            'number': _numberController.text.trim(),
         });

         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Account created successfully .. Logging you in...'))
          );
              
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Sign_IN()));
          
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign Up failed. The email address is already in use by another account ')),

        );
      }
    }
  }


 
 
  

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
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
                'Welcome To Our Store',
                style: TextStyle(
                  fontSize: 25.0,
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
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Create Your Account',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Arial'),
                ),
        
                const SizedBox(height: 18),
                Container(
                  color: const Color.fromARGB(172, 236, 230, 230),
                  child: TextFormField(
                    controller: _nameController,
                     decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.people_rounded)
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty)  {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                  ),
                  
                ),
        
        
                const SizedBox(height: 18),
                Container(
                  color: const Color.fromARGB(172, 236, 230, 230),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  color: const Color.fromARGB(172, 236, 230, 230),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  color:const Color.fromARGB(172, 236, 230, 230), 
                  child: TextFormField(
                    controller: _numberController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      labelText: 'Phone number',
                      prefixIcon: Icon(Icons.phone),
                      
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return 'Please enter a valid phon enumber';
                      }
        
                      if (!RegExp(r'^\d{10}$').hasMatch(value)){
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                ),
                
        
                
        
        
                const SizedBox(height: 18),
                ElevatedButton(
        
        
                  //if conditon
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 14),
                    textStyle: const TextStyle(fontSize: 20),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Sign Up'),
                ),
                
        
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('or continue with'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0)),
                      child: IconButton(
                        onPressed: () {},
                        icon: const ImageIcon(AssetImage('assets/images/google.png')),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0)),
                      child: IconButton(
                        onPressed: () {},
                        icon: const ImageIcon(AssetImage('assets/images/facebook.png')),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0)),
                      child: IconButton(
                        onPressed: () {},
                        icon: const ImageIcon(AssetImage('assets/images/social.png')),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 10),
              TextButton(onPressed: (){
                Navigator.push(
                  context,MaterialPageRoute(builder: (context) => const Sign_IN()));
              }, 
              child: 
              const Text('Already have an account? sign in'),
              )
                
                    
                  
              ],
            ),
          ),
        ),
      ),
    );
  }
}

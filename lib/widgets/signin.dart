import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signup/widgets/home_provider.dart';
import 'package:signup/widgets/homepage.dart';
import 'package:signup/widgets/mainPage.dart'; 

class Sign_IN extends StatefulWidget {
  const Sign_IN({super.key});

  @override
  State<Sign_IN> createState() => _Sign_INState();
}

class _Sign_INState extends State<Sign_IN> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.blueGrey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0))),
          flexibleSpace: const Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Sign In Page',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                color: const Color.fromARGB(172, 236, 230, 230),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    labelText: 'Enter Email',
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
              const SizedBox(height: 20),
              Container(
                color: const Color.fromARGB(172, 236, 230, 230),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    labelText: 'Enter Password',
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await _analytics.logEvent(name: 'sign_in_attempt', 
                      parameters: {
                        'email' : _emailController.text.trim(),
                  
                      } 
                      );
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                      await _analytics.logEvent(name: 'sign_in_success',
                      parameters: {'email': _emailController.text.trim(),
                      }
                      );
                      //home_page
                      //projec homepage
                     Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const home_page()),
                            (Route<dynamic> route) => false,
                          );
                    } catch (e) {

                        await _analytics.logEvent(name: 'sign_in_failure',
                        parameters: {'email': _emailController.text.trim(),
                        'error' : e.toString(),
                        }

                        );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sign In failed')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 14),
                  textStyle: const TextStyle(fontSize: 20),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

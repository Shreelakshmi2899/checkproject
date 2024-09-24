import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signup/Functions/providerpunchin.dart';
import 'package:signup/widgets/home_provider.dart';
import 'package:signup/widgets/homepage.dart';
import 'package:signup/widgets/list_provider.dart';
import 'package:signup/widgets/bloc.dart';
import 'package:signup/widgets/provider.dart';
import 'package:signup/widgets/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Optionally, configure Flogger here if needed

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => numberlistprovider()),
        ChangeNotifierProvider(create: (context) => punchinprovider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
      
        home: home_page(), 

        //sign_up(),
      ),
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text("Something went wrong"));
//         }
//         User? user = snapshot.data;
//         if (user == null) {
//           return Sign_Up();
//         } else {
//           return home_page();
//         }
//       },
//     );
//   }
// }

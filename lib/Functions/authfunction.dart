import 'package:firebase_auth/firebase_auth.dart';

class Firebasefunction{
  FirebaseAuth FirebaseAuth_auth = FirebaseAuth.instance;
  
  Future<User?> signUpUserWithEmailAndPassword(String email , String password, String name, String number) async{

try {
 
    UserCredential credential= await FirebaseAuth_auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
   
    );
    //update user profile
    await credential.user!.updateDisplayName(name);
    
    return credential.user;
  
  } catch (e){
    print("some error occured");
  }
   return null;
}

}


 
















// class _Sign_UpState extends State<Sign_Up> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//    Future<void> _signUp() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),

//         );

//         //store user data 
        

       
//         Navigator.push(context, MaterialPageRoute(builder: (context) => home_page()));
//       } on FirebaseAuthException catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
//       }
//     }
//   }
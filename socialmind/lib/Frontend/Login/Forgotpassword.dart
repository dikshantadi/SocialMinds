// import 'package:flutter/material.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:socialmind/Frontend/Login/Login.dart';

// class ForgotPasswordPage extends StatefulWidget {
//   const ForgotPasswordPage({Key? key}) : super(key: key);

//   @override
//   _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   late TextEditingController _emailController;

//   @override
//   void initState() {
//     super.initState();
//     _emailController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             children: [
//               SizedBox(height: 50),
//               FadeInUp(
//                 duration: Duration(milliseconds: 1500),
//                 child: Text(
//                   "Forgot Password?",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 40),
//               FadeInUp(
//                 delay: Duration(milliseconds: 800),
//                 duration: Duration(milliseconds: 1500),
//                 child: TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     labelText: "Email",
//                     hintText: "Enter your email",
//                     prefixIcon: Icon(Iconsax.user, size: 18),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               FadeInUp(
//                 child: MaterialButton(
//                   onPressed: () {
//                     // Send OTP to the provided email address
//                     String email = _emailController.text;
//                     // Implement your logic to send OTP to email
//                     // For simplicity, we're just navigating to the next step
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => OTPPage(email: email),
//                       ),
//                     );
//                   },
//                   height: 45,
//                   minWidth: double.infinity,
//                   color: Colors.black,
//                   textColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text("Send OTP"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class OTPPage extends StatelessWidget {
//   final String email;

//   const OTPPage({Key? key, required this.email}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _otpController = TextEditingController();

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             children: [
//               SizedBox(height: 50),
//               FadeInUp(
//                 duration: Duration(milliseconds: 1500),
//                 child: Text(
//                   "Verify OTP",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 40),
//               FadeInUp(
//                 delay: Duration(milliseconds: 800),
//                 duration: Duration(milliseconds: 1500),
//                 child: TextField(
//                   controller: _otpController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "OTP",
//                     hintText: "Enter the OTP",
//                     prefixIcon: Icon(Iconsax.lock, size: 18),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               FadeInUp(
//                 child: MaterialButton(
//                   onPressed: () {
//                     // Validate OTP
//                     String otp = _otpController.text;
//                     // Implement your logic to verify OTP
//                     // For simplicity, we're just navigating to the next step
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ChangePasswordPage(email: email),
//                       ),
//                     );
//                   },
//                   height: 45,
//                   minWidth: double.infinity,
//                   color: Colors.black,
//                   textColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text("Verify"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ChangePasswordPage extends StatelessWidget {
//   final String email;

//   const ChangePasswordPage({Key? key, required this.email}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _newPasswordController = TextEditingController();
//     final TextEditingController _confirmPasswordController = TextEditingController();

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             children: [
//               SizedBox(height: 50),
//               FadeInUp(
//                 duration: Duration(milliseconds: 1500),
//                 child: Text(
//                   "Change Password",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 40),
//               FadeInUp(
//                 delay: Duration(milliseconds: 800),
//                 duration: Duration(milliseconds: 1500),
//                 child: TextField(
//                   controller: _newPasswordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: "New Password",
//                     hintText: "Enter your new password",
//                     prefixIcon: Icon(Iconsax.lock, size: 18),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               FadeInUp(
//                 delay: Duration(milliseconds: 800),
//                 duration: Duration(milliseconds: 1500),
//                 child: TextField(
//                   controller: _confirmPasswordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: "Confirm New Password",
//                     hintText: "Confirm your new password",
//                     prefixIcon: Icon(Iconsax.lock, size: 18),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               FadeInUp(
//                 child: MaterialButton(
//                   onPressed: () {
//                     // Validate and change password
//                     String newPassword = _newPasswordController.text;
//                     String confirmPassword = _confirmPasswordController.text;
//                     // Implement your logic to change password

//                     // Show password changed message
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Password changed successfully'),
//                       ),
//                     );
                    
//                     // For simplicity, we're just navigating back to the login page
//                     //Navigator.popUntil(context, ModalRoute.withName('/'));
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => LoginPage()));
//                   },
//                   height: 45,
//                   minWidth: double.infinity,
//                   color: Colors.black,
//                   textColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text("Change Password"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isSendingResetEmail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your email",
                    prefixIcon: Icon(Iconsax.user, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                child: MaterialButton(
                  onPressed: _resetPassword,
                  height: 45,
                  minWidth: double.infinity,
                  color: Colors.black,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isSendingResetEmail
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text("Send Reset Link"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  

void _resetPassword() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isSendingResetEmail = true;
    });
    try {
      // Send the reset password email
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      _showResetEmailSentDialog();
    } catch (e) {
      // Check the error message to determine if the email is unregistered
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        _showErrorDialog('This email is not registered.');
      } else {
        _showErrorDialog(e.toString());
      }
    } finally {
      setState(() {
        _isSendingResetEmail = false;
      });
    }
  }
}



  void _showResetEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Reset Email Sent'),
          content: Text(
              'A password reset email has been sent to ${_emailController.text}. Follow the instructions in the email to reset your password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// class UserDatabase {
//   final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

//   Future<bool> isEmailRegistered(String email) async {
//     QuerySnapshot querySnapshot = await usersCollection.where('email', isEqualTo: email).get();
//     return querySnapshot.docs.isNotEmpty;
//   }
// }
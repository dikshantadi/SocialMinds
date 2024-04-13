import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
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
        await _auth.sendPasswordResetEmail(email: _emailController.text);
        // Inform the user to check their email if the account exists
        _showGenericResetEmailSentDialog();
      } catch (e) {
        // Log error or handle it without exposing the nature of the error to the user
        print(e); // Consider logging the error for your own debugging
      } finally {
        setState(() {
          _isSendingResetEmail = false;
        });
      }
    }
  }

  void _showGenericResetEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Check Your Email'),
          content: Text(
              'If an account exists for the email provided, you will receive an email with instructions on how to reset your password.'),
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

// void _resetPassword() async {
//   if (_formKey.currentState!.validate()) {
//     setState(() {
//       _isSendingResetEmail = true;
//     });
//     try {
//       // Attempt to create a user with the provided email
//       await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: 'tempPassword', // Provide a temporary password
//       );
//       // If successful, the email is not registered
//       throw Exception('This email is not registered.');
//     } catch (e) {
//       if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
//         // If email is already registered, send the password reset email
//         await _auth.sendPasswordResetEmail(email: _emailController.text);
//         _showResetEmailSentDialog();
//       } else {
//         // Handle other errors
//         _showErrorDialog(e.toString());
//       }
//     } finally {
//       setState(() {
//         _isSendingResetEmail = false;
//       });
//     }
//   }
// }

//   void _showResetEmailSentDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Password Reset Email Sent'),
//           content: Text(
//               'A password reset email has been sent to ${_emailController.text}. Follow the instructions in the email to reset your password.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

  void showErrorDialog(String error) {
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

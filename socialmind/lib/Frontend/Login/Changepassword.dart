
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialmind/Frontend/Login/Login.dart';

class Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } catch (error) {
      throw error;
    }
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  Authentication auth = Authentication();
  final formKey = GlobalKey<FormState>();
  String? oldPassword;
  String? newPassword;
  String? confirmPassword;

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepOrangeAccent,
                Colors.deepPurpleAccent,
              ],
            ),
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 40),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      oldPassword = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your old password";
                    } else {
                      return null;
                    }
                  },
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Old Password",
                    hintText: "Old Password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      child: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      newPassword = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a new password";
                    } else {
                      return null;
                    }
                  },
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    hintText: "New Password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      child: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      confirmPassword = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please confirm your new password";
                    } else if (value != newPassword) {
                      return "Passwords do not match";
                    } else {
                      return null;
                    }
                  },
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    hintText: "Confirm Password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      child: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    changePassword();
                  },
                  child: Text("Change Password"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.deepOrangeAccent, // Changed button color
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                    overlayColor: MaterialStateProperty.all<Color>(
                      Colors.deepPurpleAccent.withOpacity(0.5), // Added overlay color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changePassword() async {
  if (formKey.currentState!.validate()) {
    try {
      await auth.changePassword(oldPassword!, newPassword!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password changed successfully")),
      );
      // Redirect to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), // Assuming LoginPage is the name of your login page
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to change password: $error")),
      );
    }
  }
}

}

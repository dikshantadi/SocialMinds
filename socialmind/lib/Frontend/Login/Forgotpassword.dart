import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:socialmind/Frontend/Login/Login.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
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
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your email",
                    prefixIcon: Icon(Iconsax.user, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                child: MaterialButton(
                  onPressed: () {
                    // Send OTP to the provided email address
                    String email = _emailController.text;
                    // Implement your logic to send OTP to email
                    // For simplicity, we're just navigating to the next step
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OTPPage(email: email),
                      ),
                    );
                  },
                  height: 45,
                  minWidth: double.infinity,
                  color: Colors.black,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("Send OTP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OTPPage extends StatelessWidget {
  final String email;

  const OTPPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _otpController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 50),
              FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: Text(
                  "Verify OTP",
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
                child: TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "OTP",
                    hintText: "Enter the OTP",
                    prefixIcon: Icon(Iconsax.lock, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                child: MaterialButton(
                  onPressed: () {
                    // Validate OTP
                    String otp = _otpController.text;
                    // Implement your logic to verify OTP
                    // For simplicity, we're just navigating to the next step
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordPage(email: email),
                      ),
                    );
                  },
                  height: 45,
                  minWidth: double.infinity,
                  color: Colors.black,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("Verify"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordPage extends StatelessWidget {
  final String email;

  const ChangePasswordPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _newPasswordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 50),
              FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: Text(
                  "Change Password",
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
                child: TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    hintText: "Enter your new password",
                    prefixIcon: Icon(Iconsax.lock, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm New Password",
                    hintText: "Confirm your new password",
                    prefixIcon: Icon(Iconsax.lock, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                child: MaterialButton(
                  onPressed: () {
                    // Validate and change password
                    String newPassword = _newPasswordController.text;
                    String confirmPassword = _confirmPasswordController.text;
                    // Implement your logic to change password

                    // Show password changed message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Password changed successfully'),
                      ),
                    );
                    
                    // For simplicity, we're just navigating back to the login page
                    //Navigator.popUntil(context, ModalRoute.withName('/'));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  height: 45,
                  minWidth: double.infinity,
                  color: Colors.black,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("Change Password"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

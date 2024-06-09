import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For storing settings locally

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkTheme = false;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkTheme = prefs.getBool('darkTheme') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> _updateTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkTheme', value);
    setState(() {
      _darkTheme = value;
    });
  }

  Future<void> _updateNotifications(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
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
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          title: Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Theme'),
            value: _darkTheme,
            onChanged: (bool value) {
              _updateTheme(value);
              // Here you might also want to update the app theme dynamically
            },
            secondary: Icon(Icons.brightness_6),
          ),
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              _updateNotifications(value);
              // Handle notifications enabling/disabling logic
            },
            secondary: Icon(Icons.notifications_active),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Account Settings'),
            onTap: () {
              // Navigate to account settings page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountSettingsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Policy'),
            onTap: () {
              // Show privacy policy
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrivacyPolicyPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Activity Log'),
            onTap: () {
              // Navigate to activity log page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ActivityLogPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Your Account'),
            onTap: () {
              // Navigate to delete account page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeleteAccountPage()));
            },
          ),
        ],
      ),
    );
  }
}

class AccountSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
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
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          title: Text(
            'Account Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: Center(
        child: Text('Account Settings Page'),
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
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
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          title: Text(
            'Privacy Policy',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: Center(
        child: Text('Privacy Policy Page'),
      ),
    );
  }
}

class ActivityLogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
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
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          title: Text(
            'Activity Log',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: Center(
        child: Text('Activity Log Page'),
      ),
    );
  }
}

class DeleteAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
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
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          title: Text(
            'Delete Account',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: Center(
        child: Text('Delete Account Page'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmind/backend/friend_database_service.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isLoading = true;
  QuerySnapshot? _notifications;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() async {
    QuerySnapshot notifications = await DatabaseService().getNotifications();
    setState(() {
      _notifications = notifications;
      _isLoading = false;
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
            'Notifications',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _notifications == null || _notifications!.docs.isEmpty
              ? Center(child: Text('No notifications'))
              : ListView.builder(
                  itemCount: _notifications!.docs.length,
                  itemBuilder: (context, index) {
                    var notification = _notifications!.docs[index];
                    return ListTile(
                      title: Text(notification['message']),
                      subtitle: Text(notification['timestamp']?.toDate().toString() ?? 'Timestamp not available'),
                    );
                  },
                ),
    );
  }
}

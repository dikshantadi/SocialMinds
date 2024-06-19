import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmind/Frontend/Userpage/Userpg.dart';
import 'package:socialmind/backend/database.dart';

class friendList extends StatefulWidget {
  final String uid;
  const friendList({super.key, required this.uid});

  @override
  State<friendList> createState() => _friendListState();
}

class _friendListState extends State<friendList> {
  @override
  void initState() {
    super.initState();
    getFriendList();
  }

  List? FriendList;
  getFriendList() async {
    try {
      await Database(uid: widget.uid).getFriendList().then((value) {
        if (value != null) {
          setState(() {
            FriendList = value;
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
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
          // backgroundColor: Colors.blue,
          title: Text(
            'Friends',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: FriendList == null
              ? Center(child: CircularProgressIndicator())
              : FriendList!.isEmpty
                  ? Center(
                      child: Text('No Friends'),
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 4,
                          color: const Color.fromARGB(255, 229, 228, 228),
                        );
                      },
                      itemCount: FriendList!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Userpg(uid: FriendList![index].id)));
                          },
                          leading: Icon(
                            Icons.face,
                            size: 50,
                          ),
                          title: Text(
                            '${FriendList![index]['userName']}',
                            style: TextStyle(fontSize: 18, color: Colors.blue),
                          ),
                          subtitle: Text('${FriendList![index]['email']}'),
                        );
                      },
                    )),
    );
  }
}

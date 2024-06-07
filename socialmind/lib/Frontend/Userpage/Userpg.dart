import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialmind/Frontend/homepg.dart';
import 'package:socialmind/Frontend/nav.dart';
import 'package:socialmind/Widgets/comment.dart';
import 'package:socialmind/Widgets/postTemplate.dart';
import 'package:socialmind/backend/database.dart';

class Userpg extends StatefulWidget {
  final String uid;
  const Userpg({super.key, required this.uid});

  @override
  State<Userpg> createState() => _UserpgState();
}

class _UserpgState extends State<Userpg> {
  List? postSnapshot;
  Map<String, dynamic>? user;
  String _address = '123 Main Street, City, Country';
  DateTime _birthday = DateTime(1990, 1, 1);
  TextEditingController addressController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  @override
  void initState() {
    getPostsAndUserData();
    super.initState();
  }

  getPostsAndUserData() async {
    await Database(uid: widget.uid).getMyPost().then((value) {
      if (value != null) {
        setState(() {
          print(value);
          List postSnapshot1 = value;
          postSnapshot1.sort(
            (a, b) => a['time'].compareTo(b['time']),
          );
          postSnapshot = postSnapshot1.reversed.toList();
        });
      }
    });
    await Database(uid: widget.uid).getUserData().then((value) {
      setState(() {
        user = value.data() as Map<String, dynamic>;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: user == null
          ? Center(
              child: CircularProgressIndicator(
                strokeAlign: 1,
                color: Colors.blue,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      user!['userName'],
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 10),
                    Text(
                      user!['email'],
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    // ListTile(
                    //   leading: Icon(Icons.phone),
                    //   title: Text('Phone'),
                    //   subtitle: Text('+123 456 7890'),
                    // ),
                    ListTile(
                      leading: Icon(Icons.location_city),
                      title: Text('Address'),
                      subtitle: Text(user!['address'] ?? "not set"),
                    ),
                    ListTile(
                      leading: Icon(Icons.cake),
                      title: Text('Birthday'),
                      subtitle: Text(user!['birthDay'] ?? "not set"),
                    ),
                    widget.uid == FirebaseAuth.instance.currentUser!.uid
                        ? ListTile(
                            leading: Icon(Icons.more),
                            title: Text('edit profile'),
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Edit Profile'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          TextField(
                                            controller: addressController,
                                            decoration: InputDecoration(
                                              labelText: 'Address',
                                            ),
                                          ),
                                          TextField(
                                            controller: birthdayController,
                                            decoration: InputDecoration(
                                              labelText: 'Birthday',
                                            ),
                                            onTap: () async {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode());
                                              DateTime? picked =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: _birthday,
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2101),
                                              );
                                              if (picked != null &&
                                                  picked != _birthday) {
                                                setState(() {
                                                  _birthday = picked;
                                                  birthdayController.text =
                                                      "${picked.toLocal()}"
                                                          .split(' ')[0];
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Confirm'),
                                        onPressed: () async {
                                          setState(() {
                                            _address = addressController.text;

                                            // _birthday is already updated through the DatePicker
                                          });
                                          await Database(uid: widget.uid)
                                              .updateAddressandBirthday({
                                            'birthday': birthdayController.text,
                                            'address': _address
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Userpg(uid: widget.uid)));
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              ;
                            },
                          )
                        : Text(''),
                    Container(
                      child: Row(
                        children: [
                          TextButton(onPressed: () {}, child: Text('friends')),
                          TextButton(onPressed: () {}, child: Text('Post'))
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(
                          "My Posts",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    postSnapshot == null
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          )
                        : postSnapshot!.length == 0
                            ? Center(
                                child: Text('No Posts'),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: postSnapshot!.length,
                                separatorBuilder: (context, index) {
                                  return Container(
                                    width: double.infinity,
                                    height: 10,
                                    color: Colors.grey,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => comment(
                                                  type: 'Post',
                                                  authorID: postSnapshot![index]
                                                      ['authorID'],
                                                  postID:
                                                      postSnapshot![index].id,
                                                  postedBy: postSnapshot![index]
                                                      ['authorName'],
                                                  imageUrl: postSnapshot![index]
                                                      ['imageUrl'],
                                                  caption: postSnapshot![index]
                                                      ['caption'])));
                                    },
                                    child: postTemplate(
                                        authorID: postSnapshot![index]
                                            ['authorID'],
                                        postID: postSnapshot![index].id,
                                        authorName: postSnapshot![index]
                                            ['authorName'],
                                        caption: postSnapshot![index]
                                            ['caption'],
                                        imageUrl: postSnapshot![index]
                                            ['imageUrl'],
                                        time: postSnapshot![index]['time']),
                                  );
                                },
                              ),
                  ],
                ),
              ),
            ),
    );
  }
}

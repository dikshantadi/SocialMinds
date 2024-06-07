import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialmind/Frontend/Camera/Camerapage.dart';
import 'package:socialmind/Frontend/Chat/Chatbot/Chatbot.dart';
import 'package:socialmind/Frontend/Chat/Chatpage.dart';
import 'package:socialmind/Frontend/Friend/FindFriendPage.dart';
import 'package:socialmind/Frontend/Friend/FriendRequestsPage.dart';
import 'package:socialmind/Frontend/Login/Changepassword.dart';
import 'package:socialmind/Frontend/Login/Login.dart';
import 'package:socialmind/Frontend/Userpage/Userpg.dart';
import 'package:socialmind/Frontend/test.dart';
import 'package:socialmind/Widgets/comment.dart';
import 'package:socialmind/Widgets/postTemplate.dart';
import 'package:socialmind/Widgets/storyTemplate.dart';
import '../backend/authentication.dart';
import '../shared_preferences.dart';
import 'package:socialmind/Frontend/Stats.dart';
import 'nav.dart';
import 'background.dart';
import 'package:iconsax/iconsax.dart';
import 'package:socialmind/backend/database.dart';
import 'package:socialmind/backend/authentication.dart';
import 'package:socialmind/Frontend/Friend/Notification.dart';
import 'package:socialmind/Frontend/Message/MessagingPage.dart';

class Homepg extends StatefulWidget {
  const Homepg({
    super.key,
  });

  @override
  State<Homepg> createState() => _HomepgState();
}

class _HomepgState extends State<Homepg> {
  @override
  String? userName;
  Authentication auth = Authentication();
  List? postSnapshot;
  List postInfos = [];
  List stories = [];
  void initState() {
    getUserData();
    getStories();
    getPosts();
    super.initState();
  }

  getStories() async {
    try {
      await Database(uid: FirebaseAuth.instance.currentUser!.uid)
          .getStories()
          .then((value) {
        if (value != null) {
          setState(() {
            QuerySnapshot snapshot = value;
            List story1 = snapshot.docs;
            story1.sort((a, b) => a['time'].compareTo(b['time']));
            stories = story1.reversed.toList();
          });
        }
      });
    } catch (e) {}
  }

  getPosts() async {
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .getPosts()
        .then((value) {
      if (value != null) {
        setState(() {
          List postSnapshot1 = value.docs;
          postSnapshot1.sort(
            (a, b) => a['time'].compareTo(b['time']),
          );
          postSnapshot = postSnapshot1.reversed.toList();
          print(
              'this is the snapshot postSnapshot ${postSnapshot![1]['authorID']} ');
        });
      }
    });
    // int postLength = postSnapshot!.docs.length;
    // for (int i = 0; i < postLength; i++) {
    //   await Database(uid: postSnapshot!.docs[i]['postedBy'])
    //       .getUserData()
    //       .then((value) {
    //     if (value != null) {
    //       DocumentSnapshot snapshot = value;
    //       postInfos.add([["${snapshot['userName']}", "${snapshot[]}"]])
    //     }
    //   });
    // }
  }

  getUserData() async {
    await Database(uid: auth.firebaseAuth.currentUser!.uid)
        .getUserData()
        .then((value) {
      DocumentSnapshot snapshot = value;
      setState(() {
        userName = snapshot['userName'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Authentication auth = Authentication();
    GlobalKey<ScaffoldState> _scaffoldKey =
        GlobalKey(); //global scaffold define gareko ho nothing fancy
    //drawer ma error dherai falera
    Future<void> _logout(BuildContext context) async {
      await auth.logout().then((value) async {
        await SP.setLogInStatus(false);
        await SP.deleteloginStatus();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }

    Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to logout?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Later'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _logout(context); // Pass the context to _logout
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: Nav(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20), // Adjust the curve as needed
              ),
            ),
          ),
          title: Text(
            'SocialMind',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              size: 34,
              color: Colors.black,
            ),
            onPressed: () {
              _scaffoldKey.currentState
                  ?.openDrawer(); //scaffold key le scaffold globally deko xa ra drawer open gareko simply
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Iconsax.notification,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Iconsax.search_normal,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: [
                      Colors.deepPurpleAccent,
                      Colors.deepOrangeAccent,
                    ]),
                color: Colors.deepPurpleAccent,
              ),
              child: Column(children: [
                CircleAvatar(
                  radius: 40,
                  child: Icon(
                    Iconsax.user,
                    size: 40,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  userName != null ? userName! : "UserName",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ]),
            ),
            ListTile(
              leading: Icon(Iconsax.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Homepg()));
              },
            ),
            ListTile(
              leading: Icon(Iconsax.user),
              title: Text('My Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Userpg(
                              uid: FirebaseAuth.instance.currentUser!.uid,
                            )));
              },
            ),
            ListTile(
              leading: Icon(Iconsax.notification),
              title: Text('Notifications'),
              onTap: () {
                // Implement navigation to settings page here
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage()));
              },
            ),
            ListTile(
              leading: Icon(Iconsax.ghost),
              title: Text('AI Chat-Bot'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Chatbotpg()));
              },
            ),
            ListTile(
              leading: Icon(Iconsax.message),
              title: Text('Chat'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MessagingPage()));
              },
            ),
            // ListTile(
            //   leading: Icon(Iconsax.message),
            //   title: Text('Test'),
            //   onTap: () {
            //     Navigator.push(
            //         context, MaterialPageRoute(builder: (context) => test()));
            //   },
            // ),
            ListTile(
              leading: Icon(Iconsax.camera),
              title: Text('Camera'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CameraPage(
                              userName: userName!,
                            )));
              },
            ),
            ListTile(
              leading: Icon(Iconsax.search_normal),
              title: Text('Find Friends'),
              onTap: () {
                // Implement navigation to find friends page here
                // Navigator.push(
                // context, MaterialPageRoute(builder: (context) => FindFriendsPage()));
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FindFriendsPage()));
              },
            ),
            ListTile(
              leading: Icon(Iconsax.notification),
              title: Text('Friend Requests'),
              onTap: () {
                //  Navigator.push(
                //  context, MaterialPageRoute(builder: (context) => FriendRequestsPage()));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendRequestsPage()));
              },
            ),
            ListTile(
              leading: Icon(Iconsax.graph),
              title: Text('My Statistics'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Stats()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Iconsax.password_check),
              title: Text('Change password'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordPage()));
              },
            ),
            ListTile(
              leading: Icon(Iconsax.cpu_setting),
              title: Text('Settings'),
              onTap: () {
                // Implement navigation to settings page here
              },
            ),
            ListTile(
              leading: Icon(Iconsax.import),
              title: Text('Updates'),
              onTap: () {
                // Implement navigation to settings page here
              },
            ),
            ListTile(
              leading: Icon(Iconsax.logout),
              title: Text('Logout'),
              onTap: () {
                _showLogoutConfirmationDialog(context); // Pass the context
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 30,
            ),
            stories.length == 0
                ? Text('No stories')
                : Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: stories.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => comment(
                                        type: 'Story',
                                        authorID: stories[index]['authorID'],
                                        postID: stories[index].id,
                                        postedBy: stories[index]['authorName'],
                                        imageUrl: stories[index]['imageUrl'],
                                        caption: stories[index]['caption'])));
                          },
                          child: StoryTemplate(
                            authorID: stories[index]['authorID'],
                            imageUrl: stories[index]['imageUrl'],
                            authorName: stories[index]['authorName'],
                          ),
                        );
                      },
                    )),
            SizedBox(
              height: 2,
            ),
            postSnapshot == null
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  )
                : postSnapshot!.length == 0
                    ? Center(
                        child: Text(
                        "No Post",
                        style: TextStyle(
                            fontSize: 39, fontWeight: FontWeight.bold),
                      ))
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
                                          postID: postSnapshot![index].id,
                                          postedBy: postSnapshot![index]
                                              ['authorName'],
                                          imageUrl: postSnapshot![index]
                                              ['imageUrl'],
                                          caption: postSnapshot![index]
                                              ['caption'])));
                            },
                            child: postTemplate(
                                authorID: postSnapshot![index]['authorID'],
                                postID: postSnapshot![index].id,
                                authorName: postSnapshot![index]['authorName'],
                                caption: postSnapshot![index]['caption'],
                                imageUrl: postSnapshot![index]['imageUrl'],
                                time: postSnapshot![index]['time']),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}

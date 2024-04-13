import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialmind/Frontend/Stats.dart';
import 'nav.dart';
import 'background.dart';
import 'package:iconsax/iconsax.dart';

class Homepg extends StatelessWidget {
  const Homepg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey =
        GlobalKey(); //global scaffold define gareko ho nothing fancy
    //drawer ma error dherai falera
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: Nav(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
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
                  '"user_name"',
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
                // Implement navigation to home page here
              },
            ),
            ListTile(
              leading: Icon(Iconsax.user),
              title: Text('My Profile'),
              onTap: () {
                // Implement navigation to settings page here
              },
            ),
            ListTile(
              leading: Icon(Iconsax.notification),
              title: Text('Notifications'),
              onTap: () {
                // Implement navigation to settings page here
              },
            ),
            ListTile(
              leading: Icon(Iconsax.ghost),
              title: Text('AI Chat-Bot'),
              onTap: () {
                // Implement navigation to settings page here
              },
            ),
            ListTile(
              leading: Icon(Iconsax.message),
              title: Text('Chat'),
              onTap: () {
                // Implement navigation to settings page here
              },
            ),
            ListTile(
              leading: Icon(Iconsax.camera),
              title: Text('Camera'),
              onTap: () {
                // Implement navigation to settings page here
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
                // Implement navigation to settings page here
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
                // Implement navigation to settings page here
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // yo saab backend bata api tanera milaunu parxa, aile lai yeti hos, ui lai
                  Container(
                    width: 120,
                    color: Colors.red,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  Container(
                    width: 120,
                    color: Colors.blue,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  Container(
                    width: 120,
                    color: Colors.yellow,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  Container(
                    width: 120,
                    color: Colors.green,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 2,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3, // yo ni milaunu parxa backend batai
              itemBuilder: (context, index) {
                // backend bata chainxa yo pani
                return Container(
                  height: 400,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/Images/City.jpg"), //essai rakheko ho
                          fit: BoxFit.cover)),
                  child: Column(
                    children: [
                      Row(),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.more_vert),
                          color: Colors.white,
                          iconSize: 30,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

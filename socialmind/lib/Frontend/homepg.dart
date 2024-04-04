import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'nav.dart';
import 'background.dart';
import 'package:iconsax/iconsax.dart';

class Homepg extends StatelessWidget {
  const Homepg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Iconsax.menu_1,
            size: 34,
            color: Colors.black,
          ),
          onPressed: () {},
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
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

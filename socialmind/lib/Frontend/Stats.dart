import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:socialmind/Frontend/Bargraph/bargraph.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  List<double> AverageAppUseTime = [
    //mins, yesko data tannu parxa from firebase ki function banayera, this is just dummy data
    90,
    20,
    30,
    60,
    10,
    60,
    70,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: AppBar(
            title: Text('User Statistics'),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            leading: IconButton(
              icon: Icon(Iconsax.arrow_left),
              onPressed: () {
                Navigator.of(context).pop(); //baira niskina
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  //gradient affect on app bar
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.deepOrangeAccent,
                    // Colors.deepPurpleAccent,
                    Colors.pink,
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20), // Adjust the curve as needed
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0 * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Application usage this week',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: 55,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  child: Bargraph(
                    AverageAppUseTime:
                        AverageAppUseTime, //list or array for bargraph
                  ),
                  height: 300,
                ),
              ),
            ],
          ),
        ));
  }
}

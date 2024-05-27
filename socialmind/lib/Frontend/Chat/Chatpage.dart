import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:socialmind/Frontend/nav.dart';

class Chat extends StatelessWidget {
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
            'Messages',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0 * 2.5),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Search Messages",
                hintText: "Search",
                prefixIcon: Icon(
                  Iconsax.search_normal,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(Iconsax.personalcard),
                    ),
                    title: Text("Demo user"),
                    subtitle: Text(
                      "Last message",
                      maxLines: 1,
                    ),
                    trailing: Text(
                      "12:00 pm",
                      style: TextStyle(color: Colors.black12),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Nav(),
    );
  }
}

import 'package:flutter/material.dart';

postTemplate(String postedBy, String caption, String imageUrl) {
  return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        ListTile(title: Text(postedBy), leading: CircleAvatar()),
        Image.network(imageUrl)
      ]));
}

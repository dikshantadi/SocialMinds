import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';

class Storage {
  UploadTask? uploadTask;
  FirebaseStorage str = FirebaseStorage.instance;

  Future<String> uploadImage(File image) async {
    final fileName =
        'image/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
    print(fileName);
    try {
      final ref = str.ref().child(fileName);
      uploadTask = ref.putFile(image);
      final snapshot = await uploadTask!;
      final imageUrl = snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("error: ${e}");
    }
    return "error";
  }
}

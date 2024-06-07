import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

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

  Future deleteImage(imageUrl) async {
    try {
      final ref = str.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print(e);
    }
  }
}

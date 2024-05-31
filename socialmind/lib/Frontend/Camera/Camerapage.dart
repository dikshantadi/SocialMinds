import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:socialmind/backend/database.dart';
import 'package:socialmind/backend/storage.dart';

class CameraPage extends StatefulWidget {
  final String userName;
  const CameraPage({super.key, required this.userName});
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late List<CameraDescription> cameras;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String? _imageURL;
  XFile? img;
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize camera controller
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Initialize camera
    cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.low);
    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _openGallery() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _imageURL = imageFile.path;
        _showOptionsDialog();
      });
    }
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      setState(() {
        _imageURL = image!.path;
        _showOptionsDialog();
      });
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_imageURL != null) ...[
                kIsWeb
                    ? Image.network(_imageURL!, width: 200, height: 200)
                    : Image.file(File(_imageURL!), width: 200, height: 200),
                SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    _sharePhoto("Story");
                  },
                  child: Text('Share as Story'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    _sharePhoto("Post");
                  },
                  child: Text('Share as Post'),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _sharePhoto(String type) {
    // Implement sharing logic here
    // Retrieve the description from the text field
    String description = _descriptionController.text;

    // Show a dialog or navigate to a new screen to complete the sharing process
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Share as $type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: $description'),
              SizedBox(height: 16),
              Text('Image URL: $_imageURL'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Perform sharing logic here
                // You can upload the image to Firebase Storage and save the description to Firestore or any other action
                uploadPost();

                Navigator.of(context)
                    .popUntil((route) => route.isFirst); // Close all dialogs
              },
              child: Text('Share'),
            ),
          ],
        );
      },
    );
  }

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
            'Camera',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: Center(
        child: _imageURL == null
            ? FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller);
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )
            : Container(), // Empty container as image is displayed in the dialog
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _takePicture,
            tooltip: 'Take Picture',
            child: Icon(Icons.camera_alt),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _openGallery,
            tooltip: 'Open Gallery',
            child: Icon(Icons.photo_library),
          ),
        ],
      ),
    );
  }

  uploadPost() async {
    if (_imageURL != null) {
      Map<String, dynamic> postData = {};
      await Storage().uploadImage(File(_imageURL!)).then((value) {
        if (value != 'error') {
          String downloadUrl = value;
          postData = {
            'authorName': widget.userName,
            'authorID': FirebaseAuth.instance.currentUser!.uid,
            'time': DateTime.now().millisecondsSinceEpoch,
            'caption': _descriptionController.text,
            'imageUrl': downloadUrl
          };
        }
      });
      await Database(uid: FirebaseAuth.instance.currentUser!.uid)
          .uploadPostByUser(postData);
    }
  }
}

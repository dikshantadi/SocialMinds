// import 'dart:io';

// import 'package:flutter/material.dart';

// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;
//   const DisplayPictureScreen({super.key, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Display the Picture')),
//       // The image is stored as a file on the device. Use the `Image.file`
//       // constructor with the given path to display the image.
//       body: Image.file(File(imagePath)),
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';

class DisplayScreenPicture extends StatelessWidget {
  final File imageFile;

  const DisplayScreenPicture({Key? key, required this.imageFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Picture'),
      ),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}

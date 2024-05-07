import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gtr_app/result.dart';
import 'package:image_picker/image_picker.dart';

// Main page of the app
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // _imageFile hold the selected picture
  File? _imageFile;
  //image picker from the gallery
  Future<void> getImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

    if (_imageFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResultPage(imageFile: _imageFile!)));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Selected Image'),
            content: Image.file(_imageFile!),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  //Image picker from camera
  Future<void> getImageFromCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image captured.');
      }
    });

    if (_imageFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResultPage(imageFile: _imageFile!)));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Captured Image'),
                content: Image.file(_imageFile!),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  )
                ]);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome To The Main Page'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        //the text welcoming the user and brief tutorial
        Container(
          width: screenSize.width,
          padding: EdgeInsets.fromLTRB(10, 50, 10, 50),
          margin: EdgeInsets.only(bottom: 10),
          color: Colors.amber,
          child: Text(
              'Welcome to GCR App. An auto guitar chord recognizer that will help noobies determine chord from user-generated images.'),
        ),

        //import button for gallery
        Container(
            width: screenSize.width,
            padding: EdgeInsets.fromLTRB(100, 10, 100, 0),
            child: ElevatedButton(
                onPressed: () {
                  //add action here
                  //pick a picture from gallery action
                  //backend
                  getImageFromGallery(context);
                },
                child: Text('Import a picture!!!'))),

        //import button for camera
        Container(
            width: screenSize.width,
            padding: const EdgeInsets.fromLTRB(100, 10, 100, 0),
            child: ElevatedButton(
                onPressed: () {
                  getImageFromCamera(context);
                },
                child: Text('Snap A Picture!'))),
        SizedBox(
          height: 20,
        ),
      ]),
    );
  }
}

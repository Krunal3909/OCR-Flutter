import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'package:clipboard_manager/clipboard_manager.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _scanning = false;
  String _extractText = ''; // variable that contains scanned text from image.
  File _pickedImage; // image which user will select from gallery
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text('OCR App'),
      ),
      body: ListView(
        children: [
          _pickedImage == null
              ? Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image,
                    size: 100,
                  ),
                )
              : Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: FileImage(_pickedImage),
                        fit: BoxFit.fill,
                      )),
                ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: RaisedButton(
              color: Colors.teal,
              child: Text(
                'Pick Image',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                setState(() {
                  _scanning = true;
                });
                _pickedImage =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                _extractText =
                    await TesseractOcr.extractText(_pickedImage.path);
                setState(() {
                  _scanning = false;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          _scanning
              ? Center(child: CircularProgressIndicator())
              : Icon(
                  Icons.done,
                  size: 40,
                  color: Colors.green,
                ),
          SizedBox(height: 20),
          Center(
            child: SelectableText(
              // You can select text and copy from it.
              _extractText, // This variable _extractText contains the text which image gives back.
              // you can use this text in your database work by use of this _extractText variable.
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              // Here copy function will be added
              ClipboardManager.copyToClipBoard(_extractText).then((result) {
                final snackBar = SnackBar(
                  content: Text('Copied to Clipboard'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {},
                  ),
                );
                Scaffold.of(context).showSnackBar(snackBar);
              });
            },
            child: Icon(Icons.copy),
            backgroundColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}

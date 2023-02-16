import 'dart:convert';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:permission_handler/permission_handler.dart';

class DataUpload extends StatefulWidget {
  const DataUpload({super.key});

  @override
  State<DataUpload> createState() => _DataUploadState();
}

class _DataUploadState extends State<DataUpload> {

  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? uploadimage;

  Future<void> chooseImage() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      uploadimage = File(choosedimage!.path);
    });
  }

  Future<void> uploadData() async {
    var uploadurl = Uri.parse('http://192.168.0.102/example/imagedata.php');
    try {
      List<int> imageBytes = await uploadimage!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      var response = await http.post(uploadurl, body: {
        'image': baseimage,
        "name": name.text,
        "description": description.text,
      });
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["error"]) {
          print(jsondata["msg"]);
          log(jsondata["msg"].toString());
        } else {
          print("Upload Successfully");
          log("Uploaded sucessfully");
        }
      } else {
        print("Error during connecting to server");
        log("Error during connecting to server");
      }
    } catch (e) {
      print("Error during converting to base64");
      log("Error during converting to base 64");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Add Imaage"),
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: name,
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter image name',
                  hintText: 'Image name',
                  prefixIcon: Icon(Icons.title),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                maxLines: 5,
                controller: description,
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter image description',
                  hintText: 'Image description',
                  prefixIcon: Icon(Icons.text_snippet_outlined),
                ),
              ),
            ),
            Container(
              child: uploadimage == null
                  ? Container()
                  : SizedBox(
                      height: 150,
                      child: Image.file(uploadimage!),
                    ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                chooseImage();
              },
              // onPressed: () async {
              //   PermissionStatus gallerystatus = await Permission.photos.request();

              //   if(gallerystatus == PermissionStatus.granted){

              //   chooseImage();
              //   }

              //   if(gallerystatus == PermissionStatus.denied){
              //     openAppSettings();
              //   }
                
              // },
              icon: Icon(Icons.folder_open),
              label: Text("CHOOSE IMAGE"),
            ),
            
            Container(
              child: uploadimage == null ? Container(): ElevatedButton.icon(
              onPressed: () {
                uploadData();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => homepage(username: '', password: '')));
              },
              icon: Icon(Icons.file_upload),
              label: Text("UPLOAD IMAGE"),
            ),
            )
          ],
        ),
      ),
    );
  }
}
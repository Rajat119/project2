import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'dataupload.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({super.key});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {

  late List imagedata;
  Future<String> getImageData() async {
    var response = await http.post(
        Uri.http("192.168.0.102", '/example/imagelist.php', {'q': '{http}'}));
    setState(() {
      imagedata = json.decode(response.body);
    });
    return "Success";
  }

  @override
  void initState() {
    getImageData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
        actions: <Widget>[
          IconButton(
              onPressed: () => {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => DataUpload()))
                  },
              icon: Icon(
                Icons.add_circle_outline_sharp,
                color: Colors.white,
              ))
        ],
      ),
      body: FutureBuilder<String>(
          future: getImageData(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      children: [
                        Image.network(
                          'http://192.168.0.102/example/${imagedata[index]["image"]}',
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            imagedata[index]["name"] +
                                ": " +
                                imagedata[index]["description"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 24.0),
                          ),
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                  );
                },
                itemCount: imagedata == null ? 0 : imagedata.length,
              );
            } else {
              return Center(
                child: Container(
                  
                ),
              );
            }
          }),
    );
  }
}
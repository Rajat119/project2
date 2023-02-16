//THIS IS TO CREATE CONNECTION OF THE APP TO THE MONGO ATLAS

import 'dart:developer';

import 'package:flutter_application_1/mongodb/constants.dart';
import 'package:flutter_application_1/mongodb/mongodbmodel.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {

  static var db, userCollection;
  static connect() async {
    db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    print('CONNECTED..........');
    userCollection = db.collection(USER_COLLECTION);

  } 

  //FUNTION WHEN CALLED WILL INSERT THE DATA INTO THE DATABASE
  static Future<String> insert(Welcome data) async{
    try {

      var result = await userCollection.insertOne(data.toJson());
      if(result.isSuccess){
        return "Data Inserted";
      } else {
        return "Something went wrong";
      }

    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  } 


}
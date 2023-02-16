import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_authentication/auth.dart';
import 'package:flutter_application_1/mongodb/mongodb.dart';
import 'package:flutter_application_1/mongodb/mongodbmodel.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final _formkey = GlobalKey<FormState>();

  final TextEditingController emailcontroller = new TextEditingController();
  final TextEditingController passwordcontroller = new TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      new TextEditingController();
  final TextEditingController usernamecontroller = new TextEditingController();
  final TextEditingController namecontroller = new TextEditingController();
  final TextEditingController mobilecontroller = new TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;

  Future<void> signup() async {
    try {
      if (usernamecontroller.text.isNotEmpty ||
          namecontroller.text.isNotEmpty ||
          mobilecontroller.text.isNotEmpty ||
          emailcontroller.text.isNotEmpty ||
          passwordcontroller.text.isNotEmpty ||
          confirmpasswordcontroller.text.isNotEmpty) {
        if (passwordcontroller.text == confirmpasswordcontroller.text) {
          FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailcontroller.text,
                  password: passwordcontroller.text)
              .then((value) async {
            _insertData(
                emailcontroller.text,
                passwordcontroller.text,
                usernamecontroller.text,
                namecontroller.text,
                mobilecontroller.text);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginPage()));
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Password did not match")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("one of the field is empty")));
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromRGBO(27, 48, 255, 1.0),
                Color.fromRGBO(27, 48, 255, 1.0),
                Color.fromRGBO(27, 110, 255, 1.0),
                Color.fromRGBO(27, 170, 255, 1.0),
                Color.fromRGBO(27, 227, 255, 1.0),
                Color.fromRGBO(255, 255, 255, 1.0),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                  child: Container(
                margin: EdgeInsets.all(12.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 140,
                      ),
                      TextFormField(
                        controller: emailcontroller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.white70,
                          ),
                          filled: true,
                          fillColor: Colors.white70.withOpacity(0.3),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.normal),
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 15.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(style: BorderStyle.none),
                            borderRadius: new BorderRadius.circular(30),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(style: BorderStyle.none),
                            borderRadius: new BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value!.length == 0) {
                            return "Email cannot be empty";
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please enter a valid email");
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {},
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      TextFormField(
                        obscureText: _isObscure,
                        controller: passwordcontroller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.white70,
                          ),
                          suffixIcon: IconButton(
                              color: Colors.white70,
                              icon: Icon(_isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              }),
                          filled: true,
                          fillColor: Colors.white70.withOpacity(0.3),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.normal),
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 15.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(style: BorderStyle.none),
                            borderRadius: new BorderRadius.circular(30),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(style: BorderStyle.none),
                            borderRadius: new BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return "Password cannot be empty";
                          }
                          if (!regex.hasMatch(value)) {
                            return ("please enter valid password min. 6 character");
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {},
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      TextFormField(
                        obscureText: _isObscure2,
                        controller: confirmpasswordcontroller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.white70,
                          ),
                          suffixIcon: IconButton(
                              color: Colors.white70,
                              icon: Icon(_isObscure2
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isObscure2 = !_isObscure2;
                                });
                              }),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.3),
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.normal),
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 15.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(style: BorderStyle.none),
                            borderRadius: new BorderRadius.circular(30),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(style: BorderStyle.none),
                            borderRadius: new BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (confirmpasswordcontroller.text !=
                              passwordcontroller.text) {
                            return "Password did not match";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {},
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: usernamecontroller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.white70,
                          ),
                          filled: true,
                          fillColor: Colors.white70.withOpacity(0.3),
                          hintText: 'User Name',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.normal),
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 15.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(style: BorderStyle.none),
                            borderRadius: new BorderRadius.circular(30),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(style: BorderStyle.none),
                            borderRadius: new BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if(usernamecontroller.text.isEmpty){
                            return "Fill the detail";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {},
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      TextFormField(
                        controller: namecontroller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.white70,
                          ),
                          filled: true,
                          fillColor: Colors.white70.withOpacity(0.3),
                          hintText: 'Name',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.normal),
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 15.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(style: BorderStyle.none),
                            borderRadius: new BorderRadius.circular(30),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(style: BorderStyle.none),
                            borderRadius: new BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if(namecontroller.text.isEmpty){
                            return "Fill the detail";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {},
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      TextFormField(
                        controller: mobilecontroller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.white70,
                          ),
                          filled: true,
                          fillColor: Colors.white70.withOpacity(0.3),
                          hintText: 'Phone number',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.normal),
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 15.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(style: BorderStyle.none),
                            borderRadius: new BorderRadius.circular(30),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(style: BorderStyle.none),
                            borderRadius: new BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if(mobilecontroller.text.isEmpty){
                            return "Fill the detail";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {},
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            elevation: 5.0,
                            height: 40,
                            minWidth: MediaQuery.of(context).size.width * 0.9,
                            onPressed: () {
                              // if (emailcontroller.text.isEmpty || passwordcontroller.text.isEmpty || firstnamecontroller.text.isEmpty || lastnamecontroller.text.isEmpty || mobilecontroller.text.isEmpty){
                              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter details in the field")));
                              // } else {
                              //   _insertData(
                              //     emailcontroller.text,
                              //     passwordcontroller.text,
                              //     firstnamecontroller.text,
                              //     lastnamecontroller.text,
                              //     mobilecontroller.text);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => LoginPage()));
                              // signup();
                              // }
                              if (_formkey.currentState!.validate()) {
                                _formkey.currentState!.save();
                                // _insertData(
                                //     emailcontroller.text,
                                //     passwordcontroller.text,
                                //     firstnamecontroller.text,
                                //     lastnamecontroller.text,
                                //     mobilecontroller.text);
                                signup();
                                
                              }
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            color: Colors.white,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _insertData(String email, String password, String fname,
      String lname, String phone) async {
    var _id = M.ObjectId();
    //This will create unique id

    final data = Welcome(
        id: _id,
        email: emailcontroller.text,
        password: passwordcontroller.text,
        username: usernamecontroller.text,
        name: namecontroller.text,
        phone: mobilecontroller.text);

    var result = await MongoDatabase.insert(data);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Inserted ID: " + _id.$oid)));
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_authentication/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/screens/logout.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';

  bool _isObscure3 = true;

  bool visible = false;
  String username = "";
  String pass = "";
  final _formkey = GlobalKey<FormState>();
   TextEditingController emailController = new TextEditingController();
   TextEditingController passwordController = new TextEditingController();

  

  Future<void> signin() async {
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text).then((value) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => homepage(password: passwordController.text, username: emailController.text,)));
            setState(() {
              username = emailController.text;
              pass = passwordController.text;
            });
      // Navigator.pop(context);
          });
      // Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log("No user found");
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Incorrect email"),
              );
            });
      } else if (e.code == 'wrong-password') {
        log("Wrong password");
        // Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("wrong password"),
              );
            });
      } else {
        // Navigator.of(context).pop();
        log(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromRGBO(27, 48, 255, 1.0),
            Color.fromRGBO(27, 48, 255, 1.0),
            Color.fromRGBO(27, 110, 255, 1.0),
            Color.fromRGBO(27, 170, 255, 1.0),
            Color.fromRGBO(27, 227, 255, 1.0),
            Color.fromRGBO(255, 255, 255, 1.0),
            Color.fromRGBO(255, 255, 255, 1.0),
            Color.fromRGBO(255, 255, 255, 1.0)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.15, 20, 0),
              ),
              Image.asset(
                'assets/logo.png',
                fit: BoxFit.fitWidth,
                width: 140,
                height: 140,
                color: Colors.white,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.50,
                child: Center(
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 23),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.3),
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(0.9)),
                                enabled: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 20.0, top: 20.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(style: BorderStyle.none),
                                  borderRadius: new BorderRadius.circular(30),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(style: BorderStyle.none),
                                  borderRadius: new BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value!.length == 0) {
                                  return "Email cannot be empty";
                                }
                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return "Please enter a valid Email";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                emailController.text = value!;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: passwordController,
                              obscureText: _isObscure3,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white70,
                                ),
                                suffixIcon: IconButton(
                                    color: Colors.white,
                                    icon: Icon(_isObscure3
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure3 = !_isObscure3;
                                      });
                                    }),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.3),
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(0.99)),
                                enabled: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 20.0, top: 20.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(style: BorderStyle.none),
                                  borderRadius: new BorderRadius.circular(30),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(style: BorderStyle.none),
                                  borderRadius: new BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                RegExp regex = new RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Password cannot be empty")));
                                  return 'Password cannot be empty';
                                }
                                if (!regex.hasMatch(value)) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter a valid password")));
                                  return 'please enter valid password minimum 6 character';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                passwordController.text = value!;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 90,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                              elevation: 3.0,
                              height: 50,
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.85,
                              // onPressed: () async{
                              //   if (emailController.text.isEmpty || passwordController.text.isEmpty){
                              //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter details in the field")));
                              //   } else {
                              //     signin();
                              //   }
                              // },
                              onPressed: () {
                                if(_formkey.currentState!.validate()) {
                                  _formkey.currentState!.save();
                                  signin();
                                  // Navigator.push(context, MaterialPageRoute(builder: ((context) => homePage())));
                                  
                                }
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(fontSize: 20),
                              ),
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Visibility(
                            //     maintainSize: true,
                            //     maintainAnimation: true,
                            //     maintainState: true,
                            //     visible: visible,
                            //     child: Container(
                            //         child: CircularProgressIndicator(
                            //       color: Colors.white,
                            //     ))),
                          ],
                        ),
                      )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have account ?",
                    style: TextStyle(color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                    child: const Text("Sign Up",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_project_demo/screen/home/home_page.dart';
import 'package:iot_project_demo/screen/sign_up/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  void _saveJsonToSharedPreference(api) =>
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('user', jsonEncode(api));
        prefs.setBool('login', true);
      }
      );

  final _auth = FirebaseAuth.instance;
  bool remember = false;
  bool _passwordVisible = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 100, top: 150),
                        child: Column(
                          children: [
                            Text('Welcome back!', style: TextStyle(
                                fontSize: 35,
                                // fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),),
                            Text('Log back into your account             ',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white
                              ),)
                          ],
                        ),

                      ),
                    ),
                    height: 300,

                    decoration: BoxDecoration(
                        color: Color(0xff404F66),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(70))

                    ),

                  ),
                  Positioned(
                      bottom: 30,
                      right: 15,

                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text('SMART', style:
                        TextStyle(fontSize: 70, color: Color(0xff46546B)),),))


                ],
              ),
              Stack(
                children: [
                  Positioned(
                      top: 10,
                      right: 15,

                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text('HOME', style:
                        TextStyle(fontSize: 70, color: Color(0xffF7F7F7)),),)),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: 40,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 13),
                              floatingLabelBehavior: FloatingLabelBehavior
                                  .always,

                              labelText: "Your Phone",
                              labelStyle: TextStyle(
                                  color: Colors.black, fontSize: 23),
                              hintText: "Enter your phone",
                              hintStyle: TextStyle(fontSize: 20,color: Colors.black12),

                            ),


                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,

                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 13),
                              floatingLabelBehavior: FloatingLabelBehavior
                                  .always,


                              hintText: "Password",
                              hintStyle: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black12
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme
                                        .of(context)
                                        .primaryColorDark,
                                  )),
                              // suffixIcon: GestureDetector(
                              //   child: Icon(
                              //     Icons.visibility,
                              //     color: Colors.black,
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              CupertinoSwitch(
                                activeColor: Colors.blueGrey,
                                value: remember,
                                onChanged: (value) {
                                  setState(() {
                                    remember = value;
                                  });
                                },
                              ),
                              Text("Remember", style: TextStyle(
                                fontSize: 15,
                              )),
                              Spacer(),
                              GestureDetector(
                                child: Text(
                                  "Forgot?",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Container(
                color: Colors.black,
                height: 55,
                width: 250,
                child: TextButton(
                  onPressed: () async {
                    var loginkey = emailController.text;
                    var password = passwordController.text;
                      try {
                        await _auth.signInWithEmailAndPassword(
                            email: loginkey, password: password);

                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (contex) => HomePage(),
                          ),
                        );

                      } on FirebaseAuthException catch (e) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text("Ops! Login Failed"),
                            content: Text('${e.message}'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text('Okay'),
                              )
                            ],
                          ),
                        );
                        print(e);
                      }


                  },
                  child: Text('LOG IN', style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),),
                ),
              ),
              SizedBox(height: 10,),
              // Text(message, style: TextStyle(color: Colors.red,
              //     fontSize: 20),
              // ),
              // SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account? ",
                      style: TextStyle(fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

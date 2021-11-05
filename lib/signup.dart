import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/home_screen.dart';
import 'package:todo_app/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  late String email;
  late String password;
  late String username;
  final auth = FirebaseAuth.instance;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: globalFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const SizedBox(height: 150,),
                  const Text('SignUp', style: TextStyle(
                      color: color1,
                      fontSize: 40,
                      fontFamily: 'HennyPenny',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1
                  ),),
                   Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 30),
                    child: TextFormField(
                        validator: (val){
                          if (val!.isEmpty) {
                            return 'Please enter Username';
                          } else {
                            return null;
                          }
                        },
                      keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person, color: color1,),
                            labelText: 'User Name',
                            labelStyle: TextStyle(
                              color: color1,
                              fontSize: 20,
                            ),
                            hintText: 'Enter username',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 15
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: color2)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: color2)
                            )
                        ),
                        onChanged: (value) {
                          username = value;
                        }
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                    child: TextFormField(
                        validator: (val){
                          if (val!.isNotEmpty) {
                            return 'Please enter email address';
                          } else if (!val.contains('@')) {
                            return 'Email Address should be valid';
                          } else {
                            return null;
                          }
                        },
                      onChanged: (value){
                        setState(() {
                          email = value;
                        });
                      },
                      keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email, color: color1,),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: color1,
                              fontSize: 20,
                            ),
                            hintText: 'Enter email address',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 15
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: color2)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: color2)
                            )
                        )
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 50),
                    child: TextFormField(
                        validator: (val){
                          if (val!.isEmpty) {
                            return 'Please enter password';
                          } else if (val.length < 6) {
                            return 'Password should be more than 6 characters';
                          } else {
                            return null;
                          }
                        },
                      obscureText: hidePassword,
                        onChanged: (value){
                        setState(() {
                          password = value;
                        });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock, color: color1,),
                            suffixIcon: IconButton(
                              icon: Icon( hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              color: color1,
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                            ),
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              color: color1,
                              fontSize: 20,
                            ),
                            hintText: 'Enter password',
                            hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: color2)
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: color2)
                            )
                        )
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (globalFormKey.currentState!.validate()) {
                        globalFormKey.currentState!.save();
                        print('validated');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Blank field not allowed')));
                      }
                      try {
                        final newUser = await auth.createUserWithEmailAndPassword(email: email, password: password);
                        if(newUser != null){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                        }
                      }on SocketException {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No Internet, Please connect to the internet')));
                      }
                      catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Invalid Credentials')));
                      }
                    },
                    child: const Text('SignUp', style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontFamily: 'CrimsonText',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1
                    ),),
                    style: ElevatedButton.styleFrom(
                        primary: color1,
                        fixedSize: const Size(150, 50)
                    ),
                  ),
                  const SizedBox(height: 50,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Already have an account?",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18
                        ),
                        children: <TextSpan>[
                          TextSpan(text: ' Login',
                              style: TextStyle(
                                  color: color1,
                                  fontSize: 18,
                                  fontFamily: 'CrimsonText',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}

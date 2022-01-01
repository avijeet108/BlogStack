import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blog_stack/services/user_model.dart';
import 'package:blog_stack/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:blog_stack/screens/login.dart';

class Reg extends StatefulWidget {
  @override
  _RegState createState() => _RegState();
}

class _RegState extends State<Reg> {
  final _formkey = GlobalKey<FormState>();

  final usernameController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  bool _secure = false;
  bool _passshow = true;

  showhide() {
    setState(() {
      _secure = !_secure;
      _passshow = !_passshow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Blog",
                          style: TextStyle(
                              fontSize: 40.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Stack",
                          style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: usernameController,
                          onSaved: (value) {
                            usernameController.text = value!;
                          },
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{3,}$');
                            if (value!.isEmpty) {
                              return ("Name cannot be empty");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter a valid name(min 3 characters)");
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          cursorHeight: 22.0,
                          autofocus: false,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: emailController,
                          onSaved: (value) {
                            emailController.text = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please enter your email");
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.white,
                          cursorHeight: 22.0,
                          autofocus: false,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.blue,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: passwordController,
                          onSaved: (value) {
                            passwordController.text = value!;
                          },
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return ("Password is required for login");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter valid password(min 6 characters)");
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          cursorHeight: 22.0,
                          autofocus: false,
                          obscureText: _passshow,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: Colors.blue,
                            ),
                            suffixIcon: IconButton(
                              onPressed: showhide,
                              icon: Icon(
                                _secure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.blue,
                              ),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        elevation: 15.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        signup(emailController.text, passwordController.text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          'SignUp',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          ' LogIn',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signup(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postdetails()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postdetails() async {
    FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel usermodel = UserModel();

    usermodel.email = user!.email;
    usermodel.uid = user.uid;
    usermodel.username = usernameController.text;

    await firebasefirestore
        .collection('blogs')
        .doc(user.uid)
        .set(usermodel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");

    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
  }
}

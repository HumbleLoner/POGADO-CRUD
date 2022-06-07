// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eldroid/LoginScreen.dart';
import 'package:eldroid/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;
  UserModel loggedInUser = UserModel();

  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final birthdateEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("Accounts")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        firstNameEditingController.text = '${loggedInUser.firstName}';
        secondNameEditingController.text = '${loggedInUser.secondName}';
        emailEditingController.text = '${loggedInUser.email}';
        passwordEditingController.text = '${loggedInUser.password}';
        birthdateEditingController.text = '${loggedInUser.birthdate}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstNameField = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      ),
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final secondNameField = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      ),
      controller: secondNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Second Name cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        secondNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final emailField = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      ),
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final birthdateField = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.cake),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      ),
      controller: birthdateEditingController,
      readOnly: true,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Birthdate cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        birthdateEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1000),
            lastDate: DateTime(3000));

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            birthdateEditingController.text =
                formattedDate; //set output date to TextField value.
          });
        }
      },
    );

    final passwordField = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      ),
      controller: passwordEditingController,
      //obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    /*final updateButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          onPressed: () {
            FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
            User? user = _auth.currentUser;

            final conductor =
                firebaseFirestore.collection("Conductor").doc(user.uid);
            if (firstNameEditingController.text.isNotEmpty) {
              conductor.update({'firstName': firstNameEditingController.text});
            } else if (firstNameEditingController.text.isEmpty) {
              Fluttertoast.showToast(msg: 'Enter first name');
            }
            if (secondNameEditingController.text.isNotEmpty) {
              conductor
                  .update({'secondName': secondNameEditingController.text});
            } else if (secondNameEditingController.text.isEmpty) {
              Fluttertoast.showToast(msg: 'Enter second name');
            }
            if (passwordEditingController.text.isNotEmpty) {
              user.updatePassword(passwordEditingController.text);
              conductor.update({'password': passwordEditingController.text});
            } else if (passwordEditingController.text.isEmpty) {
              Fluttertoast.showToast(msg: 'Enter password');
            }
            if (emailEditingController.text.isNotEmpty) {
              user.updateEmail(emailEditingController.text);
              conductor.update({'email': emailEditingController.text});
            } else if (emailEditingController.text.isEmpty) {
              Fluttertoast.showToast(msg: 'Enter email');
            }
            setState(() {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LandingScreen(index: 4),
              ));
            });
            Fluttertoast.showToast(msg: "Account Updated");
          },
          child: Text(
            "Update",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );*/

    final logoutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          onPressed: () {
            logout(context);
          },
          child: Text(
            "Logout",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: Form(
          key: _formKey,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                /*Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover, image: AssetImage(''))),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            splashColor: Colors.white,
                            color: Colors.black,
                            onPressed: () {},
                          ),
                        ),
                      )
                    ],
                  ),
                ),*/
                SizedBox(height: 30),
                firstNameField,
                SizedBox(height: 18),
                secondNameField,
                SizedBox(height: 18),
                birthdateField,
                SizedBox(height: 18),
                emailField,
                SizedBox(height: 18),
                passwordField,
                SizedBox(height: 30),
                //updateButton,
                SizedBox(height: 18),
                logoutButton,
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
}

// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eldroid/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'RegistrationScreen.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  AddItemPage createState() => AddItemPage();
}

class AddItemPage extends State<AddItemScreen> {
  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();

  final itemNameEditingController = TextEditingController();
  final quantityEditingController = TextEditingController();
  final priceEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final itemName = TextFormField(
        autofocus: false,
        controller: itemNameEditingController,
        validator: (value) {
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          itemNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: 'Item Name',
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final quantity = TextFormField(
        autofocus: false,
        controller: quantityEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Quantity cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          quantityEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: 'Quantity',
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final price = TextFormField(
        autofocus: false,
        controller: priceEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Price cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          priceEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: 'Price',
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final additemButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            itemChecker();
          },
          child: Text(
            "Add Item",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 5),
                    itemName,
                    SizedBox(height: 20),
                    quantity,
                    SizedBox(height: 20),
                    price,
                    SizedBox(height: 20),
                    additemButton
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void itemChecker() {
    if (_formKey.currentState!.validate()) {
      postDetailsToFirestore();
    }
  }

  postDetailsToFirestore() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Items').get();
    final itemName =
        querySnapshot.docs.map((doc) => doc.get('itemName')).toList();
    if (itemName.any((e) => e == (itemNameEditingController.text))) {
      Fluttertoast.showToast(msg: "Item Already Exist");
    } else {
      CollectionReference ref =
          await FirebaseFirestore.instance.collection('Items');

      String docId = ref.doc().id;

      await ref.doc(docId).set({
        'itemName': itemNameEditingController.text,
        'quantity': quantityEditingController.text,
        'price': priceEditingController.text,
        'uid': docId
      });

      Fluttertoast.showToast(msg: "Item Added");
    }
  }
}

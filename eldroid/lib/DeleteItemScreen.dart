// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eldroid/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'RegistrationScreen.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  ItemPage createState() => ItemPage();
}

class ItemPage extends State<ItemScreen> {
  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  itemModel item = itemModel();
  String uid = "";

  final itemSearchEditingController = TextEditingController();
  final itemNameEditingController = TextEditingController();
  final quantityEditingController = TextEditingController();
  final priceEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final itemSearch = TextFormField(
        autofocus: false,
        controller: itemSearchEditingController,
        validator: (value) {
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          itemSearchEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: 'Search Item',
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
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
    final updateItemButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            updateItem();
          },
          child: Text(
            "Update Item",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    final deleteItemButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            deleteItem();
          },
          child: Text(
            "Delete Item",
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
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              width: 290,
                              child: itemSearch,
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                searchChecker();
                              },
                              icon: Icon(Icons.search),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    itemName,
                    SizedBox(height: 20),
                    quantity,
                    SizedBox(height: 20),
                    price,
                    SizedBox(height: 20),
                    updateItemButton,
                    SizedBox(height: 20),
                    deleteItemButton
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> searchChecker() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Items').get();
    final itemName =
        querySnapshot.docs.map((doc) => doc.get('itemName')).toList();
    if (itemName.any((e) => e == itemSearchEditingController.text)) {
      FirebaseFirestore.instance
          .collection('Items')
          .where('itemName', isEqualTo: itemSearchEditingController.text)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          setState(() {
            itemNameEditingController.text = doc.data()['itemName'];
            quantityEditingController.text = doc.data()['quantity'];
            priceEditingController.text = doc.data()['price'];
            uid = doc.data()['uid'];
          });
        });
      });
    } else {
      Fluttertoast.showToast(msg: "Item not found");
      setState(() {
        itemNameEditingController.text = "";
        quantityEditingController.text = "";
        priceEditingController.text = "";
      });
    }
  }

  Future<void> updateItem() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Items').get();
    final itemName =
        querySnapshot.docs.map((doc) => doc.get('itemName')).toList();
    if (itemName.any((e) => e == (itemSearchEditingController.text))) {
      FirebaseFirestore.instance
          .collection('Items')
          .where('itemName', isEqualTo: itemSearchEditingController.text)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          setState(() {
            String uid = doc.data()['uid'];
            final itemUpdate =
                FirebaseFirestore.instance.collection('Items').doc(uid);

            if (itemNameEditingController.text.isNotEmpty) {
              itemUpdate.update({'itemName': itemNameEditingController.text});
            }
            if (quantityEditingController.text.isNotEmpty) {
              itemUpdate.update({'quantity': quantityEditingController.text});
            }
            if (priceEditingController.text.isNotEmpty) {
              itemUpdate.update({'price': priceEditingController.text});
            }
            Fluttertoast.showToast(msg: "Item Updated");
          });
        });
      });
    } else {
      Fluttertoast.showToast(msg: "Item not found");
    }
  }

  Future<void> deleteItem() async {
    FirebaseFirestore.instance
        .collection("Items")
        .where("itemName", isEqualTo: itemSearchEditingController.text)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("Items")
            .doc(element.id)
            .delete()
            .then((value) {
          Fluttertoast.showToast(msg: "Item Deleted");
          setState(() {
            itemNameEditingController.text = "";
            quantityEditingController.text = "";
            priceEditingController.text = "";
          });
        });
      });
    });
  }
}

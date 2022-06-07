// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_this, unnecessary_new
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({Key? key}) : super(key: key);

  @override
  ItemPage createState() => ItemPage();
}

class ItemPage extends State<ItemListScreen> {
  final itemNameEditingController = TextEditingController();

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
      decoration: InputDecoration(
        labelText: 'Item Name',
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: 140,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 50,
                      left: 0,
                      child: Container(
                        height: 70,
                        width: 260,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            )),
                      )),
                  Positioned(
                      top: 60,
                      left: 15,
                      child: Text(
                        "Items",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ))
                ],
              ),
            ),
            Expanded(
                child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Items')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Text("Loading");
                          }

                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data = document.data()!;
                              return Container(
                                margin:
                                    const EdgeInsets.only(bottom: 5, top: 20),
                                //outer padding of the cardDetails
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  //inner padding of the cardDetails
                                  padding: EdgeInsets.all(10),
                                  child: InkWell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Row(children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 300,
                                                  child: ListTile(
                                                    title: Text(
                                                      "Item Name: " +
                                                          data['itemName'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18),
                                                    ),
                                                    subtitle: Text(
                                                      "Quantity : \t" +
                                                          data['quantity'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }))),
          ],
        ));
  }
}

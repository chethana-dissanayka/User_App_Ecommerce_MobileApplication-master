import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';

Widget fetchData (String collectionName){
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection(collectionName)
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .snapshots(),
    builder:
        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text("Something is wrong"),
        );
      }

      return ListView.builder(
          itemCount:
          snapshot.data == null ? 0 : snapshot.data!.docs.length,
          itemBuilder: (_, index) {
            DocumentSnapshot _documentSnapshot =
            snapshot.data!.docs[index];

            return Card(
              elevation: 5,
              child: ListTile(
                leading: Image.network(
                 _documentSnapshot["url"],fit: BoxFit.fill,
                    ),
                title: Text(_documentSnapshot['name'],
                style: TextStyle(fontWeight: FontWeight.bold),),
                
                subtitle: Text(
                  "\Rs ${_documentSnapshot['price']}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red),
                ),
               trailing: GestureDetector(
  child: CircleAvatar(
    child: Icon(Icons.remove_circle),
  ),
  onTap: () {
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .doc(_documentSnapshot.id)
        .delete();

    
    Flushbar(
      message: "Item removed from cart",
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red, 
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.GROUNDED,
      borderRadius: BorderRadius.circular(10),
      margin: EdgeInsets.all(8),
      animationDuration: Duration(milliseconds: 500),
    ).show(context);
  },
),
),
            );
            
          });
    },
  );
}
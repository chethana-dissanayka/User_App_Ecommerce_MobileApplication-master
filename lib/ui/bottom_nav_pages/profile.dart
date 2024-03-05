import 'package:appecommerce/const/AppColors.dart';
import 'package:appecommerce/ui/orderhistorypage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      
      Flushbar(
        message: "Logout Successfully",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.GROUNDED,
        borderRadius: BorderRadius.circular(10),
        margin: EdgeInsets.all(8),
        animationDuration: Duration(milliseconds: 500),
      )..show(context).then((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } catch (error) {
      print("Error signing out: $error");

      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign out. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  setDataToTextField(data) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Account holder's Name:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _nameController = TextEditingController(text: data['name']),
            ),
          ],
        ),
        SizedBox(height: 15), 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Account holder's Phone No:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _phoneController = TextEditingController(text: data['phone']),
            ),
          ],
        ),
        SizedBox(height: 15), 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Account holder's Age:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _ageController = TextEditingController(text: data['age']),
            ),
          ],
        ),
        SizedBox(height: 40), 
        ElevatedButton(
          onPressed: () => updateData(),
          child: Text(
            "Update account details",
            style: TextStyle(fontSize: 28), 
          ),
          style: ElevatedButton.styleFrom(
            primary: AppColors.deep_orange, 
            onPrimary: Colors.white, 
          ),
        ),
      ],
    );
  }

  Future<void> updateData() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    try {
      await _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
        "name": _nameController.text,
        "phone": _phoneController.text,
        "age": _ageController.text,
      });

      
      Flushbar(
        message: "User Details UPDATED",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.GROUNDED,
        borderRadius: BorderRadius.circular(10),
        margin: EdgeInsets.all(8),
        animationDuration: Duration(milliseconds: 500),
      )..show(context);

      print("Updated Successfully");
    } catch (error) {
      print("Error updating user details: $error");

      
      Flushbar(
        message: "Failed to update user details. Please try again.",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.GROUNDED,
        borderRadius: BorderRadius.circular(10),
        margin: EdgeInsets.all(8),
        animationDuration: Duration(milliseconds: 500),
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  leading: Padding(
    padding: const EdgeInsets.all(8.0),
    child: CircleAvatar(
      backgroundColor: AppColors.deep_orange,
      child: IconButton(
        onPressed: () {
          
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderHistoryPage()),
          );
        },
        icon: Icon(
          Icons.dataset,
          color: Colors.white,
        ),
      ),
    ),
  ),
  actions: [
    
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: AppColors.deep_orange,
        child: IconButton(
          onPressed: () => signOut(context), 
          icon: Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ],
  flexibleSpace: Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/back.png"),
        fit: BoxFit.cover,
      ),
    ),
  ),
),

      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/back.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users-form-data")
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                var data = snapshot.data;
                if (data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return setDataToTextField(data);
              },
            ),
          ),
        ),
      ),
    );
  }
}

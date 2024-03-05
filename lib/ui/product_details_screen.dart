import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appecommerce/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';

class ProductDetails extends StatefulWidget {
  var _product;
  ProductDetails(this._product);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
 Future addToCart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-cart-items");
    await _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._product["name"],
      "price": widget._product["price"],
      
      "url": widget._product["url"],
    });

    
  Flushbar(
  message: "Item added to cart",
  duration: Duration(seconds: 2),
  backgroundColor: Colors.green,
  flushbarPosition: FlushbarPosition.BOTTOM,
  flushbarStyle: FlushbarStyle.GROUNDED,
  borderRadius: BorderRadius.circular(10),  
  margin: EdgeInsets.all(8),
  animationDuration: Duration(milliseconds: 500),
).show(context);

  }

 Future addToFavourite() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var currentUser = _auth.currentUser;
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection("users-favourite-items");
  await _collectionRef
      .doc(currentUser!.email)
      .collection("items")
      .doc()
      .set({
    "name": widget._product["name"],
    "price": widget._product["price"],
    "url": widget._product["url"],
  });

  
  Flushbar(
    message: "Item added to favorites",
    duration: Duration(seconds: 2),
    backgroundColor: Colors.blue, 
    flushbarPosition: FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.GROUNDED,
    borderRadius: BorderRadius.circular(10),
    margin: EdgeInsets.all(8),
    animationDuration: Duration(milliseconds: 500),
  ).show(context);
}
  @override
  Widget build(BuildContext context) {
    var url = widget._product['url'];
    List<String> imageList = url is List<String> ? url : [url];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.deep_orange,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ),
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users-favourite-items")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection("items")
                .where("name", isEqualTo: widget._product['name'])
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Text("");
              }
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.pink,
                  child: IconButton(
                    onPressed: () => snapshot.data.docs.length == 0
                        ? addToFavourite()
                        : print("Already Added"),
                    icon: snapshot.data.docs.length == 0
                        ? Icon(
                            Icons.favorite_outline,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: CarouselSlider(
                  items: imageList
                      .map<Widget>((item) => Padding(
                            padding: const EdgeInsets.only(left: 3, right: 3),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(item),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (val, carouselPageChangedReason) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              Text(
                widget._product['name'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              Text(
                widget._product['category'],
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              Text(
                widget._product['brand'],
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              
              
              Text(widget._product['description']),
              SizedBox(
                height: 10,
              ),
              Text(
                "\Rs ${widget._product['price'].toString()}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.pink,
                ),
              ),
              Divider(),
              SizedBox(
                width: 1.sw,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () => addToCart(),
                  child: Text(
                    "Add to cart",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.deep_orange,
                    elevation: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

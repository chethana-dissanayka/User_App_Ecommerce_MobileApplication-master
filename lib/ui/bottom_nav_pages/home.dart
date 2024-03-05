import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appecommerce/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../product_details_screen.dart';
import '../search_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _carouselImages = [];
  var _dotPosition = 0;
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;

  fetchCarouselImages() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["image"],
        );
        print(qn.docs[i]["image"]);
      }
    });

    return qn.docs;
  }

  fetchProducts() async {
    QuerySnapshot qn = await _firestoreInstance.collection("bproducts").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({
          "name": qn.docs[i]["name"],
          "price": qn.docs[i]["price"],
          "brand": qn.docs[i]["brand"],
          "url": qn.docs[i]["url"],
          "category": qn.docs[i]["category"],
          "usertype": qn.docs[i]["usertype"],
          "description": qn.docs[i]["description"],
        });
      }
    });

    return qn.docs;
  }

  ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0);


  @override
  void initState() {
    fetchCarouselImages();
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration:
            BoxDecoration(
  color: const Color.fromARGB(255, 245, 227, 233),
  image: DecorationImage(
    image: AssetImage("assets/back.png"),
    fit: BoxFit.cover,
  ),
),

        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
  readOnly: true,
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: "Search products here",
    hintStyle: TextStyle(fontSize: 15.sp, color: Colors.pink[400]),
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
    prefixIcon: Icon(Icons.search, color: Colors.pink[400]),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: Colors.pink),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: Colors.grey),
    ),
    
  ),
  onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => SearchScreen())),
),

              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            AspectRatio(
              aspectRatio: 2.5,
              child: CarouselSlider(
                  items: _carouselImages
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(left: 3, right: 3),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(item),
                                      fit: BoxFit.fill)),
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (val, carouselPageChangedReason) {
                        setState(() {
                          _dotPosition = val;
                        });
                      })),
            ),
            SizedBox(
              height: 10.h,
            ),
            DotsIndicator(
              dotsCount:
                  _carouselImages.length == 0 ? 1 : _carouselImages.length,
              position: _dotPosition.toInt(),
              decorator: DotsDecorator(
                activeColor: AppColors.deep_orange,
                color: AppColors.deep_orange.withOpacity(0.5),
                spacing: EdgeInsets.all(4),
                activeSize: Size(8, 8),
                size: Size(6, 6),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                itemCount: _products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                ),
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProductDetails(_products[index]))),
                    child: Container(
                      child: Card(
                        elevation: 3,
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 208, 89, 232),
                                  borderRadius: BorderRadius.circular(
                                      15.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                          0.3),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      15.0),
                                  child: Image.network(
                                    _products[index]["url"],
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                            Text(
      "${_products[index]["name"]}",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black, 
      ),
    ),
    
    Text(
      "${_products[index]["brand"]}",
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    ),
    Text(
      "${_products[index]["category"]}",
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    ),
    Text(
      "Rs: ${_products[index]["price"].toString()}",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.pink[400],
      ),
    ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}

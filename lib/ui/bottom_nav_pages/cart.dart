import 'package:appecommerce/const/AppColors.dart';
import 'package:appecommerce/ui/chackout.dart';
import 'package:appecommerce/widgets/fetchProducts.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  void addToCheckout() {
    // Show processing message
    Flushbar(
      message: "Processing...",
      duration: Duration(seconds: 2),
      backgroundColor: Colors.blue,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.GROUNDED,
      borderRadius: BorderRadius.circular(10),
      margin: EdgeInsets.all(8),
      animationDuration: Duration(milliseconds: 500),
    )..show(context).then((_) {
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CheakoutPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/back.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 630,
                child: fetchData("users-cart-items"),
              ),
              SizedBox(
                width: 1.sw,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: addToCheckout,
                  child: Text(
                    "Add to Checkout",
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

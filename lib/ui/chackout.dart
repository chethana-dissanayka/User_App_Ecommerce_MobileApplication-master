import 'package:another_flushbar/flushbar.dart';
import 'package:appecommerce/const/AppColors.dart';
import 'package:appecommerce/controllers/payment_controller.dart';
import 'package:appecommerce/ui/bottom_nav_controller.dart';
import 'package:appecommerce/widgets/customButton.dart';
import 'package:appecommerce/widgets/fetchdatafinal.dart';
import 'package:appecommerce/widgets/myTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CheakoutPage extends StatefulWidget {
  List<Map<String, dynamic>>? cartItems;

  CheakoutPage({this.cartItems, Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CheakoutPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  List<String> gender = ["Deliver", "Pick up"];

  final PaymentController controller = Get.put(PaymentController());

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
  }

  Future<void> addFinalOrder() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    if (currentUser == null) {
      // Handle the case where the user is not authenticated
      print("Error: User not authenticated");
      return;
    }

    CollectionReference finalOrderCollection =
        FirebaseFirestore.instance.collection("Final_Cheakoutoders");

    CollectionReference costomeroder =
        FirebaseFirestore.instance.collection("costomer_oders");

    
    if (widget.cartItems == null || widget.cartItems!.isEmpty) {
      // Handle the case where there are no items in the cart
      print("Error: Cart is empty");

      // Show cart is empty message
      Flushbar(
        message: "Your cart is empty. Add items before confirming the order.",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.GROUNDED,
        borderRadius: BorderRadius.circular(10),
        margin: EdgeInsets.all(8),
        animationDuration: Duration(milliseconds: 500),
      )..show(context);

      return;
    }

    
    double totalCost = calculateTotalCost();

    
    DocumentReference orderDocRef = await finalOrderCollection
        .doc(currentUser.email)
        .collection("FinalorderItems")
        .add({
      "customername": _nameController.text,
      "receiversphone": _phoneController.text,
      "orderdate": _dobController.text,
      "delivermethod": _genderController.text,
      "address": _ageController.text,
      "totalCost": totalCost,
      "timestamp": FieldValue.serverTimestamp(),
      "cartItems": widget.cartItems,

      
    });

    DocumentReference orderDocRef2 = await costomeroder
        .doc(currentUser.email)
        .collection("Finalcoutmeroders")
        .add({
      "customername": _nameController.text,
      "receiversphone": _phoneController.text,
      "orderdate": _dobController.text,
      "delivermethod": _genderController.text,
      "address": _ageController.text,
      "totalCost": totalCost,
      "timestamp": FieldValue.serverTimestamp(),
      "cartItems": widget.cartItems,

      
    });

    
    await FirebaseFirestore.instance
        .collection("users-cart-items")
        .doc(currentUser.email)
        .collection("items")
        .get()
        .then((querySnapshot) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });

    // Show processing message
    Flushbar(
      message: "Saving data, CONFIRMED ORDER",
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.GROUNDED,
      borderRadius: BorderRadius.circular(10),
      margin: EdgeInsets.all(8),
      animationDuration: Duration(milliseconds: 500),
    )..show(context).then((_) {
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BottomNavController()),
        );
      });
  }

  double calculateTotalCost() {
    if (widget.cartItems == null || widget.cartItems!.isEmpty) {
      return 0.0;
    }

    double totalCost = 0.0;

    for (var item in widget.cartItems!) {
      print("Item details: $item");
      String? priceAsString = item["price"];

      if (priceAsString != null) {
        try {
          double price = double.parse(priceAsString);
          totalCost += price;
        } catch (e) {
          print("Error parsing price: $e");
          
        }
      }
    }

    return totalCost;
  }

  Future<List<Object?>> fetchCartItems() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    if (currentUser == null) {
      
      print("Error: User not authenticated");
      return [];
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users-cart-items")
          .doc(currentUser.email)
          .collection("items")
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      print("Error fetching cart items: $error");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    
    fetchCartItems().then((items) {
      setState(() {
        widget.cartItems = items.cast<Map<String, dynamic>>();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Submit the receiver's form to order.",
                style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromARGB(255, 187, 0, 91)),
              ),
              Text(
                "We will not share your information with anyone.",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 208, 0, 118),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              myTextField(
                  "enter receiver's name", TextInputType.text, _nameController),
              myTextField("receiver's phone number", TextInputType.number,
                  _phoneController),
              TextField(
                controller: _dobController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "orderd date",
                  suffixIcon: IconButton(
                    onPressed: () => _selectDateFromPicker(context),
                    icon: Icon(Icons.calendar_today_outlined),
                  ),
                ),
              ),
              TextField(
                controller: _genderController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "delivermethod",
                  prefixIcon: DropdownButton<String>(
                    items: gender.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                        onTap: () {
                          setState(() {
                            _genderController.text = value;
                          });
                        },
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ),
              ),
              myTextField(
                  "receiver's address", TextInputType.text, _ageController),

              SizedBox(
                height: 25.h,
              ),

              
              customButton("Confirm Order", () => addFinalOrder()),
              Text(
                "If You want to remove items, Go back to cart",
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 175, 2, 149)),
              ),
              Expanded(
                child: fetchDataFinal(
                  "users-cart-items",
                ),
              ),
              SizedBox(
                child: Column(
                  children: [
                    Text(
                      "Total Cost: \Rs${calculateTotalCost().toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 26.sp),
                    ),
                    SizedBox(height: 12),
                    //   InkWell(
                    //     onTap: () {
                    //       controller.makePayment(amount: '5', currency: 'USD');

                    //     },
                    //     child: Center(
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //           color: Colors.black,
                    //           borderRadius: BorderRadius.circular(20),
                    //           boxShadow: const [
                    //             BoxShadow(
                    //               color: Colors.black12,
                    //               blurRadius: 10,
                    //               offset: Offset(0, 10),
                    //             ),
                    //           ],
                    //         ),
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Text(
                    //             'Make Payment',
                    //             style: TextStyle(color: Colors.white, fontSize: 20),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
